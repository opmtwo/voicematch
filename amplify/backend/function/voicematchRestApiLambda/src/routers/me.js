const app = require('../app');
const { v4 } = require('uuid');
const { verifyToken } = require('../middlewares/auth');
const { validateFormData, IAvatar } = require('../schemas');
const { s3GetObject, s3PutObject } = require('../utils/s3-utils');
const { REGION, STORAGE_STORAGE_BUCKETNAME: BUCKETNAME, AUTH_SUPERDAPP5A8B82A5_USERPOOLID: USERPOOLID } = process.env;
const { apsQuery, apsMutation, apsGetAll } = require('../utils/aps-utils');
const { idpAdminUpdateUserAttributes, idpGetUserAttribute } = require('../utils/idp-utils');
const { getUser, getOnlinePresence, listConnectionByUserId, listConnectionByChatId } = require('../gql/queries');
const { updateOnlinePresence, createOnlinePresence, updateConnection } = require('../gql/mutations');
const { createUser, updateUser } = require('../gql/mutations');
const { default: slugify } = require('slugify');
const { BATCH_SIZE } = require('../consts');

app.put('/api/v1/me/avatar', verifyToken, validateFormData(IAvatar), async (req, res, next) => {
	const { Username: sub } = req.user;

	// prepare key and url
	const photoKey = `public/avatars/${sub}/${v4()}`;
	const photoUrl = `https://s3.${REGION}.amazonaws.com/${BUCKETNAME}/${photoKey}`;

	// make image public readable
	const source = await s3GetObject(BUCKETNAME, req.body.key);
	await s3PutObject(BUCKETNAME, photoKey, source['Body'], null, null, 'public-read');

	// update cognito attribute
	await idpAdminUpdateUserAttributes(USERPOOLID, sub, { picture: photoUrl });

	// update avatar and trigger web socket subscription
	try {
		const { id, _version } = (await apsQuery(getUser, { id: sub })).data.getUser;
		await apsMutation(updateUser, { id: sub, _version, picture: photoUrl });
	} catch (err) {
		console.log('Error updating user', sub, err);
	}

	// get all user connections
	const connections = await apsGetAll(listConnectionByUserId, { userId: sub }, 'listConnectionByUserId');

	// find chat ids
	let chatIds = [];
	for (let i = 0; i < connections.length; i++) {
		const { chatId } = connections[i];
		if (!chatId) {
			continue;
		}
		chatIds.push(chatId);
	}
	console.log({ chatIds });

	// get all chats of connected members
	let promises = [];
	let chats = [];
	for (let i = 0; i < chatIds.length; i++) {
		promises.push(apsGetAll(listConnectionByChatId, { chatId: chatIds[i] }, 'listConnectionByChatId'));
		if (promises.length >= BATCH_SIZE) {
			const results = await Promise.all(promises);
			for (let j = 0; j < results.length; j++) {
				chats = chats.concat(results[j]);
			}
			promises = [];
		}
	}
	const results = await Promise.all(promises);
	for (let j = 0; j < results.length; j++) {
		chats = chats.concat(results[j]);
	}
	console.log(JSON.stringify(chats, null, 2));

	// update all member connections and trigger web socket subscription
	promises = [];
	const now = new Date().toISOString();
	for (let i = 0; i < chats.length; i++) {
		const { id, _version, owner } = chats[i];
		// skip self connections
		if (owner === sub || !id || !_version) {
			continue;
		}
		promises.push(apsMutation(updateConnection, { id, _version, updatedAt: now }));
		if (promises.length > BATCH_SIZE) {
			await Promise.all(promises);
			promises = [];
		}
	}
	await Promise.all(promises);

	// all done
	return res.status(200).json({});
});

