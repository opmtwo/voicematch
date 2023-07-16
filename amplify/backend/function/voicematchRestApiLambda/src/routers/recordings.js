const app = require('../app');
const { v4 } = require('uuid');
const { verifyToken } = require('../middlewares/auth');
const { apsGetAll, apsMutation, apsQuery } = require('../utils/aps-utils');
const { ddbUpdate, ddbDelete } = require('../utils/ddb-utils');
const { getRecording, listRecordingsByUserId } = require('../gql/queries');
const { deleteRecording, createRecording } = require('../gql/mutations');
const { s3DeleteObject, s3UpdateACL, s3CloneObject } = require('../utils/s3-utils');
const { validateFormData, IRecording } = require('../schemas');

const {
	REGION,
	AUTH_VOICEMATCHC92D7B64_USERPOOLID: USERPOOLID,
	API_VOICEMATCHGRAPHAPI_RECORDINGTABLE_NAME: RECORDINGTABLE,
	SNS_CLEANUP_TOPIC_ARN,
	STORAGE_VOICEMATCHSTORAGE_BUCKETNAME: BUCKETNAME,
} = process.env;

app.get('/api/v1/recordings', verifyToken, async (req, res, next) => {
	const { Username: sub } = req.user;
	const recordings = await apsGetAll(listRecordingsByUserId, { userId: sub, sortDirection: 'DESC' }, 'listRecordingsByUserId');
	return res.status(200).json(recordings.filter((_filter) => _filter._deleted !== true));
});

app.get('/api/v1/recordings/:id', verifyToken, async (req, res, next) => {
	const recording = await apsQuery(getRecording, { id: req.params.id });
	return res.status(200).json(recording.data.getRecording);
});

app.post('/api/v1/recordings', verifyToken, validateFormData(IRecording), async (req, res, next) => {
	const { Username: sub } = req.user;

	// s3 key of the recording file and recording duration in ms
	const { key, duration } = req.body;

	// today's date
	const today = new Date().toISOString().split('T')[0];

	// we will store the file in private directory
	const secureKey = `recordings/${sub}/${today}/${v4()}`;

	// copy file from public directory to private directory
	await s3CloneObject(BUCKETNAME, key, BUCKETNAME, secureKey);

	// make recording readable
	await s3UpdateACL(BUCKETNAME, secureKey, 'public-read');

	// delete the original file
	await s3DeleteObject(BUCKETNAME, key);

	// store the recording data
	const recording = await apsMutation(createRecording, {
		owner: sub,
		userId: sub,
		duration, // this is the duration of the recording in ms
		key: secureKey,
		url: `https://s3.${REGION}.amazonaws.com/${BUCKETNAME}/${secureKey}`,
	});

	// all done
	return res.status(200).json(recording.data.createRecording);
});

// app.delete('/api/v1/recordings/:id', verifyToken, async (req, res, next) => {
// 	const { id } = req.params;
// 	const { Username: sub } = req.user;
// 	const recording = (await apsQuery(getRecording, { id })).data.getRecording;
// 	if (recording.owner !== sub) {
// 		res.status(403).json({ message: 'Unauthorized' });
// 	}
// 	const recordingDeleted = await apsMutation(deleteRecording, { id, _version: recording._version });
// 	await ddbDelete(RECORDINGTABLE, { id });
// 	return res.status(200).json(recordingDeleted.data.deleteRecording);
// });
