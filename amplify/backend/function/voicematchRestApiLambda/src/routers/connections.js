const app = require('../app');
const { v4 } = require('uuid');
const { default: slugify } = require('slugify');
const { verifyToken } = require('../middlewares/auth');
const { validateFormData, IConnection, IConnectionMessage } = require('../schemas');
const { ddbUpdate, ddbDelete } = require('../utils/ddb-utils');
const { idpAdminGetUser } = require('../utils/idp-utils');
const { apsGetAll, apsMutation, apsQuery } = require('../utils/aps-utils');
const {
	listMessageByChatId,
	listConnectionByChatId,
	getMessageEvent,
	listUsers,
	getMessage,
	listMessageEventByMessageId,
	getRecording,
} = require('../gql/queries');
const { listConnectionByUserId, getConnection, listMessageEventByChatUserId } = require('../gql/queries_custom');
const {
	updateConnection,
	createConnection,
	createMessage,
	createMessageEvent,
	updateMessageEvent,
	deleteConnection,
	deleteMessageEvent,
	deleteMessage,
	updateMessage,
} = require('../gql/mutations');
const { snsPublish } = require('../utils/sns-utils');
const { s3CreatePresignedPostCommand } = require('../utils/s3-utils');

const { LIMIT, LIMIT_SEARCH_RESULTS, BATCH_SIZE } = require('../consts');

const {
	AUTH_VOICEMATCHC92D7B64_USERPOOLID: USERPOOLID,
	API_VOICEMATCHGRAPHAPI_CONNECTIONTABLE_NAME: CONNECTIONTABLE,
	API_VOICEMATCHGRAPHAPI_MESSAGETABLE_NAME: MESSAGETABLE,
	API_VOICEMATCHGRAPHAPI_MESSAGEEVENTTABLE_NAME: MESSAGEEVENTTABLE,
	SNS_CLEANUP_TOPIC_ARN,
	STORAGE_STORAGE_BUCKETNAME: BUCKETNAME,
} = process.env;

app.get('/api/v1/connections', verifyToken, async (req, res, next) => {
	const { Username: sub } = req.user;
	const connections = await apsGetAll(listConnectionByUserId, { userId: sub, sortDirection: 'DESC' }, 'listConnectionByUserId');
	return res.status(200).json(connections.filter((_filter) => _filter._deleted !== true));
});

app.get('/api/v1/connections/search', verifyToken, async (req, res, next) => {
	const { q } = req.query;
	const users = await apsGetAll(
		listUsers,
		{
			limit: LIMIT,
			filter: {
				searchTerm: { contains: slugify(q, { lower: true, trim: true }) },
			},
		},
		'listUsers'
	);
	return res.status(200).json(users.slice(0, LIMIT_SEARCH_RESULTS));
});

app.post('/api/v1/connections', verifyToken, validateFormData(IConnection), async (req, res, next) => {
	const { Username: sub } = req.user;
	const { memberId } = req.body;

	let member;
	try {
		member = await idpAdminGetUser(USERPOOLID, memberId);
	} catch (err) {
		return res.status(422).json({ message: 'Member not found' });
	}

	const connectionIdUser = `${sub}-${memberId}`;
	const connectionIdMember = `${memberId}-${sub}`;

	const chatId = [sub, memberId].sort().join('-');

	let connectionUser = (await apsQuery(getConnection, { id: connectionIdUser })).data.getConnection;
	if (!connectionUser?.id) {
		connectionUser = (
			await apsMutation(createConnection, { id: connectionIdUser, owner: sub, userId: sub, memberId, chatId, isSender: true, isReceiver: false })
		).data.createConnection;
	} else {
		await ddbUpdate(CONNECTIONTABLE, { id: connectionIdUser }, 'set #_deleted = :_deleted', { '#_deleted': '_deleted' }, { ':_deleted': false });
		let connectionUser = (await apsQuery(getConnection, { id: connectionIdUser })).data.getConnection;
		connectionUser = (await apsMutation(updateConnection, { id: connectionIdUser, _version: connectionUser._version })).data.updateConnection;
	}

	let connectionMember = (await apsQuery(getConnection, { id: connectionIdMember })).data.getConnection;
	if (!connectionMember?.id) {
		connectionMember = (
			await apsMutation(createConnection, {
				id: connectionIdMember,
				owner: memberId,
				userId: memberId,
				memberId: sub,
				chatId,
				isSender: false,
				isReceiver: true,
			})
		).data.createConnection;
	} else {
		await ddbUpdate(CONNECTIONTABLE, { id: connectionIdMember }, 'set #_deleted = :_deleted', { '#_deleted': '_deleted' }, { ':_deleted': false });
		connectionUser = (await apsMutation(updateConnection, { id: connectionIdMember, _version: connectionMember._version })).data.updateConnection;
	}

	return res.status(200).json(connectionUser);
});

