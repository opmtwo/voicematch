const app = require('../app');
const { verifyToken } = require('../middlewares/auth');
const { apsQuery, apsMutation } = require('../utils/aps-utils');
const { getOnlinePresence } = require('../gql/queries');
const { updateOnlinePresence, createOnlinePresence } = require('../gql/mutations');

app.post('/api/v1/online', verifyToken, async (req, res, next) => {
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

app.delete('/api/v1/online', verifyToken, async (req, res, next) => {
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
