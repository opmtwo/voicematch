const app = require('app');
const sharp = require('sharp');
const { v4 } = require('uuid');
const { default: slugify } = require('slugify');
const { verifyToken } = require('../middlewares/auth');
const { safelyParseJSON } = require('../utils/helper-utils');
const { idpGetUserAttribute, idpAdminUpdateUserAttributes } = require('../utils/idp-utils');
const { apsQuery, apsMutation, apsGetAll } = require('../utils/aps-utils');
const { s3GetObject, s3PutObject, s3UpdateACL, s3CloneObject, s3DeleteObject } = require('../utils/s3-utils');
const { createUser, updateUser, createRecording, createConnection } = require('../gql/mutations');
const { getUser, listUsers, getConnection } = require('../gql/queries');
const { calculateMatchPercentage } = require('../utils/match-utils');

const { REGION, STORAGE_VOICEMATCHSTORAGE_BUCKETNAME: BUCKETNAME, AUTH_VOICEMATCHC92D7B64_USERPOOLID: USERPOOLID } = process.env;

app.post('/api/v1/onboard', verifyToken, async (req, res, next) => {
	const { Username: sub } = req.user;
	const { avatar, recording, duration } = req.query;
	console.log({ avatar, recording, duration });

	// get profile info
	const email = await idpGetUserAttribute(req.user, 'email', undefined);
	const givenName = await idpGetUserAttribute(req.user, 'given_name', undefined);
	const familyName = await idpGetUserAttribute(req.user, 'family_name', undefined);
	const name = `${givenName} ${familyName}`;

	const gender = await idpGetUserAttribute(req.user, 'gender', undefined);
	const lookingFor = await idpGetUserAttribute(req.user, 'custom:target_gender', undefined);
	const ageRange = await idpGetUserAttribute(req.user, 'custom:age_range', undefined);

	const distance = await idpGetUserAttribute(req.user, 'custom:distance', undefined);
	const locale = await idpGetUserAttribute(req.user, 'locale', undefined);

	const interestCreativity = await idpGetUserAttribute(req.user, 'custom:interest_creativity', undefined);
	const interestSports = await idpGetUserAttribute(req.user, 'custom:interest_sports', undefined);
	const interestVideo = await idpGetUserAttribute(req.user, 'custom:interest_video', undefined);
	const interestMusic = await idpGetUserAttribute(req.user, 'custom:interest_music', undefined);
	const interestTravelling = await idpGetUserAttribute(req.user, 'custom:interest_travelling', undefined);
	const interestPet = await idpGetUserAttribute(req.user, 'custom:interest_pet', undefined);

	// const introId = await idpGetUserAttribute(req.user, 'custom:intro_id', undefined);
	const introKey = await idpGetUserAttribute(req.user, 'custom:intro_recording', undefined);

	// prepare search term
	const searchTerm = slugify(`${sub} ${email} ${name}`, { lower: true, trim: true });

	// prepare thumb and blurred images
	const pictureKey = await idpGetUserAttribute(req.user, 'picture', undefined);

	let pictureNormal = undefined;
	let pictureMasked = undefined;
	if (pictureKey && avatar) {
		try {
			const pictureObj = await s3GetObject(BUCKETNAME, pictureKey);
			const imageNormal = await sharp(pictureObj.Body).resize(512, 512).toBuffer();
			const imageMasked = await sharp(pictureObj.Body).resize(512, 512).blur(10).toBuffer();
			const keyNormal = `avatars/${sub}/${v4()}`;
			const keyMasked = `avatars/${sub}/${v4()}`;
			await Promise.all([
				s3PutObject(BUCKETNAME, keyNormal, imageNormal, null, 'image/png', 'public-read'),
				s3PutObject(BUCKETNAME, keyMasked, imageMasked, null, 'image/png', 'public-read'),
			]);
			pictureNormal = `https://s3.${REGION}.amazonaws.com/${BUCKETNAME}/${keyNormal}`;
			pictureMasked = `https://s3.${REGION}.amazonaws.com/${BUCKETNAME}/${keyMasked}`;
			await idpAdminUpdateUserAttributes(USERPOOLID, sub, {
				'custom:picture_normal': pictureNormal,
				'custom:picture_masked': pictureMasked,
			});
		} catch (err) {
			console.log('Error in updating profile pic', err);
		}
	}

	// setup intro recording
	let introId = undefined;
	let introModel;
	if (introKey && recording) {
		try {
			// get the intro recording file
			// this entire workflow will skip if this file doesn't exist'
			const introObj = await s3GetObject(BUCKETNAME, introKey);

			// make recording readable
			// await s3UpdateACL(BUCKETNAME, introKey, 'public-read');

			// we will store the file in private directory
			const introKeyPrivate = `intro-recordings/${sub}/${v4()}`;

			// assing intro id
			introId = v4();

			// copy file from public directory to private directory
			await s3CloneObject(BUCKETNAME, introKey, BUCKETNAME, introKeyPrivate);

			// make recording readable
			await s3UpdateACL(BUCKETNAME, introKeyPrivate, 'public-read');

			// delete the original file
			await s3DeleteObject(BUCKETNAME, introKey);

			// public intro url
			const url = `https://s3.${REGION}.amazonaws.com/${BUCKETNAME}/${introKeyPrivate}`;

			// update cognito attribute
			await idpAdminUpdateUserAttributes(USERPOOLID, sub, {
				'custom:intro_duration': duration,
				'custom:intro_recording': introKeyPrivate,
				'custom:intro_recording_url': url,
			});

			// store the recording data
			const newRecording = await apsMutation(createRecording, {
				id: introId,
				owner: sub,
				userId: sub,
				duration, // this is the duration of the recording
				key: introKeyPrivate,
				url,
			});
			introModel = (await newRecording).data.createRecording;
		} catch (err) {
			console.log('Error in updating intro recording', err);
		}
	}

	// prepare form data
	const data = {
		id: sub,
		owner: sub,

		email,

		givenName,
		familyName,
		name,

		pictureNormal,
		pictureMasked,

		gender,
		lookingFor,
		ageRange,

		distance,
		locale: safelyParseJSON(locale) ?? [],

		interestCreativity,
		interestSports,
		interestVideo,
		interestMusic,
		interestTravelling,
		interestPet,

		introId,

		searchTerm,
	};

	// create or update user profile
	try {
		// update existing user
		const user = await apsQuery(getUser, { id: sub });
		const { _version } = user.data.getUser;
		const userUpdated = await apsMutation(updateUser, { ...data, _version });
		return res.status(200).json(userUpdated.data.updateUser);
	} catch (err) {
		// create new user profile
		console.log('Error updating existing user - tyring to create new user', err);
		const user = await apsMutation(createUser, data);
		return res.status(200).json(user.data.createUser);
	}
});

