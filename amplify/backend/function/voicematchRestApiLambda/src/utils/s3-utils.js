const aws = require('aws-sdk');
const S3_PREFIX = 's3://';

const s3GetPathBucket = async (s3Path, verbose = true) => {
	if (verbose) {
		console.log(`s3GetPathBucket - s3Path=${s3Path}`);
	}
	try {
		s3Path = String(s3Path);
		if (!s3Path.startsWith(S3_PREFIX)) {
			throw new Error('s3GetPathBucket - s3Path does not start with s3://');
		}
		const s3PathSplit = s3Path.split('/');
		const res = s3PathSplit[2];
		if (verbose) {
			console.log('s3GetPathBucket - res', res);
		}
		return res;
	} catch (err) {
		if (verbose) {
			console.log('s3GetPathBucket - err', err);
		}
		throw err;
	}
};

const s3GetPathPrefix = async (s3Path, verbose = true) => {
	if (verbose) {
		console.log(`s3GetPathPrefix - s3Path=${s3Path}`);
	}
	try {
		const s3PathSplit = String(s3Path).split('/');
		const res = s3PathSplit.slice(3, -1).join('/') + '/';
		if (verbose) {
			console.log('s3GetPathPrefix - res', res);
		}
		return res;
	} catch (err) {
		if (verbose) {
			console.log('s3GetPathPrefix - err', err);
		}
		throw err;
	}
};

const s3GetPathKey = async (s3Path, verbose = true) => {
	if (verbose) {
		console.log(`s3GetPathKey - s3Path=${s3Path}`);
	}
	try {
		const s3PathSplit = String(s3Path).split('/');
		const res = s3PathSplit.slice(3).join('/');
		if (verbose) {
			console.log('s3GetPathKey - res', res);
		}
		return res;
	} catch (err) {
		if (verbose) {
			console.log('s3GetPathKey - err', err);
		}
		throw err;
	}
};

const s3GetPathCopySource = async (s3Path, verbose = true) => {
	if (verbose) {
		console.log(`s3GetPathCopySource - s3Path=${s3Path}`);
	}
	try {
		const res = String(s3Path).replace(S3_PREFIX, '/');
		if (verbose) {
			console.log('s3GetPathCopySource - res', res);
		}
		return res;
	} catch (err) {
		if (verbose) {
			console.log('s3GetPathCopySource - err', err);
		}
		throw err;
	}
};

const s3IsPath = async (filePath, verbose = true) => {
	if (verbose) {
		console.log(`s3IsPath - filePath=${filePath}`);
	}
	try {
		const res = String(filePath).startsWith(S3_PREFIX);
		if (verbose) {
			console.log('s3IsPath - res', res);
		}
		return res;
	} catch (err) {
		if (verbose) {
			console.log('s3IsPath - err', err);
		}
		return false;
	}
};

const s3Ls = async (s3Path, suffix = null, verbose = true) => {
	if (verbose) {
		console.log(`s3Ls - s3Path=${s3Path}, suffix=${suffix}`);
	}
	try {
		assert(isS3Path(s3Path));
		const s3Client = new aws.S3();
		const response = await s3Client
			.listObjectsV2({
				Bucket: getS3PathBucket(s3Path),
				Prefix: getS3PathPrefix(s3Path),
			})
			.promise();
		const files = (response.Contents || []).filter((x) => suffix === null || x.Key.endsWith(suffix)).map((x) => x.Key);
		if (verbose) {
			console.log(`s3Ls - len(files)=${files.length}`);
			console.log(`s3Ls - files=${files}`);
		}
		return files;
	} catch (err) {
		if (verbose) {
			console.log('s3Ls - err', err);
		}
		throw err;
	}
};

const s3GetMetadata = async (bucket, key, verbose = true) => {
	if (verbose) {
		console.log(`s3GetMetadata - bucket=${bucket}, key=${key}`);
	}
	try {
		const s3Client = new aws.S3();
		const res = await s3Client.headObject({ Bucket: bucket, Key: key }).promise();
		if (verbose) {
			console.log('s3Metadata - res', res);
			console.log(`s3Metadata - res["Metadata"]=${res.Metadata}`);
		}
		return res;
	} catch (err) {
		if (verbose) {
			console.log('s3GetMetadata - err', err);
		}
		throw err;
	}
};

