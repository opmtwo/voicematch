const { config: awsConfig } = require('aws-sdk');
const awsAppSyncClient = require('aws-appsync').default;
const gql = require('graphql-tag');

const { API_SUPERDAPP_GRAPHQLAPIENDPOINTOUTPUT: GRAPHQLAPIENDPOINTOUTPUT, REGION } = process.env;

const apsClient = new awsAppSyncClient({
	url: GRAPHQLAPIENDPOINTOUTPUT,
	region: REGION,
	auth: {
		type: 'AWS_IAM',
		credentials: awsConfig.credentials,
	},
	disableOffline: true,
});

const apsQuery = async (query, variables, verbose = true) => {
	if (verbose) {
		console.log('apsQuery - variables', variables);
	}
	try {
		const res = await apsClient.query({ query: gql(query), variables, fetchPolicy: 'network-only' });
		if (verbose) {
			console.log('apsQuery - result - ', res);
		}
		return res;
	} catch (err) {
		if (verbose) {
			console.log('apsQuery - error - ', err);
		}
		throw err;
	}
};

const apsGetAll = async (query, variables, key, token = undefined, verbose = true) => {
	if (verbose) {
		console.log('apsGetAll - input', JSON.stringify({ variables, key, token }));
	}
	try {
		let allItems = [];
		let nextToken = token;
		do {
			const res = await apsQuery(query, { ...variables, nextToken }, verbose);
			allItems = allItems.concat(res.data[key].items);
			nextToken = res.data[key].nextToken;
			if (verbose) {
				console.log('apsGetAll - nextToken', nextToken);
			}
		} while (nextToken);
		if (verbose) {
			console.log('apsGetAll - success - found items', allItems.length);
		}
		return allItems;
	} catch (err) {
		if (verbose) {
			console.log('apsGetAll - error - ', err);
		}
		throw err;
	}
};

const apsMutation = async (mutation, input, verbose = true) => {
	if (verbose) {
		console.log('apsMutation - input', input);
	}
	try {
		const res = await apsClient.mutate({ mutation: gql(mutation), variables: { input } });
		if (verbose) {
			console.log('apsMutation - result - ', res);
		}
		return res;
	} catch (err) {
		if (verbose) {
			console.log('apsMutation - error - ', err);
		}
		throw err;
	}
};

module.exports = {
	apsClient,
	apsQuery,
	apsGetAll,
	apsMutation,
};
