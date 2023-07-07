const AWS = require('aws-sdk');

const idpListUserPoolClients = async (userPoolId, verbose = true) => {
	if (verbose) {
		console.log(`idpListUserPoolClients - userPoolId: ${userPoolId}`);
	}
	try {
		const idp = new AWS.CognitoIdentityServiceProvider();
		const res = await idp.listUserPoolClients({ UserPoolId: userPoolId }).promise();
		if (verbose) {
			console.log(`idpListUserPoolClients - res: ${JSON.stringify(res)}`);
		}
		return res;
	} catch (err) {
		if (verbose) {
			console.log('idpListUserPoolClients - err', err);
		}
		throw err;
	}
};

const idpGetClientId = async (userPoolId, verbose = true) => {
	if (verbose) {
		console.log(`idpGetClientId - userPoolId: ${userPoolId}`);
	}
	try {
		const res = await idpListUserPoolClients(userPoolId, verbose);
		if (verbose) {
			console.log(`idpGetClientId - res: ${JSON.stringify(res)}`);
		}
		const clientId = res.UserPoolClients[0].ClientId;
		if (verbose) {
			console.log('idpGetClientId - clientId', clientId);
		}
		return clientId;
	} catch (err) {
		if (verbose) {
			console.log('idpGetClientId - err', err);
		}
		throw err;
	}
};

const idpGetUserByToken = async (token, verbose = true) => {
	if (verbose) {
		console.log(`idpGetUserByToken - token: ${token}`);
	}
	try {
		const idp = new AWS.CognitoIdentityServiceProvider();
		const accessToken = token.replace(/\/bearer/gi, '');
		if (verbose) {
			console.log(`idpGetUserByToken - accessToken: ${accessToken}`);
		}
		const res = await idp.getUser({ AccessToken: accessToken }).promise();
		if (verbose) {
			console.log('idpGetUserByToken - res', res);
		}
		return res;
	} catch (err) {
		if (verbose) {
			console.log('idpGetUserByToken - err', err);
		}
		throw err;
	}
};

const idpGetUserByKey = async (userPoolId, filter, limit = 1, paginationToken = null, verbose = true) => {
	if (verbose) {
		console.log(`idpGetUserByKey - userPoolId: ${userPoolId}, filter: ${filter}, limit: ${limit}, paginationToken: ${paginationToken}`);
	}
	try {
		const idp = new AWS.CognitoIdentityServiceProvider();
		const res = [];
		let token = paginationToken;
		while (true) {
			const idpRes = await idp
				.listUsers({
					UserPoolId: userPoolId,
					Filter: filter,
					Limit: limit,
					PaginationToken: token,
				})
				.promise();
			res.push(idpRes.Users);
			if (!idpRes.PaginationToken) {
				if (verbose) {
					console.log(`idpGetUserByKey - PaginationToken not found - break`);
				}
				break;
			}
			if (res.length >= limit) {
				if (verbose) {
					console.log(`idpGetUserByKey - limit: ${limit} reached - break`);
				}
				break;
			}
			token = idpRes.PaginationToken;
		}
		if (verbose) {
			console.log('idpGetUserByKey - res', res);
		}
		return res;
	} catch (err) {
		if (verbose) {
			console.log('idpGetUserByKey - err', err);
		}
		throw err;
	}
};

const idpAdminGetUser = async (userPoolId, username, verbose = true) => {
	if (verbose) {
		console.log(`idpAdminGetUser - ${userPoolId}, ${username}`);
	}
	try {
		const idp = new AWS.CognitoIdentityServiceProvider();
		const res = await idp.adminGetUser({ UserPoolId: userPoolId, Username: username }).promise();
		if (verbose) {
			console.log('idpAdminGetUser - res', res);
		}
		return res;
	} catch (err) {
		if (verbose) {
			console.log('idpAdminGetUser - err', err);
		}
		throw err;
	}
};

const idpListUsers = async (userPoolId, limit = null, paginationToken = null, verbose = true) => {
	if (verbose) {
		console.log(`idpListUsers - ${userPoolId}, ${limit}, ${paginationToken}`);
	}
	try {
		const idp = new AWS.CognitoIdentityServiceProvider();
		let res = [];
		let token = paginationToken;
		while (true) {
			const idpRes = await idp.listUsers({ UserPoolId: userPoolId, Limit: limit, PaginationToken: token }).promise();
			res = res.concat(idpRes.Users);
			if (!idpRes.PaginationToken) {
				if (verbose) {
					console.log(`idpListUsers - PaginationToken not found - break`);
				}
				break;
			}
			if (limit && res.length >= limit) {
				if (verbose) {
					console.log(`idpListUsers - ${limit} reached - break`);
				}
				break;
			}
			token = idpRes.PaginationToken;
		}
		if (verbose) {
			console.log('idpListUsers - res', res);
		}
		return res;
	} catch (err) {
		if (verbose) {
			console.log('idpListUsers - err', err);
		}
		throw err;
	}
};