app.get('/api/v1/connections/:id', verifyToken, async (req, res, next) => {
	const connection = await apsQuery(getConnection, { id: req.params.id });
	return res.status(200).json(connection.data.getConnection);
});

app.get('/api/v1/connections/:id/duration', verifyToken, async (req, res, next) => {
	const { Username: sub } = req.user;
	const connection = (await apsQuery(getConnection, { id: req.params.id })).data.getConnection;
	const chatUserId = `${connection.chatId}-${sub}`;
	const connections = await apsGetAll(listMessageEventByChatUserId, { chatUserId }, 'listMessageEventByChatUserId');
	let duration = 0;
	for (let i = 0; i < connections.length; i++) {
		duration += connections[i]?.recording?.duration || 0;
	}
	return res.status(200).json({
		connection,
		duration,
	});
});

});

/**
 * @summary
 * accpet connection request
 */
app.post('/api/v1/connections/:id/accept', verifyToken, async (req, res, next) => {
	const { Username: sub } = req.user;
	const connection = await apsQuery(getConnection, { id: req.params.id });
	if (connection.data.getConnection.userId !== sub) {
		return res.status(403).json({ message: 'Unauthorized' });
	}
	const now = new Date();
	const connections = await apsGetAll(listConnectionByChatId, { chatId: connection.data.getConnection.chatId }, 'listConnectionByChatId');
	for (let i = 0; i < connections.length; i++) {
		const { id, _version } = connections[i];
		await apsMutation(updateConnection, { id, _version, isAccepted: true, isDeclined: false, acceptedAt: now });
	}
	return res.status(200).json({});
});

/**
 * @summary
 * decline connection request
 */
app.post('/api/v1/connections/:id/decline', verifyToken, async (req, res, next) => {
	const { Username: sub } = req.user;
	const connection = await apsQuery(getConnection, { id: req.params.id });
	if (connection.data.getConnection.userId !== sub) {
		return res.status(403).json({ message: 'Unauthorized' });
	}
	const now = new Date();
	const connections = await apsGetAll(listConnectionByChatId, { chatId: connection.data.getConnection.chatId }, 'listConnectionByChatId');
	for (let i = 0; i < connections.length; i++) {
		const { id, _version } = connections[i];
		await apsMutation(updateConnection, { id, _version, isAccepted: false, isDeclined: true, declinedAt: now });
	}
	return res.status(200).json({});
});

/**
 * @summary
 * block connection
 */
app.post('/api/v1/connections/:id/block', verifyToken, async (req, res, next) => {
	const { Username: sub } = req.user;
	const connection = await apsQuery(getConnection, { id: req.params.id });
	if (connection.data.getConnection.userId !== sub) {
		return res.status(403).json({ message: 'Unauthorized' });
	}
	const connections = await apsGetAll(listConnectionByChatId, { chatId: connection.data.getConnection.chatId }, 'listConnectionByChatId');
	for (let i = 0; i < connections.length; i++) {
		const { id, _version, owner } = connections[i];
		if (owner !== sub) {
			continue;
		}
		await apsMutation(updateConnection, { id, _version, isBlocked: true, blockedAt: new Date().toISOString() });
	}
	const connectionUpdated = await apsQuery(getConnection, { id: req.params.id });
	return res.status(200).json(connectionUpdated.data.getConnection);
});

