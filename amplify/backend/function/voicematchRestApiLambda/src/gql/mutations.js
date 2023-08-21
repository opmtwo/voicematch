/* eslint-disable */
// this is an auto generated file. This will be overwritten

exports.createUser = /* GraphQL */ `
	mutation CreateUser($input: CreateUserInput!, $condition: ModelUserConditionInput) {
		createUser(input: $input, condition: $condition) {
			id
			owner
			onlinePresence {
				id
				owner
				status
				lastSeenAt
				createdAt
				updatedAt
				__typename
			}
			email
			name
			givenName
			familyName
			pictureNormal
			pictureMasked
			gender
			lookingFor
			ageRange
			distance
			locale
			interestCreativity
			interestSports
			interestVideo
			interestMusic
			interestTravelling
			interestPet
			introId
			intro {
				id
				owner
				userId
				duration
				key
				url
				createdAt
				updatedAt
				__typename
			}
			isSetupDone
			searchTerm
			createdAt
			updatedAt
			__typename
		}
	}
`;
exports.updateUser = /* GraphQL */ `
	mutation UpdateUser($input: UpdateUserInput!, $condition: ModelUserConditionInput) {
		updateUser(input: $input, condition: $condition) {
			id
			owner
			onlinePresence {
				id
				owner
				status
				lastSeenAt
				createdAt
				updatedAt
				__typename
			}
			email
			name
			givenName
			familyName
			pictureNormal
			pictureMasked
			gender
			lookingFor
			ageRange
			distance
			locale
			interestCreativity
			interestSports
			interestVideo
			interestMusic
			interestTravelling
			interestPet
			introId
			intro {
				id
				owner
				userId
				duration
				key
				url
				createdAt
				updatedAt
				__typename
			}
			isSetupDone
			searchTerm
			createdAt
			updatedAt
			__typename
		}
	}
`;
exports.deleteUser = /* GraphQL */ `
	mutation DeleteUser($input: DeleteUserInput!, $condition: ModelUserConditionInput) {
		deleteUser(input: $input, condition: $condition) {
			id
			owner
			onlinePresence {
				id
				owner
				status
				lastSeenAt
				createdAt
				updatedAt
				__typename
			}
			email
			name
			givenName
			familyName
			pictureNormal
			pictureMasked
			gender
			lookingFor
			ageRange
			distance
			locale
			interestCreativity
			interestSports
			interestVideo
			interestMusic
			interestTravelling
			interestPet
			introId
			intro {
				id
				owner
				userId
				duration
				key
				url
				createdAt
				updatedAt
				__typename
			}
			isSetupDone
			searchTerm
			createdAt
			updatedAt
			__typename
		}
	}
`;
exports.createOnlinePresence = /* GraphQL */ `
	mutation CreateOnlinePresence($input: CreateOnlinePresenceInput!, $condition: ModelOnlinePresenceConditionInput) {
		createOnlinePresence(input: $input, condition: $condition) {
			id
			owner
			status
			lastSeenAt
			createdAt
			updatedAt
			__typename
		}
	}
`;
exports.updateOnlinePresence = /* GraphQL */ `
	mutation UpdateOnlinePresence($input: UpdateOnlinePresenceInput!, $condition: ModelOnlinePresenceConditionInput) {
		updateOnlinePresence(input: $input, condition: $condition) {
			id
			owner
			status
			lastSeenAt
			createdAt
			updatedAt
			__typename
		}
	}
`;
exports.deleteOnlinePresence = /* GraphQL */ `
	mutation DeleteOnlinePresence($input: DeleteOnlinePresenceInput!, $condition: ModelOnlinePresenceConditionInput) {
		deleteOnlinePresence(input: $input, condition: $condition) {
			id
			owner
			status
			lastSeenAt
			createdAt
			updatedAt
			__typename
		}
	}
`;
exports.createRecording = /* GraphQL */ `
	mutation CreateRecording($input: CreateRecordingInput!, $condition: ModelRecordingConditionInput) {
		createRecording(input: $input, condition: $condition) {
			id
			owner
			userId
			duration
			key
			url
			createdAt
			updatedAt
			__typename
		}
	}
`;
exports.updateRecording = /* GraphQL */ `
	mutation UpdateRecording($input: UpdateRecordingInput!, $condition: ModelRecordingConditionInput) {
		updateRecording(input: $input, condition: $condition) {
			id
			owner
			userId
			duration
			key
			url
			createdAt
			updatedAt
			__typename
		}
	}
`;
exports.deleteRecording = /* GraphQL */ `
	mutation DeleteRecording($input: DeleteRecordingInput!, $condition: ModelRecordingConditionInput) {
		deleteRecording(input: $input, condition: $condition) {
			id
			owner
			userId
			duration
			key
			url
			createdAt
			updatedAt
			__typename
		}
	}
`;
exports.createUpload = /* GraphQL */ `
	mutation CreateUpload($input: CreateUploadInput!, $condition: ModelUploadConditionInput) {
		createUpload(input: $input, condition: $condition) {
			id
			owner
			userId
			modelId
			modelType
			name
			mime
			size
			duration
			key
			url
			keyThumb
			urlThumb
			createdAt
			updatedAt
			__typename
		}
	}
`;
exports.updateUpload = /* GraphQL */ `
	mutation UpdateUpload($input: UpdateUploadInput!, $condition: ModelUploadConditionInput) {
		updateUpload(input: $input, condition: $condition) {
			id
			owner
			userId
			modelId
			modelType
			name
			mime
			size
			duration
			key
			url
			keyThumb
			urlThumb
			createdAt
			updatedAt
			__typename
		}
	}
`;
exports.deleteUpload = /* GraphQL */ `
	mutation DeleteUpload($input: DeleteUploadInput!, $condition: ModelUploadConditionInput) {
		deleteUpload(input: $input, condition: $condition) {
			id
			owner
			userId
			modelId
			modelType
			name
			mime
			size
			duration
			key
			url
			keyThumb
			urlThumb
			createdAt
			updatedAt
			__typename
		}
	}
`;
exports.createConnection = /* GraphQL */ `
	mutation CreateConnection($input: CreateConnectionInput!, $condition: ModelConnectionConditionInput) {
		createConnection(input: $input, condition: $condition) {
			id
			owner
			chatId
			userId
			memberId
			user {
				id
				owner
				email
				name
				givenName
				familyName
				pictureNormal
				pictureMasked
				gender
				lookingFor
				ageRange
				distance
				locale
				interestCreativity
				interestSports
				interestVideo
				interestMusic
				interestTravelling
				interestPet
				introId
				isSetupDone
				searchTerm
				createdAt
				updatedAt
				__typename
			}
			member {
				id
				owner
				email
				name
				givenName
				familyName
				pictureNormal
				pictureMasked
				gender
				lookingFor
				ageRange
				distance
				locale
				interestCreativity
				interestSports
				interestVideo
				interestMusic
				interestTravelling
				interestPet
				introId
				isSetupDone
				searchTerm
				createdAt
				updatedAt
				__typename
			}
			onlinePresence {
				id
				owner
				status
				lastSeenAt
				createdAt
				updatedAt
				__typename
			}
			isSender
			isReceiver
			isAccepted
			isDeclined
			isBlocked
			isMuted
			isPinned
			acceptedAt
			declinedAt
			blockedAt
			mutedAt
			pinnedAt
			matchPercentage
			isUserRevealed
			userRevealedAt
			isMemberRevealed
			memberRevealedAt
			createdAt
			updatedAt
			__typename
		}
	}
`;
exports.updateConnection = /* GraphQL */ `
	mutation UpdateConnection($input: UpdateConnectionInput!, $condition: ModelConnectionConditionInput) {
		updateConnection(input: $input, condition: $condition) {
			id
			owner
			chatId
			userId
			memberId
			user {
				id
				owner
				email
				name
				givenName
				familyName
				pictureNormal
				pictureMasked
				gender
				lookingFor
				ageRange
				distance
				locale
				interestCreativity
				interestSports
				interestVideo
				interestMusic
				interestTravelling
				interestPet
				introId
				isSetupDone
				searchTerm
				createdAt
				updatedAt
				__typename
			}
			member {
				id
				owner
				email
				name
				givenName
				familyName
				pictureNormal
				pictureMasked
				gender
				lookingFor
				ageRange
				distance
				locale
				interestCreativity
				interestSports
				interestVideo
				interestMusic
				interestTravelling
				interestPet
				introId
				isSetupDone
				searchTerm
				createdAt
				updatedAt
				__typename
			}
			onlinePresence {
				id
				owner
				status
				lastSeenAt
				createdAt
				updatedAt
				__typename
			}
			isSender
			isReceiver
			isAccepted
			isDeclined
			isBlocked
			isMuted
			isPinned
			acceptedAt
			declinedAt
			blockedAt
			mutedAt
			pinnedAt
			matchPercentage
			isUserRevealed
			userRevealedAt
			isMemberRevealed
			memberRevealedAt
			createdAt
			updatedAt
			__typename
		}
	}
`;
exports.deleteConnection = /* GraphQL */ `
	mutation DeleteConnection($input: DeleteConnectionInput!, $condition: ModelConnectionConditionInput) {
		deleteConnection(input: $input, condition: $condition) {
			id
			owner
			chatId
			userId
			memberId
			user {
				id
				owner
				email
				name
				givenName
				familyName
				pictureNormal
				pictureMasked
				gender
				lookingFor
				ageRange
				distance
				locale
				interestCreativity
				interestSports
				interestVideo
				interestMusic
				interestTravelling
				interestPet
				introId
				isSetupDone
				searchTerm
				createdAt
				updatedAt
				__typename
			}
			member {
				id
				owner
				email
				name
				givenName
				familyName
				pictureNormal
				pictureMasked
				gender
				lookingFor
				ageRange
				distance
				locale
				interestCreativity
				interestSports
				interestVideo
				interestMusic
				interestTravelling
				interestPet
				introId
				isSetupDone
				searchTerm
				createdAt
				updatedAt
				__typename
			}
			onlinePresence {
				id
				owner
				status
				lastSeenAt
				createdAt
				updatedAt
				__typename
			}
			isSender
			isReceiver
			isAccepted
			isDeclined
			isBlocked
			isMuted
			isPinned
			acceptedAt
			declinedAt
			blockedAt
			mutedAt
			pinnedAt
			matchPercentage
			isUserRevealed
			userRevealedAt
			isMemberRevealed
			memberRevealedAt
			createdAt
			updatedAt
			__typename
		}
	}
`;
exports.createMessage = /* GraphQL */ `
	mutation CreateMessage($input: CreateMessageInput!, $condition: ModelMessageConditionInput) {
		createMessage(input: $input, condition: $condition) {
			id
			owner
			chatId
			userId
			type
			body
			uploadId
			upload {
				id
				owner
				userId
				modelId
				modelType
				name
				mime
				size
				duration
				key
				url
				keyThumb
				urlThumb
				createdAt
				updatedAt
				__typename
			}
			recordingId
			recording {
				id
				owner
				userId
				duration
				key
				url
				createdAt
				updatedAt
				__typename
			}
			createdAt
			updatedAt
			__typename
		}
	}
`;
exports.updateMessage = /* GraphQL */ `
	mutation UpdateMessage($input: UpdateMessageInput!, $condition: ModelMessageConditionInput) {
		updateMessage(input: $input, condition: $condition) {
			id
			owner
			chatId
			userId
			type
			body
			uploadId
			upload {
				id
				owner
				userId
				modelId
				modelType
				name
				mime
				size
				duration
				key
				url
				keyThumb
				urlThumb
				createdAt
				updatedAt
				__typename
			}
			recordingId
			recording {
				id
				owner
				userId
				duration
				key
				url
				createdAt
				updatedAt
				__typename
			}
			createdAt
			updatedAt
			__typename
		}
	}
`;
exports.deleteMessage = /* GraphQL */ `
	mutation DeleteMessage($input: DeleteMessageInput!, $condition: ModelMessageConditionInput) {
		deleteMessage(input: $input, condition: $condition) {
			id
			owner
			chatId
			userId
			type
			body
			uploadId
			upload {
				id
				owner
				userId
				modelId
				modelType
				name
				mime
				size
				duration
				key
				url
				keyThumb
				urlThumb
				createdAt
				updatedAt
				__typename
			}
			recordingId
			recording {
				id
				owner
				userId
				duration
				key
				url
				createdAt
				updatedAt
				__typename
			}
			createdAt
			updatedAt
			__typename
		}
	}
`;
exports.createMessageEvent = /* GraphQL */ `
	mutation CreateMessageEvent($input: CreateMessageEventInput!, $condition: ModelMessageEventConditionInput) {
		createMessageEvent(input: $input, condition: $condition) {
			id
			owner
			messageId
			userId
			chatId
			chatUserId
			type
			body
			uploadId
			upload {
				id
				owner
				userId
				modelId
				modelType
				name
				mime
				size
				duration
				key
				url
				keyThumb
				urlThumb
				createdAt
				updatedAt
				__typename
			}
			recordingId
			recording {
				id
				owner
				userId
				duration
				key
				url
				createdAt
				updatedAt
				__typename
			}
			deliveredAt
			readAt
			isSender
			isReceiver
			createdAt
			updatedAt
			__typename
		}
	}
`;
exports.updateMessageEvent = /* GraphQL */ `
	mutation UpdateMessageEvent($input: UpdateMessageEventInput!, $condition: ModelMessageEventConditionInput) {
		updateMessageEvent(input: $input, condition: $condition) {
			id
			owner
			messageId
			userId
			chatId
			chatUserId
			type
			body
			uploadId
			upload {
				id
				owner
				userId
				modelId
				modelType
				name
				mime
				size
				duration
				key
				url
				keyThumb
				urlThumb
				createdAt
				updatedAt
				__typename
			}
			recordingId
			recording {
				id
				owner
				userId
				duration
				key
				url
				createdAt
				updatedAt
				__typename
			}
			deliveredAt
			readAt
			isSender
			isReceiver
			createdAt
			updatedAt
			__typename
		}
	}
`;
exports.deleteMessageEvent = /* GraphQL */ `
	mutation DeleteMessageEvent($input: DeleteMessageEventInput!, $condition: ModelMessageEventConditionInput) {
		deleteMessageEvent(input: $input, condition: $condition) {
			id
			owner
			messageId
			userId
			chatId
			chatUserId
			type
			body
			uploadId
			upload {
				id
				owner
				userId
				modelId
				modelType
				name
				mime
				size
				duration
				key
				url
				keyThumb
				urlThumb
				createdAt
				updatedAt
				__typename
			}
			recordingId
			recording {
				id
				owner
				userId
				duration
				key
				url
				createdAt
				updatedAt
				__typename
			}
			deliveredAt
			readAt
			isSender
			isReceiver
			createdAt
			updatedAt
			__typename
		}
	}
`;
exports.createToken = /* GraphQL */ `
	mutation CreateToken($input: CreateTokenInput!, $condition: ModelTokenConditionInput) {
		createToken(input: $input, condition: $condition) {
			id
			userId
			value
			createdAt
			updatedAt
			owner
			__typename
		}
	}
`;
exports.updateToken = /* GraphQL */ `
	mutation UpdateToken($input: UpdateTokenInput!, $condition: ModelTokenConditionInput) {
		updateToken(input: $input, condition: $condition) {
			id
			userId
			value
			createdAt
			updatedAt
			owner
			__typename
		}
	}
`;
exports.deleteToken = /* GraphQL */ `
	mutation DeleteToken($input: DeleteTokenInput!, $condition: ModelTokenConditionInput) {
		deleteToken(input: $input, condition: $condition) {
			id
			userId
			value
			createdAt
			updatedAt
			owner
			__typename
		}
	}
`;
