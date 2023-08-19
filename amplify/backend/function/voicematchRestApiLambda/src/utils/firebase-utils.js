'use strict';

// firebase admin sdk
var admin = require('firebase-admin');

// firebase account setup
const serviceAccount = require('../voicevibe-fcm-service-account.json');
const { ddbDelete } = require('./ddb-utils');

// env vars
const { API_VOICEMATCHGRAPHAPI_TOKENTABLE_NAME: TOKENTABLE_NAME } = process.env;

// initiazlize firebase admin app
admin.initializeApp({
	credential: admin.credential.cert(serviceAccount),
});

const firebaseSendToDevice = (tokens, title, body) =>
	new Promise((resolve, reject) => {
		console.log('firebaseSendToDevice - input - ', { tokens, title, body });
		admin
			.messaging()
			.sendToDevice(
				tokens, // [token1, token2...],
				{
					data: {
						// foo: 'bar',
					},
					notification: {
						title, // 'A great title',
						body, // 'Great content',
						sound: 'default',
					},
				},
				{
					// Required for background/terminated app state messages on iOS
					contentAvailable: true,
					// Required for background/terminated app state messages on Android
					priority: 'high',
				}
			)
			.then((res) => {
				console.log('firebaseSendToDevice - response - ', JSON.stringify(res, null, 2));
				if (res.failureCount) {
					console.log('firebaseSendToDevice - error - ', res.results[0].error);
					return reject(res);
				}
				console.log('firebaseSendToDevice - success - ', JSON.stringify(res, null, 2));
				return resolve(res);
			})
			.catch((err) => {
				console.log('firebaseSendToDevice - error - ', err);
				reject(err);
			});
	});

const firebaseNotify = async (tokens, title, body, verbose = true) => {
	if (verbose) {
		console.log('firebaseNotify - input length', { noOfToken: tokens.length, title, body });
	}
	for (let i = 0; i < tokens.length; i++) {
		const { id, value: tokenId } = tokens[i];
		if (verbose) {
			console.log('firebaseNotify - processing', { id });
		}
		try {
			await firebaseSendToDevice(tokenId, title, body, verbose);
			if (verbose) {
				console.log('firebaseNotify - success - send to token', { id });
			}
		} catch (err) {
			const code = err?.code || err?.result?.code || err?.results?.[0]?.['error']?.['code'];
			if (verbose) {
				console.log('firebaseNotify - error while sending notification to', { id, code, tokenId });
			}
			if (code === 'messaging/invalid-registration-token') {
				if (verbose) {
					console.log('firebaseNotify - deleting expired or invalid token', tokenId);
				}
				try {
					await ddbDelete(TOKENTABLE_NAME, { id });
					if (verbose) {
						console.log('firebaseNotify - deleted expired or invalid token', tokenId);
					}
				} catch (err) {
					if (verbose) {
						console.log('firebaseNotify - could not delete expired or invalid token', tokenId);
					}
				}
			}
		}
	}
};

module.exports = {
	firebaseSendToDevice,
	firebaseNotify,
};
