const aws = require('aws-sdk');

const ddbDecode = async (value, verbose = false) => {
	try {
		const res = aws.DynamoDB.Converter.unmarshall(value);
		if (verbose) {
			console.log('ddbDecode - res', res);
		}
		return res;
	} catch (err) {
		if (verbose) {
			console.log('ddbDecode - err', err);
		}
		throw err;
	}
};

const ddbEncode = async (value, verbose = false) => {
	try {
		const res = aws.DynamoDB.Converter.marshall(value);
		if (verbose) {
			console.log('ddbEncode - res', res);
		}
		return res;
	} catch (err) {
		if (verbose) {
			console.log('ddbEncode - err', err);
		}
		throw err;
	}
};

const ddbGetTable = async (verbose = true) => {
	try {
		const res = new aws.DynamoDB.DocumentClient({ apiVersion: '2012-08-10' });
		if (verbose) {
			console.log('ddbGetTable - res', res);
		}
		return res;
	} catch (err) {
		if (verbose) {
			console.log('ddbGetTable - err', err);
		}
		throw err;
	}
};

const ddbGet = async (tableName, key, raw = false, verbose = true) => {
	if (verbose) {
		console.log(`ddbGet - tableName=${tableName}, key=${JSON.stringify(key)}, raw=${raw}`);
	}
	try {
		const table = await ddbGetTable(verbose);
		const res = await table.get({ TableName: tableName, Key: key }).promise();
		if (verbose) {
			console.log('ddbGet - res', res);
		}
		if (raw) {
			return res;
		}
		return res.Item;
	} catch (err) {
		if (verbose) {
			console.log('ddbGet - err', err);
		}
		throw err;
	}
};

const ddbQuery = async (
	tableName,
	indexName,
	keyConditionExpression,
	expressionAttributeNames,
	expressionAttributeValues,
	limit = 200,
	maxLimit = null,
	projectionExpression = null,
	scanIndexForward = false,
	exclusiveStartKey = null,
	verbose = true
) => {
	if (verbose) {
		console.log(
			`ddbQuery - tableName: ${tableName}, indexName: ${indexName}, keyConditionExpression: ${keyConditionExpression}, expressionAttributeNames: ${expressionAttributeNames}, expressionAttributeValues: ${expressionAttributeValues}, limit: ${limit}, projectionExpression: ${projectionExpression}, scanIndexForward: ${scanIndexForward}, exclusiveStartKey: ${exclusiveStartKey}`
		);
	}
	try {
		const table = await ddbGetTable();
		let res = [];
		let nextToken = exclusiveStartKey;
		while (true) {
			const params = {
				TableName: tableName,
				IndexName: indexName,
				KeyConditionExpression: keyConditionExpression,
				ExpressionAttributeNames: expressionAttributeNames,
				ExpressionAttributeValues: expressionAttributeValues,
				Limit: limit,
				ScanIndexForward: scanIndexForward,
			};
			if (nextToken) {
				params.ExclusiveStartKey = nextToken;
			}
			if (projectionExpression) {
				params.ProjectionExpression = projectionExpression;
			}
			const queryRes = await table.query(params).promise();
			res = res.concat(queryRes.Items);
			if (!queryRes.LastEvaluatedKey) {
				if (verbose) {
					console.log(`ddbQuery - LastEvaluatedKey not found - break`);
				}
				break;
			}
			if (maxLimit && res.length >= maxLimit) {
				if (verbose) {
					console.log(`ddbQuery - maxLimit: ${maxLimit} reached - break`);
				}
				break;
			}
			nextToken = queryRes.LastEvaluatedKey;
		}
		if (verbose) {
			console.log(`ddbQuery - length/sample`, res.length, [...res].pop());
		}
		return res;
	} catch (err) {
		if (verbose) {
			console.log('ddbQuery - err', err);
		}
		throw err;
	}
};

