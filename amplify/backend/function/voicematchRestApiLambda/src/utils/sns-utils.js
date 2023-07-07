const AWS = require('aws-sdk');
const sns = new AWS.SNS();

const snsPublish = async (topicArn, message, verbose = true) => {
	if (verbose) {
		console.log('snsPublish - input', { topicArn, message });
	}
	const params = {
		Message: message /* required */,
		TopicArn: topicArn,
	};
	if (verbose) {
		console.log('snsPublish - params', params);
	}
	try {
		const response = await sns.publish(params).promise();
		if (verbose) {
			console.log('snsPublish - success - ', response);
		}
		return response;
	} catch (err) {
		if (verbose) {
			console.log('snsPublish - error - ', err);
		}
		throw err;
	}
};

module.exports = {
	snsPublish,
};
