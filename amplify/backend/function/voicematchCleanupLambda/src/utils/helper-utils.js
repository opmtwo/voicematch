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

module.exports = {
	safelyParseJSON,
};
