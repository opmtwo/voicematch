const removeKeysMiddleware = (keysToRemove) => {
	return function (req, res, next) {
		const originalJson = res.json;

		res.json = function (body) {
			const contentType = res.getHeader('Content-Type');
			if (!contentType || contentType.indexOf('application/json') !== -1) {
				const removeKeysFromObject = (obj) => {
					const newObj = {};
					for (const key in obj) {
						if (keysToRemove.includes(key)) {
							continue;
						}

						if (typeof obj[key] === 'object' && obj[key] !== null) {
							newObj[key] = removeKeysFromObject(obj[key]);
						} else {
							newObj[key] = obj[key];
						}
					}
					return newObj;
				};

				if (Array.isArray(body)) {
					body = body.map((obj) => {
						return removeKeysFromObject(obj);
					});
				} else if (typeof body === 'object') {
					body = removeKeysFromObject(body);
				}
			}

			originalJson.call(this, body);
		};

		next();
	};
};

module.exports = {
	removeKeysMiddleware,
};