/**
 * @summary
 * unblock connection
 */
app.post('/api/v1/connections/:id/unblock', verifyToken, async (req, res, next) => {
	const { Username: sub } = req.user;
	const connection = await apsQuery(getConnection, { id: req.params.id });
	if (connection.data.getConnection.userId !== sub) {
		return res.status(403).json({ message: 'Unauthorized' });
	}
	const connections = await apsGetAll(listConnectionByChatId, { chatId: connection.data.getConnection.chatId }, 'listConnectionByChatId');
	for (let i = 0; i < connections.length; i++) {
		const { id, _version, owner } = connections[i];
		if (owner !== sub) {
			continue;
		}
		await apsMutation(updateConnection, { id, _version, isBlocked: false, blockedAt: null });
	}
	const connectionUpdated = await apsQuery(getConnection, { id: req.params.id });
	return res.status(200).json(connectionUpdated.data.getConnection);
});

/**
 * @summary
 * mute connection
 */
app.post('/api/v1/connections/:id/mute', verifyToken, async (req, res, next) => {
	const { Username: sub } = req.user;
	const connection = await apsQuery(getConnection, { id: req.params.id });
	if (connection.data.getConnection.userId !== sub) {
		return res.status(403).json({ message: 'Unauthorized' });
	}
	const connections = await apsGetAll(listConnectionByChatId, { chatId: connection.data.getConnection.chatId }, 'listConnectionByChatId');
	for (let i = 0; i < connections.length; i++) {
		const { id, _version, owner } = connections[i];
		if (owner !== sub) {
			continue;
		}
		await apsMutation(updateConnection, { id, _version, isMuted: true, mutedAt: new Date().toISOString() });
	}
	const connectionUpdated = await apsQuery(getConnection, { id: req.params.id });
	return res.status(200).json(connectionUpdated.data.getConnection);
});

/**
 * @summary
 * unmute connection
 */
app.post('/api/v1/connections/:id/unmute', verifyToken, async (req, res, next) => {
	const { Username: sub } = req.user;
	const connection = await apsQuery(getConnection, { id: req.params.id });
	if (connection.data.getConnection.userId !== sub) {
		return res.status(403).json({ message: 'Unauthorized' });
	}
	const connections = await apsGetAll(listConnectionByChatId, { chatId: connection.data.getConnection.chatId }, 'listConnectionByChatId');
	for (let i = 0; i < connections.length; i++) {
		const { id, _version, owner } = connections[i];
		if (owner !== sub) {
			continue;
		}
		await apsMutation(updateConnection, { id, _version, isMuted: false, mutedAt: null });
	}
	const connectionUpdated = await apsQuery(getConnection, { id: req.params.id });
	return res.status(200).json(connectionUpdated.data.getConnection);
});

/**
 * @summary
 * pin connection
 */
app.post('/api/v1/connections/:id/pin', verifyToken, async (req, res, next) => {
	const { Username: sub } = req.user;
	const connection = await apsQuery(getConnection, { id: req.params.id });
	if (connection.data.getConnection.userId !== sub) {
		return res.status(403).json({ message: 'Unauthorized' });
	}
	const connections = await apsGetAll(listConnectionByChatId, { chatId: connection.data.getConnection.chatId }, 'listConnectionByChatId');
	for (let i = 0; i < connections.length; i++) {
		const { id, _version, owner } = connections[i];
		if (owner !== sub) {
			continue;
		}
		await apsMutation(updateConnection, { id, _version, isPinned: true, pinnedAt: new Date().toISOString() });
	}
	const connectionUpdated = await apsQuery(getConnection, { id: req.params.id });
	return res.status(200).json(connectionUpdated.data.getConnection);
});

/**
 * @summary
 * unpin connection request
 */
