const parseJSON = (json) => {
	let parsed;
	try {
		parsed = JSON.parse(json);
	} catch (err) {
		console.log('parseJSON - error', err);
	}
	console.log('parseJSON - result - ', parsed);
	return parsed;
};

const getEventUser = (event) => {
	const user = event?.requestContext?.authorizer?.claims || {};
	user.groups = user?.['cognito:groups']?.split(',') || [];
	console.log('getEventUser - user', user);
	return user;
};

module.exports = {
	parseJSON,
	getEventUser,
};
