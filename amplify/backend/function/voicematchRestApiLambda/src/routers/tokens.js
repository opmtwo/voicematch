const app = require('app');
const { v4 } = require('uuid');
const { verifyToken } = require('../middlewares/auth');
const { ddbDecode, ddbGet, ddbQuery, ddbPut, ddbUpdate, ddbDelete } = require('../utils/ddb-utils');
const { validateFormData, IToken } = require('../schemas');
const { API_VOICEMATCHGRAPHAPI_TOKENTABLE_NAME: TOKENTABLE_NAME } = process.env;

app.get('/api/v1/tokens', verifyToken, async (req, res, next) => {
	const { Username: sub } = req.user;

	// fetch all tokens owned by this user
	const tokens = await ddbQuery(
		TOKENTABLE_NAME,
		'listTokensByUserId',
		'#userId = :userId',
		{
			'#userId': 'userId',
		},
		{
			':userId': sub,
		}
	);

	// normalize all the tokens
	// const items = tokens.map((item) => ddbDecode(item));

	// return list of tokens
	// return res.status(200).json(items);
	return res.status(200).json(tokens);
});

app.post('/api/v1/tokens', validateFormData(IToken), verifyToken, async (req, res, next) => {
	const { Username: sub } = req.user;

	// parse form data
	const { token } = req.body;

	// fetch all tokens owned by this user
	const tokens = await ddbQuery(
		TOKENTABLE_NAME,
		'listTokensByUserId',
		'#userId = :userId',
		{
			'#userId': 'userId',
		},
		{
			':userId': sub,
		}
	);

	// if token is already present then return
	for (let i = 0; i < tokens.length; i++) {
		if (tokens[i]?.value === token.trim()) {
			console.log('Token is already present - ', tokens[i]);
			return res.status(200).json(tokens[i]);
		}
	}

	// create new id for new item
	const newId = v4();

	// current timestamp
	const now = new Date().toISOString();

	// add new item
	await ddbPut(TOKENTABLE_NAME, {
		id: newId,
		userId: sub,
		owner: sub,
		value: token,
		createdAt: now,
		updatedAt: now,
	});

	// fetch newly added token
	const newItem = await ddbGet(TOKENTABLE_NAME, { id: newId });
	const newItemData = ddbDecode(newItem.Item);

	// return newly added token
	return res.status(200).json(newItemData);
});

app.get('/api/v1/tokens/:id', verifyToken, async (req, res, next) => {
	const { Username: sub } = req.user;
	const { id } = req.params;

	// get token
	const token = await ddbGet(TOKENTABLE_NAME, { id });

	// make sure token is valid
	if (!token?.id) {
		return res.status(404).json({ message: 'Not found' });
	}

	// make sure token belongs to current user
	if (token.owner !== sub) {
		return res.status(403).json({ message: 'Access denied' });
	}

	// return token data
	return res.status(200).json(token);
});

app.delete('/api/v1/tokens/:id', verifyToken, async (req, res, next) => {
	const { Username: sub } = req.user;
	const { id } = req.params;

	// fetch token data
	const token = await ddbGet(TOKENTABLE_NAME, { id });

	// make sure token is valid
	if (!token?.id) {
		return res.status(404).json({ message: 'Not found' });
	}

	// make sure token belongs to current user
	if (token?.owner !== sub) {
		return res.status(403).json({});
	}

	// delete token
	await ddbDelete(TOKENTABLE_NAME, { id });

	// return success response
	return res.status(200).json(token);
});