app.post('/api/v1/connections/:id/unpin', verifyToken, async (req, res, next) => {
	const { Username: sub } = req.user;
	const connection = await apsQuery(getConnection, { id: req.params.id });
	if (connection.data.getConnection.userId !== sub) {
		return res.status(403).json({ message: 'Unauthorized' });
	}
	const connections = await apsGetAll(listConnectionByChatId, { chatId: connection.data.getConnection.chatId }, 'listConnectionByChatId');
	for (let i = 0; i < connections.length; i++) {
		const { id, _version, owner } = connections[i];
		if (owner !== sub) {
			continue;
		}
		await apsMutation(updateConnection, { id, _version, isPinned: false, pinnedAt: null });
	}
	const connectionUpdated = await apsQuery(getConnection, { id: req.params.id });
	return res.status(200).json(connectionUpdated.data.getConnection);
});

/**
 * @summary
 * get connection messages
 */
app.get('/api/v1/connections/:id/messages', verifyToken, async (req, res, next) => {
	const { Username: sub } = req.user;
	const { nextToken, limit } = req.query;
	const connection = (await apsQuery(getConnection, { id: req.params.id })).data.getConnection;
	const messages = await apsQuery(listMessageEventByChatUserId, {
		chatUserId: `${connection.chatId}-${sub}`,
		nextToken: nextToken?.trim()?.length ? nextToken : undefined,
		limit: limit || 100,
		sortDirection: 'DESC',
	});
	return res.status(200).json({ ...messages.data.listMessageEventByChatUserId });
});

/**
 * @summary
 * send connection message
 */
app.post('/api/v1/connections/:id/messages', verifyToken, validateFormData(IConnectionMessage), async (req, res, next) => {
	const { Username: sub } = req.user;
	const { body, isSilent, type, recordingId } = req.body;

	// get connection
	const connection = (await apsQuery(getConnection, { id: req.params.id })).data.getConnection;
	const { chatId, memberId } = connection;

	// verify ownership
	if (connection.owner !== sub) {
		return res.status(403).json({ message: 'Unauthorized' });
	}

	// const connections = await apsGetAll(listConnectionByChatId, { chatId }, 'listConnectionByChatId');
	// for (let i = 0; i < connections.length; i++) {
	// 	const { isAccepted, isDeclined, isBlocked } = connections[i];
	// 	// declined?
	// 	if (isDeclined === true) {
	// 		return res.status(403).json({ message: 'Connection request rejected' });
	// 	}
	// 	// blocked?
	// 	if (isBlocked === true) {
	// 		return res.status(403).json({ message: 'Connection blocked' });
	// 	}
	// }

	// let fileKey;
	// let fileUrl;
	// if (fileSize) {
	// 	const today = new Date().toISOString().split('T')[0];
	// 	fileKey = `uploads/${sub}/${today}/${v4()}`;
	// 	fileUrl = await s3CreatePresignedPostCommand(BUCKETNAME, fileKey, fileSize, fileMime);
	// }

	// Verify recording - must belong to the current user
	let recording;
	if (recordingId) {
		recording = (await apsQuery(getRecording, { id: recordingId })).data.getRecording;
		if (recording.owner !== sub) {
			return res.status(403).json({ message: 'Unauthorized' });
		}
	}

	// generate unique message id
	const messageId = v4();

	// create message & message events
	const results = await Promise.all([
		apsMutation(createMessage, {
			id: messageId,
			owner: sub,
			userId: sub,
			chatId,
			type,
			body,
			// isSilent,
			recordingId,
		}),
		apsMutation(createMessageEvent, {
			owner: sub,
			userId: sub,
			messageId,
			chatId,
			chatUserId: `${chatId}-${sub}`,
			type,
			body,
			// isSilent,
			isSender: true,
			isReceiver: false,
			recordingId,
		}),
		apsMutation(createMessageEvent, {
			messageId,
			userId: memberId,
			owner: memberId,
			chatId,
			chatUserId: `${chatId}-${memberId}`,
			body,
			type,
			// isSilent,
			isSender: false,
			isReceiver: true,
			recordingId,
		}),
	]);

	const message = results[0];
	const senderMessageEvent = results[1];
	const receiverMessageEvent = results[2];

	// silent message? Delete the message and message events immediately
	if (isSilent === true) {
		// delete the message
		const dataCreateMessage = message.data.createMessage;
		const dataSenderMessage = senderMessageEvent.data.createMessageEvent;
		const dataReceiverMessage = receiverMessageEvent.data.createMessageEvent;

		// delete message and events
		await Promise.all([
			await apsMutation(deleteMessage, { id: dataCreateMessage.id, _version: dataCreateMessage._version }),
			await apsMutation(deleteMessageEvent, { id: dataSenderMessage.id, _version: dataSenderMessage._version }),
			await apsMutation(deleteMessageEvent, { id: dataReceiverMessage.id, _version: dataReceiverMessage._version }),
		]);

		// delete data from db
		await Promise.all([
			await ddbDelete(MESSAGETABLE, { id: dataCreateMessage.id }),
			await ddbDelete(MESSAGEEVENTTABLE, { id: dataSenderMessage.id }),
			await ddbDelete(MESSAGEEVENTTABLE, { id: dataReceiverMessage.id }),
		]);
	}

	// return res.status(200).json({ message: message.data.createMessage, fileKey, fileUrl });
	return res.status(200).json(senderMessageEvent.data.createMessageEvent);
});