const idpListUsersInGroup = async (userPoolId, groupName, limit = null, nextToken = null, verbose = true) => {
	if (verbose) {
		console.log(`idpListUsersInGroup - ${userPoolId}, ${groupName}, ${limit}, ${nextToken}`);
	}
	try {
		const idp = new AWS.CognitoIdentityServiceProvider();
		const res = [];
		let token = nextToken;
		while (true) {
			const idpRes = await idp
				.listUsersInGroup({
					UserPoolId: userPoolId,
					GroupName: groupName,
					Limit: limit,
					NextToken: token,
				})
				.promise();
			res.push(...idpRes.Users);
			if (!idpRes.NextToken) {
				if (verbose) {
					console.log('idpListUsersInGroup - NextToken not found - break');
				}
				break;
			}
			if (res.length >= limit) {
				if (verbose) {
					console.log(`idpListUsersInGroup - ${limit} reached - break`);
				}
				break;
			}
			token = idpRes.NextToken;
		}
		if (verbose) {
			console.log('idpListUsersInGroup - res', res);
		}
		return res;
	} catch (err) {
		if (verbose) {
			console.log('idpListUsersInGroup - err', err);
		}
		throw err;
	}
};

const idpAdminAddUserToGroup = async (userPoolId, username, groupName, verbose = true) => {
	if (verbose) {
		console.log(`idpAdminAddUserToGroup - userPoolId = ${userPoolId}, username = ${username}, groupName = ${groupName}`);
	}
	try {
		const idp = new AWS.CognitoIdentityServiceProvider();
		const res = await idp
			.adminAddUserToGroup({
				UserPoolId: userPoolId,
				Username: username,
				GroupName: groupName,
			})
			.promise();
		if (verbose) {
			console.log('idpAdminAddUserToGroup - res', res);
		}
		return res;
	} catch (err) {
		if (verbose) {
			console.log('idpAdminAddUserToGroup - err', err);
		}
		throw err;
	}
};

const idpAdminRemoveUserFromGroup = async (userPoolId, username, groupName, verbose = true) => {
	if (verbose) {
		console.log(`idpAdminRemoveUserFromGroup - userPoolId=${userPoolId}, username=${username}, groupName=${groupName}`);
	}
	try {
		const idp = new AWS.CognitoIdentityServiceProvider();
		const res = await idp
			.adminRemoveUserFromGroup({
				UserPoolId: userPoolId,
				Username: username,
				GroupName: groupName,
			})
			.promise();
		if (verbose) {
			console.log('idpAdminRemoveUserFromGroup - res', res);
		}
		return res;
	} catch (err) {
		if (verbose) {
			console.log('idpAdminRemoveUserFromGroup - err', err);
		}
		throw err;
	}
};

const idpAdminConfirmSignUp = async (userPoolId, username, verbose = true) => {
	if (verbose) {
		console.log(`idpAdminConfirmSignUp - userPoolId=${userPoolId}, username=${username}`);
	}
	try {
		const idp = new AWS.CognitoIdentityServiceProvider();
		const res = await idp
			.adminConfirmSignUp({
				UserPoolId: userPoolId,
				Username: username,
			})
			.promise();
		if (verbose) {
			console.log('idpAdminConfirmSignUp - res', res);
		}
		return res;
	} catch (err) {
		if (verbose) {
			console.log('idpAdminConfirmSignUp - err', err);
		}
		throw err;
	}
};

const idpAdminDisableUser = async (userPoolId, username, verbose = true) => {
	if (verbose) {
		console.log(`idpAdminDisableUser - userPoolId=${userPoolId}, username=${username}`);
	}
	try {
		const idp = new AWS.CognitoIdentityServiceProvider();
		const res = await idp.adminDisableUser({ UserPoolId: userPoolId, Username: username }).promise();
		if (verbose) {
			console.log('idpAdminDisableUser - res', res);
		}
		return res;
	} catch (err) {
		if (verbose) {
			console.log('idpAdminDisableUser - err', err);
		}
		throw err;
	}
};

const idpAdminEnableUser = async (userPoolId, username, verbose = true) => {
	if (verbose) {
		console.log(`idpAdminEnableUser - userPoolId=${userPoolId}, username=${username}`);
	}
	try {
		const idp = new AWS.CognitoIdentityServiceProvider();
		const res = await idp.adminEnableUser({ UserPoolId: userPoolId, Username: username }).promise();
		if (verbose) {
			console.log('idpAdminEnableUser - res', res);
		}
		return res;
	} catch (err) {
		if (verbose) {
			console.log('idpAdminEnableUser - err', err);
		}
		throw err;
	}
};

