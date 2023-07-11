const crypto = require('crypto');

const safelyParseJSON = (json) => {
	let parsed;
	try {
		parsed = JSON.parse(json);
	} catch (err) {
		console.log('safelyParseJSON - error', err);
	}
	console.log('safelyParseJSON - result - ', parsed);
	return parsed;
};

const getEventUser = (event) => {
	const user = event?.requestContext?.authorizer?.claims || {};
	user.groups = user?.['cognito:groups']?.split(',') || [];
	console.log('getEventUser - user', user);
	return user;
};

const getHostname = (url) => {
	try {
		const urlData = new URL(`http://${url}`);
		console.log('getHostname', { url, urlData });
		const { hostname } = urlData;
		if (hostname) {
			return hostname;
		}
	} catch (err) {
		console.log('getHostname - error -', err);
		return url;
	}
	return url;
};

const getRootDomain = (hostname) => {
	const parts = hostname.split('.');
	if (parts.length < 3) {
		console.log('getRootDomain - result', hostname);
		return hostname;
	}
	const p1 = parts.pop();
	const p2 = parts.pop();
	const result = `${p2}.${p1}`;
	console.log('getRootDomain - result', result);
	return result;
};

const formatTimestamp = (timestamp, format, isIso) => {
	const date = isIso ? new Date(timestamp) : new Date(timestamp * 1000);
	const options = { hour12: true };
	return new Intl.DateTimeFormat('en-US', options).format(date);
};

const sha256 = (value, verbose = true) => {
	if (verbose) {
		console.log('sha256 - input', value);
	}
	const hash = crypto.createHash('sha256');
	hash.update(value);
	const result = hash.digest('hex');
	if (verbose) {
		console.log('sha256 - result', result);
	}
	return result;
};

module.exports = {
	getHostname,
	getRootDomain,
	safelyParseJSON,
	getEventUser,
	formatTimestamp,
	sha256,
};
