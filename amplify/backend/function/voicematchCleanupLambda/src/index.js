/* Amplify Params - DO NOT EDIT
	API_VOICEMATCHGRAPHAPI_CONNECTIONTABLE_ARN
	API_VOICEMATCHGRAPHAPI_CONNECTIONTABLE_NAME
	API_VOICEMATCHGRAPHAPI_GRAPHQLAPIIDOUTPUT
	API_VOICEMATCHGRAPHAPI_MESSAGEEVENTTABLE_ARN
	API_VOICEMATCHGRAPHAPI_MESSAGEEVENTTABLE_NAME
	API_VOICEMATCHGRAPHAPI_MESSAGETABLE_ARN
	API_VOICEMATCHGRAPHAPI_MESSAGETABLE_NAME
	API_VOICEMATCHGRAPHAPI_ONLINEPRESENCETABLE_ARN
	API_VOICEMATCHGRAPHAPI_ONLINEPRESENCETABLE_NAME
	API_VOICEMATCHGRAPHAPI_RECORDINGTABLE_ARN
	API_VOICEMATCHGRAPHAPI_RECORDINGTABLE_NAME
	API_VOICEMATCHGRAPHAPI_UPLOADTABLE_ARN
	API_VOICEMATCHGRAPHAPI_UPLOADTABLE_NAME
	API_VOICEMATCHGRAPHAPI_USERTABLE_ARN
	API_VOICEMATCHGRAPHAPI_USERTABLE_NAME
	AUTH_VOICEMATCHC92D7B64_USERPOOLID
	ENV
	REGION
	STORAGE_VOICEMATCHSTORAGE_BUCKETNAME
Amplify Params - DO NOT EDIT */

const { ddbDelete, ddbGetTable } = require('./utils/ddb-utils');
const { safelyParseJSON } = require('./utils/helper-utils');

/**
 * @type {import('@types/aws-lambda').APIGatewayProxyHandler}
 */
exports.handler = async (event) => {
	console.log(`EVENT: ${JSON.stringify(event)}`);

	const newEvent = event.Records[0];
	const { EventSource, Sns } = newEvent;

	if (!Sns?.MessageId) {
		console.log('Invalid SNS message - exit');
		return { ok: false };
	}

	// log debug information
	console.log('Received SNS event', Sns);
	const message = safelyParseJSON(Sns.Message);
	console.log('SNS Message', message);

	// extract sns message
	const { tableName, indexName, keyConditionExpression, expressionAttributeNames, expressionAttributeValues, nextToken, checks } = message;

	// init ddb
	const ddb = await ddbGetTable();

	// if there's an error then catch it
	let error;

	// start processing
	while (true) {
		const params = {
			TableName: tableName,
			IndexName: indexName,
			Limit: 50,
			ScanIndexForward: false,
		};

		// keyConditionExpression?
		if (keyConditionExpression) {
			params.KeyConditionExpression = keyConditionExpression;
		}

		// expressionAttributeNames?
		if (expressionAttributeNames) {
			params.ExpressionAttributeNames = expressionAttributeNames;
		}

		// expressionAttributeValues?
		if (expressionAttributeValues) {
			params.ExpressionAttributeValues = expressionAttributeValues;
		}

		// nextToken?
		if (nextToken) {
			params.ExclusiveStartKey = nextToken;
		}

		// log params
		console.log('Params', JSON.stringify(params, null, 2));

		// query
		const res = await ddb.query(params).promise();

		// extract items
		const items = res.Items;
		console.log('Found items', items.length);

		// build promises to delete items
		// note that conditions to skip deleting an item may be passed via checks object in the sns message
		// e.g. checks: { userId: 'abc', messageId: 'xyz' }
		let promises = [];
		for (let i = 0; i < items.length; i++) {
			let shouldSkip = false;
			if (checks && typeof checks === 'object') {
				shouldSkip = true;
				Object.keys(checks).map((_key) => {
					if (items[i][_key] === checks[_key]) {
						shouldSkip = false;
						return;
					}
				});
			}
			if (shouldSkip) {
				console.log('Skipping message', items[i].id);
				continue;
			}
			promises.push(ddbDelete(tableName, { id: items[i].id }));
		}

		// delete items
		try {
			await Promise.all(promises);
		} catch (err) {
			console.log('Error while deleting items', err);
			error = err;
		}

		// nextToken
		if (!res.LastEvaluatedKey) {
			console.log(`ddbQuery - LastEvaluatedKey not found - break`);
			break;
		}

		// setup nextToken
		nextToken = res.LastEvaluatedKey;
	}

	// throw the error and let it restart the process
	if (error) {
		console.log('Error while deleting items', error);
		throw error;
	}

	// all done
	console.log('All done');
	return { ok: true };
};