// /**
//  * @summary
//  * update connection messages
//  */
// app.put('/api/v1/connections/:id/messages/:messageId', validateFormData(IConnectionMessage), verifyToken, async (req, res, next) => {
// 	const { Username: sub } = req.user;
// 	const { messageId } = req.params;
// 	const { body, isUploaded } = req.body;

// 	// get connection
// 	const connectionUser = await apsQuery(getConnection, { id: req.params.id });
// 	const { chatId } = connectionUser.data.getConnection;

// 	const connections = await apsGetAll(listConnectionByChatId, { chatId }, 'listConnectionByChatId');
// 	for (let i = 0; i < connections.length; i++) {
// 		const { isAccepted, isDeclined, isBlocked } = connections[i];
// 		// declined?
// 		if (isDeclined === true) {
// 			return res.status(403).json({ message: 'Connection request rejected' });
// 		}
// 		// blocked?
// 		if (isBlocked === true) {
// 			return res.status(403).json({ message: 'Connection blocked' });
// 		}
// 	}

// 	// create message
// 	const message = (await apsQuery(getMessage, { id: messageId })).data.getMessage;

// 	// must be message author / room admin / room owner
// 	if (sub !== message.owner) {
// 		return res.status(403).json({ error: 'Unauthorized' });
// 	}

// 	// update the message
// 	await apsMutation(updateMessage, { id: messageId, _version: message._version, body, isUploaded });

// 	// get all message events
// 	const messageEvents = await apsGetAll(listMessageEventByMessageId, { messageId, limit: LIMIT }, 'listMessageEventByMessageId');

// 	// update all existing message events
// 	let promises = [];
// 	for (let i = 0; i < messageEvents.length; i++) {
// 		const { id, _version } = messageEvents[i];
// 		promises.push(apsMutation(updateMessageEvent, { id, _version, body, isUploaded }));
// 		if (promises.length > BATCH_SIZE) {
// 			await Promise.all(promises);
// 			promises = [];
// 		}
// 	}
// 	await Promise.all(promises);

// 	// all done
// 	return res.status(200).json(message);
// });

// /**
//  * @summary
//  * delete connection
//  */
// app.delete('/api/v1/connections/:id', verifyToken, async (req, res, next) => {
// 	const { id } = req.params;
// 	const { Username: sub } = req.user;
// 	const connection = (await apsQuery(getConnection, { id })).data.getConnection;
// 	if (connection.userId !== sub) {
// 		res.status(403).json({ message: 'Unauthorized' });
// 	}
// 	const connectionDeleted = await apsMutation(deleteConnection, { id, _version: connection._version });
// 	await ddbDelete(CONNECTIONTABLE, { id });
// 	return res.status(200).json(connectionDeleted.data.deleteConnection);
// });

