const { idpGetUserByToken, idpAdminListGroupsForUser, idpAdminGetUser } = require('../utils/idp-utils');
const { AUTH_VOICEMATCHC92D7B64_USERPOOLID: USERPOOLID } = process.env;

const verifyToken = async (req, res, next) => {
	const token = req.headers.authorization;
	console.log(`verifyToken - token = ${token}`);
	if (!token) {
		console.log(`verifyToken - token not found`);
		return res.status(401).json({ error: 'Unauthorized' });
	}
	try {
		const userInfo = await idpGetUserByToken(token, true);
		const user = await idpAdminGetUser(USERPOOLID, userInfo.Username);
		if (user.Enabled !== true) {
			console.error('verifyToken - err - user not enabled');
			res.status(401).json({ error: 'Unauthorized' });
		}
		req.user = user;
		next();
	} catch (err) {
		console.error('verifyToken - err', err);
		res.status(401).json({ error: 'Unauthorized' });
	}
};

// const verifyRoomTeam = async (req, res, next) => {
// 	try {
// 		// find room participants
// 		const participants = await apsQuery(listParticipantByRoomId, { roomId: req.params.id });
// 		const items = participants.data.listParticipantByRoomId.items;

// 		// find team
// 		const team = items.find((items) => items.userId === req.user.Username);
// 		console.log('verifyRoomTeam - user role', team.role);
// 		console.log('verifyRoomTeam - success', team);
// 		req.team = team;

// 		// team not found
// 		if (!team?.id) {
// 			return res.status(401).json({ error: 'Unauthorized' });
// 		}

// 		// all done
// 		next();
// 	} catch (err) {
// 		console.log('verifyRoomTeam - err', err);
// 		res.status(401).json({ error: 'Unauthorized' });
// 	}
// };

const verifyRole = (allowRoles) => async (req, res, next) => {
	try {
		console.log('verifyRole - allowRoles', allowRoles);
		const groups = await idpAdminListGroupsForUser(USERPOOLID, req.user.Username);
		req.groups = groups;
		for (let i = 0; i < groups.length; i++) {
			if (groups[i].GroupName.toLowerCase() === 'root') {
				console.log('verifyRole - success - user role is', groups[i].GroupName);
				return next();
			}
		}
		// if (allowRoles.includes(req.team.role) !== true) {
		// 	console.log('verifyRole - error - user role is', req.team.role);
		// 	res.status(401).json({ message: 'Unauthorized' });
		// 	throw new Error({ message: 'Unauthorized' });
		// }
		// console.log('verifyRole - success - user role is', req.team.role);
		return next();
	} catch (err) {
		console.log('verifyRole - err', err);
		res.status(401).json({ message: 'Unauthorized' });
		throw new Error(err);
	}
};

module.exports = {
	verifyToken,
	// verifyRoomTeam,
	verifyRole,
};