const idpListGroups = async (userPoolId, limit = null, paginationToken = null, verbose = true) => {
	if (verbose) {
		console.log(`idpListGroups - userPoolId=${userPoolId}, limit=${limit}, paginationToken=${paginationToken}`);
	}
	try {
		const idp = new AWS.CognitoIdentityServiceProvider();
		const res = [];
		let token = paginationToken;
		while (true) {
			const idpRes = await idp.listGroups({ UserPoolId: userPoolId, Limit: limit, PaginationToken: token }).promise();
			res.push(...idpRes.Groups);
			if (!idpRes.PaginationToken) {
				if (verbose) {
					console.log(`idpListGroups - PaginationToken not found - break`);
				}
				break;
			}
			if (limit && res.length >= limit) {
				if (verbose) {
					console.log(`idpListGroups - limit=${limit} reached - break`);
				}
				break;
			}
			token = idpRes.PaginationToken;
		}
		if (verbose) {
			console.log('idpListGroups - res', res);
		}
		return res;
	} catch (err) {
		if (verbose) {
			console.log('idpListGroups - err', err);
		}
		throw err;
	}
};

const idpAdminListGroupsForUser = async (userPoolId, username, limit = null, nextToken = null, verbose = true) => {
	if (verbose) {
		console.log(`idpAdminListGroupsForUser - userPoolId=${userPoolId}, username=${username}, limit=${limit}, nextToken=${nextToken}`);
	}
	try {
		const idp = new AWS.CognitoIdentityServiceProvider();
		const groups = [];
		let token = nextToken;
		while (true) {
			const response = await idp
				.adminListGroupsForUser({
					UserPoolId: userPoolId,
					Username: username,
					Limit: limit,
					NextToken: token,
				})
				.promise();
			groups.push(...response.Groups);
			if (!response.NextToken) {
				if (verbose) {
					console.log('idpAdminListGroupsForUser - NextToken not found - break');
				}
				break;
			}
			if (limit && groups.length >= limit) {
				if (verbose) {
					console.log(`idpAdminListGroupsForUser - limit=${limit} reached - break`);
				}
				break;
			}
			token = response.NextToken;
		}
		if (verbose) {
			console.log('idpAdminListGroupsForUser - res', groups);
		}
		return groups;
	} catch (err) {
		if (verbose) {
			console.log('idpAdminListGroupsForUser - err', err);
		}
		throw err;
	}
};

const idpCreateGroup = async (userPoolId, groupName, precedence = 2, verbose = true) => {
	if (verbose) {
		console.log(`idpCreateGroup - userPoolId=${userPoolId}, groupName=${groupName}, precedence=${precedence}`);
	}
	try {
		const idp = new AWS.CognitoIdentityServiceProvider();
		const res = await idp
			.createGroup({
				UserPoolId: userPoolId,
				GroupName: groupName,
				Precedence: precedence,
			})
			.promise();
		if (verbose) {
			console.log('idpCreateGroup - res', res);
		}
		return res;
	} catch (err) {
		if (verbose) {
			console.log('idpCreateGroup - err', err);
		}
		throw err;
	}
};

const idpSignUp = async (userPoolId, username, password, userAttributes, verbose = true) => {
	if (verbose) {
		console.log(`idpSignUp - userPoolId=${userPoolId}, username=${username}, password=${password}, userAttributes=${JSON.stringify(userAttributes)}`);
	}
	try {
		const idp = new AWS.CognitoIdentityServiceProvider();
		const clientId = await idpGetClientId(userPoolId, verbose);
		const attributes = [];
		for (const [key, value] of Object.entries(userAttributes)) {
			if (value !== null) {
				attributes.push({ Name: key, Value: value });
			}
		}
		if (verbose) {
			console.log('idpSignUp - attributes', JSON.stringify(attributes));
		}
		const res = await idp
			.signUp({
				ClientId: clientId,
				Username: username,
				Password: password,
				UserAttributes: attributes,
			})
			.promise();
		if (verbose) {
			console.log('idpSignUp - res', res);
		}
		return res;
	} catch (err) {
		if (verbose) {
			console.log('idpSignUp - err', err);
		}
		throw err;
	}
};