const s3GetObject = async (bucket, key, verbose = true) => {
	if (verbose) {
		console.log(`s3GetObject - bucket=${bucket}, key=${key}`);
	}
	try {
		const s3Client = new aws.S3();
		const res = await s3Client.getObject({ Bucket: bucket, Key: key }).promise();
		if (verbose) {
			console.log('s3GetObject - res', res);
		}
		return res;
	} catch (err) {
		if (verbose) {
			console.log('s3GetObject - err', err);
		}
		throw err;
	}
};

const s3CloneObject = async (sourceBucket, sourceKey, destinationBucket, destinationKey, verbose = true) => {
	if (verbose) {
		console.log(
			`s3CloneObject - sourceBucket=${sourceBucket}, sourceKey=${sourceKey}, destinationBucket=${destinationBucket}, destinationKey=${destinationKey}`
		);
	}
	try {
		const s3Resource = new aws.S3();
		const res = await s3Resource.copyObject({ CopySource: `/${sourceBucket}/${sourceKey}`, Bucket: destinationBucket, Key: destinationKey }).promise();
		if (verbose) {
			console.log('s3CloneObject - res', res);
		}
		return res;
	} catch (err) {
		if (verbose) {
			console.log('s3CloneObject - err', err);
		}
		throw err;
	}
};

const s3ReadCsvAsJson = async (bucket, key, verbose = true) => {
	if (verbose) {
		console.log(`s3ReadCsvAsJson - bucket=${bucket}, key=${key}`);
	}
	try {
		const s3Client = new aws.S3();
		const obj = await s3Client.getObject({ Bucket: bucket, Key: key }).promise();
		if (verbose) {
			console.log(`s3ReadCsvAsJson - obj=${obj}`);
			console.log(`s3ReadCsvAsJson - obj.ResponseMetadata.HTTPHeaders.content-type=${obj.ResponseMetadata.HTTPHeaders['content-type']}`);
		}
		const res = csv.parse(obj.Body.toString('utf-8'), { columns: true });
		if (verbose) {
			console.log('s3ReadCsvAsJson - res', res);
		}
		return res;
	} catch (err) {
		if (verbose) {
			console.log('s3ReadCsvAsJson - err', err);
		}
		throw err;
	}
};

const s3PutObject = async (bucket, key, data, contentEncoding = null, contentType = null, acl = null, verbose = true) => {
	if (verbose) {
		console.log(`s3PutObject - bucket: ${bucket}, key: ${key}`);
	}
	try {
		const s3 = new aws.S3();
		const params = {
			Bucket: bucket,
			Key: key,
			Body: data,
		};
		if (contentEncoding) {
			params.ContentEncoding = contentEncoding;
		}
		if (contentType) {
			params.ContentType = contentType;
		}
		if (acl) {
			params.ACL = acl;
		}
		if (verbose) {
			console.log('s3PutObject - params', params);
		}
		const res = await s3.putObject(params).promise();
		if (verbose) {
			console.log('s3PutObject - res', res);
		}
		return res;
	} catch (err) {
		if (verbose) {
			console.log('s3PutObject - err', err);
		}
		throw err;
	}
};

const s3UpdateACL = async (bucket, key, acl, verbose = true) => {
	if (verbose) {
		console.log(`s3UpdateACL - bucket: ${bucket}, key: ${key}`);
	}
	try {
		const s3 = new aws.S3();
		const params = {
			Bucket: bucket,
			Key: key,
			ACL: acl,
		};
		if (verbose) {
			console.log('s3UpdateACL - params', params);
		}
		const res = await s3.putObjectAcl(params).promise();
		if (verbose) {
			console.log('s3UpdateACL - res', res);
		}
		return res;
	} catch (err) {
		if (verbose) {
			console.log('s3UpdateACL - err', err);
		}
		throw err;
	}
};