app.delete('/api/v1/me/avatar', validateFormData(IAvatar), verifyToken, async (req, res, next) => {
	const { Username: sub } = req.user;

	// prepare key and url
	await idpAdminUpdateUserAttributes(USERPOOLID, sub, { picture: '' });

	// update avatar and trigger web socket subscription
	try {
		const { id, _version } = (await apsQuery(getUser, { id: sub })).data.getUser;
		await apsMutation(updateUser, { id, _version, picture: '' });
	} catch (err) {
		console.log('Error updating user', sub);
	}

	// get all user connections
	const connections = await apsGetAll(listConnectionByUserId, { userId: sub }, 'listConnectionByUserId');

	// find chat ids
	let chatIds = [];
	for (let i = 0; i < connections.length; i++) {
		const { chatId } = connections[i];
		if (!chatId) {
			continue;
		}
		chatIds.push(chatId);
	}
	console.log({ chatIds });

	// get all chats of connected members
	let promises = [];
	let chats = [];
	for (let i = 0; i < chatIds.length; i++) {
		promises.push(apsGetAll(listConnectionByChatId, { chatId: chatIds[i] }, 'listConnectionByChatId'));
		if (promises.length >= BATCH_SIZE) {
			const results = await Promise.all(promises);
			for (let j = 0; j < results.length; j++) {
				chats = chats.concat(results[j]);
			}
			promises = [];
		}
	}
	const results = await Promise.all(promises);
	for (let j = 0; j < results.length; j++) {
		chats = chats.concat(results[j]);
	}

	// update all member connections and trigger web socket subscription
	promises = [];
	const now = new Date().toISOString();
	for (let i = 0; i < chats.length; i++) {
		const { id, _version, owner } = chats[i];
		// skip self connections
		if (owner === sub || !id || !_version) {
			continue;
		}
		promises.push(apsMutation(updateConnection, { id, _version, updatedAt: now }));
		if (promises.length > BATCH_SIZE) {
			await Promise.all(promises);
			promises = [];
		}
	}
	await Promise.all(promises);

	// all done
	return res.status(200).json({});
});

app.put('/api/v1/me/onboard', verifyToken, async (req, res, next) => {
	const { Username: sub } = req.user;
	const username = await idpGetUserAttribute(req.user, 'custom:username', '');
	const email = await idpGetUserAttribute(req.user, 'email', '');
	const givenName = await idpGetUserAttribute(req.user, 'given_name', '');
	const familyName = await idpGetUserAttribute(req.user, 'family_name', '');
	const picture = await idpGetUserAttribute(req.user, 'picture', '');
	const name = await idpGetUserAttribute(req.user, 'name', '');
	const searchTerm = slugify(`${username} ${email} ${name}`, { lower: true, trim: true });
	try {
		const user = await apsQuery(getUser, { id: sub });
		const { id, _version } = user.data.getUser;
		const userUpdated = await apsMutation(updateUser, { id, _version, username, email, givenName, familyName, name, picture, searchTerm });
		return res.status(200).json(userUpdated.data.updateUser);
	} catch (err) {
		console.log('Error updating existing user - tyring to create new user', err);
		const user = await apsMutation(createUser, { id: sub, owner: sub, username, email, givenName, familyName, name, picture, searchTerm });
		return res.status(200).json(user.data.createUser);
	}
});

app.post('/api/v1/me/online', verifyToken, async (req, res, next) => {
	const { Username: sub } = req.user;
	const now = new Date().toISOString();
	let onlinePresence = (await apsQuery(getOnlinePresence, { id: sub })).data.getOnlinePresence;
	if (onlinePresence?.id) {
		onlinePresence = (await apsMutation(updateOnlinePresence, { id: sub, _version: onlinePresence._version, status: 'online', lastSeenAt: now })).data
			.updateOnlinePresence;
	} else {
		onlinePresence = (await apsMutation(createOnlinePresence, { id: sub, owner: sub, status: 'online', lastSeenAt: now })).data.createOnlinePresence;
	}
	return res.status(200).json(onlinePresence);
});

app.post('/api/v1/me/offline', verifyToken, async (req, res, next) => {
	const { Username: sub } = req.user;
	const now = new Date().toISOString();
	let onlinePresence = (await apsQuery(getOnlinePresence, { id: sub })).data.getOnlinePresence;
	if (onlinePresence?.id) {
		onlinePresence = (await apsMutation(updateOnlinePresence, { id: sub, _version: onlinePresence._version, status: 'offline', lastSeenAt: now })).data
			.updateOnlinePresence;
	} else {
		onlinePresence = (await apsMutation(createOnlinePresence, { id: sub, owner: sub, status: 'offline', lastSeenAt: now })).data.createOnlinePresence;
	}
	return res.status(200).json(onlinePresence);
});