// /**
//  * @summary
//  * delete all connection messages for the current user
//  */
// app.post('/api/v1/connections/:id/clear', verifyToken, async (req, res, next) => {
// 	const { Username: sub } = req.user;
// 	const connection = (await apsQuery(getConnection, { id: req.params.id })).data.getConnection;
// 	if (connection.userId !== sub) {
// 		res.status(403).json({ message: 'Unauthorized' });
// 	}
// 	// send sns notification to delete all connection message events
// 	await snsPublish(
// 		SNS_CLEANUP_TOPIC_ARN,
// 		JSON.stringify({
// 			tableName: MESSAGEEVENTTABLE,
// 			indexName: 'listMessageEventByChatId',
// 			keyConditionExpression: '#chatId = :chatId',
// 			expressionAttributeNames: { '#chatId': 'chatId' },
// 			expressionAttributeValues: { ':chatId': connection.chatId },
// 			checks: {
// 				userId: sub,
// 			},
// 		})
// 	);
// 	return res.status(200).json({});
// });

// /**
//  * @summary
//  * delete specific connection message
//  */
// app.delete('/api/v1/connections/:id/messages/:messageId', verifyToken, validateFormData(IConnection), async (req, res, next) => {
// 	const { Username: sub } = req.user;
// 	const now = new Date().toISOString();

// 	// find existing message event if any
// 	const eventId = `${req.params.messageId}-${sub}`;

// 	// create or update message event
// 	let messageEvent;
// 	try {
// 		messageEvent = (await apsQuery(getMessageEvent, { id: eventId })).data.getMessageEvent;
// 		messageEvent = (await apsMutation(updateMessageEvent, { id: eventId, _version: messageEvent._version, isDeleted: true, deletedAt: now })).data
// 			.createMessageEvent;
// 	} catch (err) {
// 		messageEvent = (
// 			await apsMutation(createMessageEvent, { id: eventId, messageId: req.params.messageId, userId: sub, owner: sub, isDeleted: true, deletedAt: now })
// 		).data.createMessageEvent;
// 	}

// 	// all done
// 	return res.status(200).json(messageEvent);
// });

// /**
//  * @summary
//  * Delete a message for all connections
//  */
// app.delete('/api/v1/connections/:id/messages/:messageId/clear', verifyToken, async (req, res, next) => {
// 	const { Username: sub } = req.user;
// 	const { messageId } = req.params;

// 	// make sure current the current user is message owner
// 	let message;
// 	try {
// 		message = (await apsQuery(getMessage, { id: messageId })).data.getMessage;
// 		if (message.owner !== sub) {
// 			return res.status(403).json({ error: 'Unauthorized' });
// 		}
// 	} catch (err) {
// 		console.log('Error trying to fetch message', err);
// 		return res.status(404).json({ error: 'Not found' });
// 	}

// 	// get all message events
// 	const messageEvents = await apsGetAll(listMessageEventByMessageId, { messageId, limit: LIMIT }, 'listMessageEventByMessageId');

// 	// update all existing message events
// 	let promises = [];
// 	for (let i = 0; i < messageEvents.length; i++) {
// 		const { id, _version } = messageEvents[i];
// 		promises.push(apsMutation(deleteMessageEvent, { id, _version }));
// 		if (promises.length > BATCH_SIZE) {
// 			await Promise.all(promises);
// 			promises = [];
// 		}
// 	}
// 	await Promise.all(promises);

// 	// send sns notification to delete all message events
// 	await snsPublish(
// 		SNS_CLEANUP_TOPIC_ARN,
// 		JSON.stringify({
// 			tableName: MESSAGEEVENTTABLE,
// 			indexName: 'listMessageEventByMessageId',
// 			keyConditionExpression: '#messageId = :messageId',
// 			expressionAttributeNames: { '#messageId': 'messageId' },
// 			expressionAttributeValues: { ':messageId': messageId },
// 		})
// 	);

// 	// delete message from ddb
// 	await ddbDelete(MESSAGETABLE, { id: messageId });

// 	// all done
// 	return res.status(200).json({});
// });