const ddbScan = async (
	tableName,
	filterExpression = null,
	expressionAttributeNames = null,
	expressionAttributeValues = null,
	limit = 200,
	maxLimit = null,
	projectionExpression = null,
	exclusiveStartKey = null,
	verbose = true
) => {
	if (verbose) {
		console.log(
			'ddbScan - input',
			JSON.stringify({
				tableName,
				filterExpression,
				expressionAttributeNames,
				expressionAttributeValues,
				limit,
				maxLimit,
				projectionExpression,
				exclusiveStartKey,
				verbose,
			})
		);
	}
	try {
		const table = await ddbGetTable();
		let res = [];
		let nextToken = exclusiveStartKey;
		while (true) {
			const params = { TableName: tableName, Limit: limit };
			if (filterExpression) {
				params.FilterExpression = filterExpression;
			}
			if (expressionAttributeNames) {
				params.ExpressionAttributeNames = expressionAttributeNames;
			}
			if (expressionAttributeValues) {
				params.ExpressionAttributeValues = expressionAttributeValues;
			}
			if (nextToken) {
				params.ExclusiveStartKey = nextToken;
			}
			if (projectionExpression) {
				params.ProjectionExpression = projectionExpression;
			}
			const scanRes = await table.scan(params).promise();
			res = res.concat(scanRes.Items);
			if (!scanRes.LastEvaluatedKey) {
				if (verbose) {
					console.log('ddbScan - LastEvaluatedKey not found - break');
				}
				break;
			}
			if (maxLimit && res.length >= maxLimit) {
				if (verbose) {
					console.log(`ddbScan - maxLimit: ${maxLimit} reached - break `);
				}
				break;
			}
			nextToken = scanRes.LastEvaluatedKey;
		}
		if (verbose) {
			console.log('ddbScan - res', res);
		}
		return res;
	} catch (err) {
		if (verbose) {
			console.log('ddbScan - err', err);
		}
		throw err;
	}
};

const ddbPut = async (tableName, item, verbose = true) => {
	if (verbose) {
		console.log(`ddbPut - tableName: ${tableName}, item: ${JSON.stringify(item)}`);
	}
	try {
		const table = await ddbGetTable();
		const res = await table.put({ TableName: tableName, Item: item }).promise();
		if (verbose) {
			console.log('ddbPut - res', res);
		}
		return res;
	} catch (err) {
		if (verbose) {
			console.log('ddbPut - err', err);
		}
		throw err;
	}
};

const ddbUpdate = async (
	tableName,
	key,
	updateExpression,
	expressionAttributeNames,
	expressionAttributeValues,
	returnValues = 'UPDATED_NEW',
	verbose = true
) => {
	if (verbose) {
		console.log(
			`ddbUpdate - tableName: ${tableName}, key: ${JSON.stringify(
				key
			)}, updateExpression: ${updateExpression}, expressionAttributeNames: ${JSON.stringify(
				expressionAttributeNames
			)}, expressionAttributeValues: ${JSON.stringify(expressionAttributeValues)}, returnValues: ${returnValues}`
		);
	}
	try {
		const table = await ddbGetTable();
		const res = await table
			.update({
				TableName: tableName,
				Key: key,
				UpdateExpression: updateExpression,
				ExpressionAttributeNames: expressionAttributeNames,
				ExpressionAttributeValues: expressionAttributeValues,
				ReturnValues: returnValues,
			})
			.promise();
		if (verbose) {
			console.log('ddbUpdate - res', res);
		}
		return res;
	} catch (err) {
		if (verbose) {
			console.log('ddbUpdate - err', err);
		}
		throw err;
	}
};

const ddbDelete = async (tableName, key, verbose = true) => {
	if (verbose) {
		console.log(`ddbDelete - tableName: ${tableName}, key: ${JSON.stringify(key)}`);
	}
	try {
		const table = await ddbGetTable(verbose);
		const res = await table.delete({ TableName: tableName, Key: key }).promise();
		if (verbose) {
			console.log('ddbDelete - res', res);
		}
		return res;
	} catch (err) {
		if (verbose) {
			console.log('ddbDelete - err', err);
		}
		throw err;
	}
};

module.exports = {
	ddbDecode,
	ddbEncode,
	ddbGetTable,
	ddbGet,
	ddbQuery,
	ddbScan,
	ddbPut,
	ddbUpdate,
	ddbDelete,
};
