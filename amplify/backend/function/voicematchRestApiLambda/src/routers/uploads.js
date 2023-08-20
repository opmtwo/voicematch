const app = require('../app');
const { v4 } = require('uuid');
const { verifyToken } = require('../middlewares/auth');
const { apsGetAll, apsMutation, apsQuery } = require('../utils/aps-utils');
const { ddbUpdate, ddbDelete } = require('../utils/ddb-utils');
const { getUpload, listUploadsByUserId } = require('../gql/queries');
const { deleteUpload, createUpload } = require('../gql/mutations');
const { s3DeleteObject, s3UpdateACL, s3CloneObject } = require('../utils/s3-utils');
const { validateFormData, IUpload } = require('../schemas');

const {
	REGION,
	AUTH_VOICEMATCHC92D7B64_USERPOOLID: USERPOOLID,
	API_VOICEMATCHGRAPHAPI_UPLOADTABLE_NAME: UPLOADTABLE_NAME,
	STORAGE_VOICEMATCHSTORAGE_BUCKETNAME: BUCKETNAME,
} = process.env;

app.get('/api/v1/uploads', verifyToken, async (req, res, next) => {
	const { Username: sub } = req.user;
	const uploads = await apsGetAll(listUploadsByUserId, { userId: sub, sortDirection: 'DESC' }, 'listUploadsByUserId');
	return res.status(200).json(uploads.filter((_filter) => _filter._deleted !== true));
});

app.get('/api/v1/uploads/:id', verifyToken, async (req, res, next) => {
	const upload = await apsQuery(getUpload, { id: req.params.id });
	return res.status(200).json(upload.data.getUpload);
});

app.post('/api/v1/uploads', verifyToken, validateFormData(IUpload), async (req, res, next) => {
	const { Username: sub } = req.user;

	// s3 key of the upload file and upload duration in ms
	const { key, duration, name, mime, size } = req.body;

	// today's date
	const today = new Date().toISOString().split('T')[0];

	// we will store the file in private directory
	const secureKey = `uploads/${sub}/${today}/${v4()}`;

	// copy file from public directory to private directory
	await s3CloneObject(BUCKETNAME, key, BUCKETNAME, secureKey);

	// make upload readable
	await s3UpdateACL(BUCKETNAME, secureKey, 'public-read');

	// delete the original file
	await s3DeleteObject(BUCKETNAME, key);

	// store the upload data
	const upload = await apsMutation(createUpload, {
		owner: sub,
		userId: sub,
		modelType: 'User',
		modelId: sub,
		duration, // this is the duration of the upload in ms
		key: secureKey,
		name,
		mime,
		size,
		url: `https://s3.${REGION}.amazonaws.com/${BUCKETNAME}/${secureKey}`,
	});

	// all done
	return res.status(200).json(upload.data.createUpload);
});

// app.delete('/api/v1/uploads/:id', verifyToken, async (req, res, next) => {
// 	const { id } = req.params;
// 	const { Username: sub } = req.user;
// 	const upload = (await apsQuery(getUpload, { id })).data.getUpload;
// 	if (upload.owner !== sub) {
// 		res.status(403).json({ message: 'Unauthorized' });
// 	}
// 	const uploadDeleted = await apsMutation(deleteUpload, { id, _version: upload._version });
// 	await ddbDelete(UPLOADTABLE_NAME, { id });
// 	return res.status(200).json(uploadDeleted.data.deleteUpload);
// });