app.post('/api/v1/onboard/done', verifyToken, async (req, res, next) => {
	// current user
	const { Username: sub } = req.user;

	// get profile
	const userProfile = (await apsQuery(getUser, { id: sub })).data.getUser;

	// this is supposed to be called only once
	if (userProfile.isSetupDone === true) {
		console.log('Setup already complete - exit');
		// return res.status(200).json({});
	}

	/**
	 * @summary
	 * get all profiles
	 *
	 * @todo
	 * Ignore deleted users
	 */
	const allProfiles = await apsGetAll(listUsers, {}, 'listUsers');

	// find matching profiles
	let matchingProfiles = [];
	for (let i = 0; i < allProfiles.length; i++) {
		const _profile = allProfiles[i];
		// Exclude the target user from the matching process
		if (_profile.id === userProfile.id) {
			continue;
		}
		const matchPercentage = calculateMatchPercentage(_profile, userProfile);
		matchingProfiles.push({
			user: _profile,
			matchPercentage,
		});
	}
	console.log(`Found ${matchingProfiles.length} matching profiles`);

	// Sort the matching users based on match percentage in descending order
	matchingProfiles.sort((a, b) => b.matchPercentage - a.matchPercentage);

	// create matches
	let promises = [];
	for (let i = 0; i < matchingProfiles.length; i++) {
		const { user: _profile, matchPercentage } = matchingProfiles[i];
		const { id: memberId } = _profile;

		// connection ids for user and member
		const connectionIdUser = `${sub}-${memberId}`;
		const connectionIdMember = `${memberId}-${sub}`;

		// chat id
		const chatId = [sub, memberId].sort().join('-');

		// check if connections already exist
		const existingConnections = await Promise.all([apsQuery(getConnection, { id: connectionIdUser }), apsQuery(getConnection, { id: connectionIdMember })]);

		// skip if already exists
		if (existingConnections?.[0]?.data?.getConnection?.id || existingConnections?.[1]?.data?.getConnection?.id) {
			console.log('Connection already exists - skip', { connectionIdUser, connectionIdMember, chatId });
			continue;
		}

		// add user connection
		promises.push(
			apsMutation(createConnection, {
				id: connectionIdUser,
				owner: sub,
				userId: sub,
				memberId,
				chatId,
				isSender: true,
				isReceiver: false,
				matchPercentage,
			})
		);

		// add member connection
		promises.push(
			apsMutation(createConnection, {
				id: connectionIdMember,
				owner: memberId,
				userId: memberId,
				memberId: sub,
				chatId,
				isSender: false,
				isReceiver: true,
				matchPercentage,
			})
		);

		// take top 10 results - 2 connections for each user
		if (promises.length >= 20) {
			break;
		}
	}

	// create connections
	console.log(`Creating ${promises.length} connections`);
	await Promise.all(promises);

	// mark profile setup as completed
	await Promise.all([
		apsMutation(updateUser, { id: sub, isSetupDone: true }),
		await idpAdminUpdateUserAttributes(USERPOOLID, sub, {
			'custom:is_setup_done': 'true',
		}),
	]);

	// all done
	return res.status(200).json({});
});