const s3GeneratePresignedUrl = async (
	clientMethod,
	bucket,
	key,
	contentType = null,
	contentEncoding = null,
	acl = null,
	expiresInSeconds = 3600,
	verbose = true
) => {
	if (verbose) {
		console.log(
			`s3GeneratePresignedUrl - bucket: ${bucket}, key: ${key}, contentType: ${contentType}, contentEncoding: ${contentEncoding}, acl: ${acl}, expiresInSeconds: ${expiresInSeconds}`
		);
	}
	try {
		const params = {
			Bucket: bucket,
			Key: key,
		};
		if (contentType) {
			params.ContentType = contentType;
		}
		if (contentEncoding) {
			params.ContentEncoding = contentEncoding;
		}
		if (acl) {
			params.ACL = acl;
		}
		if (verbose) {
			console.log(`s3GeneratePresignedUrl - params: ${JSON.stringify(params)}`);
		}
		const s3 = new aws.S3();
		const res = await new Promise((resolve, reject) => {
			s3.getSignedUrl(clientMethod, params, (err, url) => {
				if (err) {
					if (verbose) {
						console.log('s3GeneratePresignedUrl - err', err);
					}
					return reject(err);
				}
				return resolve(url);
			});
		});
		if (verbose) {
			console.log('s3GeneratePresignedUrl - res', res);
		}
		return res;
	} catch (err) {
		if (verbose) {
			console.log('s3GeneratePresignedUrl - err', err);
		}
		throw err;
	}
};

const s3CreatePresignedPostCommand = async (
	bucket,
	key,
	contentLength = null,
	contentType = null,
	contentEncoding = null,
	acl = null,
	expiresInSeconds = 3600,
	verbose = true
) => {
	if (verbose) {
		console.log(
			`s3CreatePresignedPostCommand - bucket: ${bucket}, key: ${key}, contentLength: ${contentLength}, contentType: ${contentType}, contentEncoding: ${contentEncoding}, acl: ${acl}, expiresInSeconds: ${expiresInSeconds}`
		);
	}
	try {
		const s3 = new aws.S3({ signatureVersion: 'v4' });
		const res = await new Promise((resolve, reject) => {
			const params = {
				Bucket: bucket,
				Fields: {
					key,
				},
				Conditions: [
					// { 'content-length-range': [contentLength, contentLength] }, // Set the content length range
					['content-length-range', 0, contentLength + 2000],
					// { 'Content-Type': contentType }, // Set the content type condition
				],
				Expires: expiresInSeconds,
			};
			s3.createPresignedPost(params, (err, data) => {
				if (err) {
					if (verbose) {
						console.log('s3GeneratePresignedUrl - err', err);
					}
					return reject(err);
				}
				return resolve(data);
			});
		});
		if (verbose) {
			console.log('s3CreatePresignedPostCommand - res', res);
		}
		return res;
	} catch (err) {
		if (verbose) {
			console.log('s3CreatePresignedPostCommand - err', err);
		}
		throw err;
	}
};

const s3DeleteObject = async (bucket, key, verbose = true) => {
	if (verbose) {
		console.log(`s3DeleteObject - bucket: ${bucket}, key: ${key}`);
	}
	try {
		const s3 = new aws.S3();
		const res = await s3.deleteObject({ Bucket: bucket, Key: key }).promise();
		return res;
	} catch (err) {
		if (verbose) {
			console.log('s3DeleteObject - err', err);
		}
		throw err;
	}
};

module.exports = {
	s3GetPathBucket,
	s3GetPathPrefix,
	s3GetPathKey,
	s3GetPathCopySource,
	s3IsPath,
	s3Ls,
	s3GetMetadata,
	s3GetObject,
	s3CloneObject,
	s3ReadCsvAsJson,
	s3PutObject,
	s3UpdateACL,
	s3GeneratePresignedUrl,
	s3CreatePresignedPostCommand,
	s3DeleteObject,
};
