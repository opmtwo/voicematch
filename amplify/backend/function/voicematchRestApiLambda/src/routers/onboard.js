const app = require('app');
const sharp = require('sharp');
const { v4 } = require('uuid');
const { default: slugify } = require('slugify');
const { verifyToken } = require('../middlewares/auth');
const { idpGetUserAttribute, idpAdminUpdateUserAttributes } = require('../utils/idp-utils');
const { apsQuery, apsMutation } = require('../utils/aps-utils');
const { s3GetObject, s3PutObject, s3UpdateACL } = require('../utils/s3-utils');
const { createUser, updateUser, createRecording } = require('../gql/mutations');
const { getUser } = require('../gql/queries');

const { REGION, STORAGE_VOICEMATCHSTORAGE_BUCKETNAME: BUCKETNAME, AUTH_VOICEMATCHC92D7B64_USERPOOLID: USERPOOLID } = process.env;

app.post('/api/v1/onboard', verifyToken, async (req, res, next) => {
	const { Username: sub } = req.user;
	const { avatar, recording } = req.query;
	console.log({ avatar, recording });

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

	let pictureNormal = '';
	let pictureMasked = '';
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
			await s3UpdateACL(BUCKETNAME, introKey, 'public-read');

			// assing intro id
			introId = v4();

			// store the recording data
			const newRecording = await apsMutation(createRecording, {
				id: introId,
				owner: sub,
				userId: sub,
				duration: 30, // this is the duration of the recording
				key: `public/${introKey}`,
				url: `https://s3.${REGION}.amazonaws.com/${BUCKETNAME}/public/${introKey}`,
			});
			introModel = (await newRecording).data.createRecording;
		} catch (err) {
			console.log('Error in updating intro recording', err);
		}
	}

	// setup done?
	// setup is done when user has setup info and added recording
	// might be worth it to check for profile image as well
	let isSetupDone = false;
	if (pictureNormal && pictureMasked && introModel?.id) {
		isSetupDone = true;
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
		locale,

		interestCreativity,
		interestSports,
		interestVideo,
		interestMusic,
		interestTravelling,
		interestPet,

		introId,

		searchTerm,

		isSetupDone,
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