const idpAdminCreateUser = async (userPoolId, username, userAttributes, desiredDeliveryMediums, verbose = true) => {
	if (verbose) {
		console.log(
			`idpAdminCreateUser - userPoolId=${userPoolId}, username=${username}, userAttributes=${userAttributes}, desiredDeliveryMediums=${desiredDeliveryMediums}`
		);
	}
	try {
		const idp = new AWS.CognitoIdentityServiceProvider();
		const attributes = [];
		for (const [key, val] of Object.entries(userAttributes)) {
			if (val) {
				attributes.push({ Name: key, Value: val });
			}
		}
		if (verbose) {
			console.log('idpAdminCreateUser - attributes', JSON.stringify(attributes));
		}
		const res = await idp
			.adminCreateUser({ UserPoolId: userPoolId, Username: username, UserAttributes: attributes, DesiredDeliveryMediums: desiredDeliveryMediums })
			.promise();
		if (verbose) {
			console.log('idpAdminCreateUser - res', res);
		}
		return res;
	} catch (err) {
		if (verbose) {
			console.log('idpAdminCreateUser - err', err);
		}
		throw err;
	}
};

const idpAdminUpdateUserAttributes = async (userPoolId, username, userAttributes, verbose = true) => {
	if (verbose) {
		console.log(`idpAdminUpdateUserAttributes - userPoolId=${userPoolId}, username=${username}, userAttributes=${userAttributes}`);
	}
	try {
		const idp = new AWS.CognitoIdentityServiceProvider();
		const attributes = [];
		for (const [key, val] of Object.entries(userAttributes)) {
			attributes.push({ Name: key, Value: val });
		}
		if (verbose) {
			console.log(`idpAdminUpdateUserAttributes - attributes=${attributes}`);
		}
		const res = await idp.adminUpdateUserAttributes({ UserPoolId: userPoolId, Username: username, UserAttributes: attributes }).promise();
		if (verbose) {
			console.log('idpAdminUpdateUserAttributes - res', res);
		}
		return res;
	} catch (err) {
		if (verbose) {
			console.log('idpAdminUpdateUserAttributes - err', err);
		}
		throw err;
	}
};

const idpAdminUserGlobalSignOut = async (userPoolId, username, verbose = true) => {
	if (verbose) {
		console.log(`idpAdminUserGlobalSignOut - userPoolId=${userPoolId}, username=${username}`);
	}
	try {
		const idp = new AWS.CognitoIdentityServiceProvider();
		const params = {
			UserPoolId: userPoolId,
			Username: username,
		};
		const res = await idp.adminUserGlobalSignOut(params).promise();
		if (verbose) {
			console.log('idpAdminUserGlobalSignOut - res', res);
		}
		return res;
	} catch (err) {
		if (verbose) {
			console.log('idpAdminUserGlobalSignOut - err', err);
		}
		throw err;
	}
};

const idpGetUserAttribute = async (user, key, defaultValue = null, verbose = false) => {
	if (verbose) {
		console.log(`getUserAttribute - user=${JSON.stringify(user)}, key=${key}, defaultValue=${defaultValue}`);
	}
	let attributes = user['UserAttributes'] || user['Attributes'] || null;
	if (!attributes) {
		if (verbose) {
			console.log('getUserAttribute - attributes not found');
		}
		return defaultValue;
	}
	for (const value of attributes) {
		if ('Name' in value && value['Name'] === key) {
			if (verbose) {
				console.log(`getUserAttribute - value=${JSON.stringify(value)}`);
			}
			return value['Value'];
		}
	}
	if (verbose) {
		console.log('getUserAttribute - value not found');
	}
	return defaultValue;
};

const idpAdminDeleteUser = async (userPoolId, username, verbose = true) => {
	if (verbose) {
		console.log(`idpAdminDeleteUser - ${userPoolId}, ${username}`);
	}
	try {
		const idp = new AWS.CognitoIdentityServiceProvider();
		const res = await idp
			.adminDeleteUser({
				UserPoolId: userPoolId,
				Username: username,
			})
			.promise();
		if (verbose) {
			console.log('idpAdminDeleteUser - res', res);
		}
		return res;
	} catch (err) {
		if (verbose) {
			console.log('idpAdminDeleteUser - err', err);
		}
		throw err;
	}
};

module.exports = {
	idpListUserPoolClients,
	idpGetClientId,
	idpGetUserByToken,
	idpGetUserByKey,
	idpAdminGetUser,
	idpListUsers,
	idpListUsersInGroup,
	idpAdminAddUserToGroup,
	idpAdminRemoveUserFromGroup,
	idpAdminConfirmSignUp,
	idpAdminDisableUser,
	idpAdminEnableUser,
	idpListGroups,
	idpAdminListGroupsForUser,
	idpCreateGroup,
	idpSignUp,
	idpAdminCreateUser,
	idpAdminUpdateUserAttributes,
	idpAdminUserGlobalSignOut,
	idpGetUserAttribute,
	idpAdminDeleteUser,
};
