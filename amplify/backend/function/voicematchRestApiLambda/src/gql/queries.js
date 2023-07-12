/* eslint-disable */
// this is an auto generated file. This will be overwritten

exports.getUser = /* GraphQL */ `
	query GetUser($id: ID!) {
		getUser(id: $id) {
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
exports.listUsers = /* GraphQL */ `
	query ListUsers($filter: ModelUserFilterInput, $limit: Int, $nextToken: String) {
		listUsers(filter: $filter, limit: $limit, nextToken: $nextToken) {
			items {
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
			nextToken
			__typename
		}
	}
`;
exports.getOnlinePresence = /* GraphQL */ `
	query GetOnlinePresence($id: ID!) {
		getOnlinePresence(id: $id) {
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
exports.listOnlinePresences = /* GraphQL */ `
	query ListOnlinePresences($filter: ModelOnlinePresenceFilterInput, $limit: Int, $nextToken: String) {
		listOnlinePresences(filter: $filter, limit: $limit, nextToken: $nextToken) {
			items {
				id
				owner
				status
				lastSeenAt
				createdAt
				updatedAt
				__typename
			}
			nextToken
			__typename
		}
	}
`;
exports.getRecording = /* GraphQL */ `
	query GetRecording($id: ID!) {
		getRecording(id: $id) {
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
exports.listRecordings = /* GraphQL */ `
	query ListRecordings($filter: ModelRecordingFilterInput, $limit: Int, $nextToken: String) {
		listRecordings(filter: $filter, limit: $limit, nextToken: $nextToken) {
			items {
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
			nextToken
			__typename
		}
	}
`;
exports.listRecordingsByUserId = /* GraphQL */ `
	query ListRecordingsByUserId(
		$userId: ID!
		$createdAt: ModelStringKeyConditionInput
		$sortDirection: ModelSortDirection
		$filter: ModelRecordingFilterInput
		$limit: Int
		$nextToken: String
	) {
		listRecordingsByUserId(userId: $userId, createdAt: $createdAt, sortDirection: $sortDirection, filter: $filter, limit: $limit, nextToken: $nextToken) {
			items {
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
			nextToken
			__typename
		}
	}
`;
exports.getUpload = /* GraphQL */ `
	query GetUpload($id: ID!) {
		getUpload(id: $id) {
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
			createdAt
			updatedAt
			__typename
		}
	}
`;
exports.listUploads = /* GraphQL */ `
	query ListUploads($filter: ModelUploadFilterInput, $limit: Int, $nextToken: String) {
		listUploads(filter: $filter, limit: $limit, nextToken: $nextToken) {
			items {
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
				createdAt
				updatedAt
				__typename
			}
			nextToken
			__typename
		}
	}
`;
exports.listUploadsByUserId = /* GraphQL */ `
	query ListUploadsByUserId(
		$userId: ID!
		$createdAt: ModelStringKeyConditionInput
		$sortDirection: ModelSortDirection
		$filter: ModelUploadFilterInput
		$limit: Int
		$nextToken: String
	) {
		listUploadsByUserId(userId: $userId, createdAt: $createdAt, sortDirection: $sortDirection, filter: $filter, limit: $limit, nextToken: $nextToken) {
			items {
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
				createdAt
				updatedAt
				__typename
			}
			nextToken
			__typename
		}
	}
`;
exports.listUploadsByModelId = /* GraphQL */ `
	query ListUploadsByModelId(
		$modelId: ID!
		$createdAt: ModelStringKeyConditionInput
		$sortDirection: ModelSortDirection
		$filter: ModelUploadFilterInput
		$limit: Int
		$nextToken: String
	) {
		listUploadsByModelId(modelId: $modelId, createdAt: $createdAt, sortDirection: $sortDirection, filter: $filter, limit: $limit, nextToken: $nextToken) {
			items {
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
				createdAt
				updatedAt
				__typename
			}
			nextToken
			__typename
		}
	}
`;
exports.getConnection = /* GraphQL */ `
	query GetConnection($id: ID!) {
		getConnection(id: $id) {
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
			createdAt
			updatedAt
			__typename
		}
	}
`;
exports.listConnections = /* GraphQL */ `
	query ListConnections($filter: ModelConnectionFilterInput, $limit: Int, $nextToken: String) {
		listConnections(filter: $filter, limit: $limit, nextToken: $nextToken) {
			items {
				id
				owner
				chatId
				userId
				memberId
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
				createdAt
				updatedAt
				__typename
			}
			nextToken
			__typename
		}
	}
`;
exports.listConnectionByChatId = /* GraphQL */ `
	query ListConnectionByChatId(
		$chatId: ID!
		$createdAt: ModelStringKeyConditionInput
		$sortDirection: ModelSortDirection
		$filter: ModelConnectionFilterInput
		$limit: Int
		$nextToken: String
	) {
		listConnectionByChatId(chatId: $chatId, createdAt: $createdAt, sortDirection: $sortDirection, filter: $filter, limit: $limit, nextToken: $nextToken) {
			items {
				id
				owner
				chatId
				userId
				memberId
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
				createdAt
				updatedAt
				__typename
			}
			nextToken
			__typename
		}
	}
`;
exports.listConnectionByUserId = /* GraphQL */ `
	query ListConnectionByUserId(
		$userId: ID!
		$createdAt: ModelStringKeyConditionInput
		$sortDirection: ModelSortDirection
		$filter: ModelConnectionFilterInput
		$limit: Int
		$nextToken: String
	) {
		listConnectionByUserId(userId: $userId, createdAt: $createdAt, sortDirection: $sortDirection, filter: $filter, limit: $limit, nextToken: $nextToken) {
			items {
				id
				owner
				chatId
				userId
				memberId
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
				createdAt
				updatedAt
				__typename
			}
			nextToken
			__typename
		}
	}
`;
exports.listConnectionByMemberId = /* GraphQL */ `
	query ListConnectionByMemberId(
		$memberId: ID!
		$createdAt: ModelStringKeyConditionInput
		$sortDirection: ModelSortDirection
		$filter: ModelConnectionFilterInput
		$limit: Int
		$nextToken: String
	) {
		listConnectionByMemberId(
			memberId: $memberId
			createdAt: $createdAt
			sortDirection: $sortDirection
			filter: $filter
			limit: $limit
			nextToken: $nextToken
		) {
			items {
				id
				owner
				chatId
				userId
				memberId
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
				createdAt
				updatedAt
				__typename
			}
			nextToken
			__typename
		}
	}
`;
exports.getMessage = /* GraphQL */ `
	query GetMessage($id: ID!) {
		getMessage(id: $id) {
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
exports.listMessages = /* GraphQL */ `
	query ListMessages($filter: ModelMessageFilterInput, $limit: Int, $nextToken: String) {
		listMessages(filter: $filter, limit: $limit, nextToken: $nextToken) {
			items {
				id
				owner
				chatId
				userId
				type
				body
				uploadId
				createdAt
				updatedAt
				__typename
			}
			nextToken
			__typename
		}
	}
`;
exports.listMessageByChatId = /* GraphQL */ `
	query ListMessageByChatId(
		$chatId: ID!
		$createdAt: ModelStringKeyConditionInput
		$sortDirection: ModelSortDirection
		$filter: ModelMessageFilterInput
		$limit: Int
		$nextToken: String
	) {
		listMessageByChatId(chatId: $chatId, createdAt: $createdAt, sortDirection: $sortDirection, filter: $filter, limit: $limit, nextToken: $nextToken) {
			items {
				id
				owner
				chatId
				userId
				type
				body
				uploadId
				createdAt
				updatedAt
				__typename
			}
			nextToken
			__typename
		}
	}
`;
exports.listMessageByUserId = /* GraphQL */ `
	query ListMessageByUserId(
		$userId: ID!
		$createdAt: ModelStringKeyConditionInput
		$sortDirection: ModelSortDirection
		$filter: ModelMessageFilterInput
		$limit: Int
		$nextToken: String
	) {
		listMessageByUserId(userId: $userId, createdAt: $createdAt, sortDirection: $sortDirection, filter: $filter, limit: $limit, nextToken: $nextToken) {
			items {
				id
				owner
				chatId
				userId
				type
				body
				uploadId
				createdAt
				updatedAt
				__typename
			}
			nextToken
			__typename
		}
	}
`;
exports.getMessageEvent = /* GraphQL */ `
	query GetMessageEvent($id: ID!) {
		getMessageEvent(id: $id) {
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
				createdAt
				updatedAt
				__typename
			}
			readAt
			createdAt
			updatedAt
			__typename
		}
	}
`;
exports.listMessageEvents = /* GraphQL */ `
	query ListMessageEvents($filter: ModelMessageEventFilterInput, $limit: Int, $nextToken: String) {
		listMessageEvents(filter: $filter, limit: $limit, nextToken: $nextToken) {
			items {
				id
				owner
				messageId
				userId
				chatId
				chatUserId
				type
				body
				uploadId
				readAt
				createdAt
				updatedAt
				__typename
			}
			nextToken
			__typename
		}
	}
`;
exports.listMessageEventByMessageId = /* GraphQL */ `
	query ListMessageEventByMessageId(
		$messageId: ID!
		$createdAt: ModelStringKeyConditionInput
		$sortDirection: ModelSortDirection
		$filter: ModelMessageEventFilterInput
		$limit: Int
		$nextToken: String
	) {
		listMessageEventByMessageId(
			messageId: $messageId
			createdAt: $createdAt
			sortDirection: $sortDirection
			filter: $filter
			limit: $limit
			nextToken: $nextToken
		) {
			items {
				id
				owner
				messageId
				userId
				chatId
				chatUserId
				type
				body
				uploadId
				readAt
				createdAt
				updatedAt
				__typename
			}
			nextToken
			__typename
		}
	}
`;
exports.listMessageEventByUserId = /* GraphQL */ `
	query ListMessageEventByUserId(
		$userId: ID!
		$createdAt: ModelStringKeyConditionInput
		$sortDirection: ModelSortDirection
		$filter: ModelMessageEventFilterInput
		$limit: Int
		$nextToken: String
	) {
		listMessageEventByUserId(userId: $userId, createdAt: $createdAt, sortDirection: $sortDirection, filter: $filter, limit: $limit, nextToken: $nextToken) {
			items {
				id
				owner
				messageId
				userId
				chatId
				chatUserId
				type
				body
				uploadId
				readAt
				createdAt
				updatedAt
				__typename
			}
			nextToken
			__typename
		}
	}
`;
exports.listMessageEventByChatId = /* GraphQL */ `
	query ListMessageEventByChatId(
		$chatId: ID!
		$createdAt: ModelStringKeyConditionInput
		$sortDirection: ModelSortDirection
		$filter: ModelMessageEventFilterInput
		$limit: Int
		$nextToken: String
	) {
		listMessageEventByChatId(chatId: $chatId, createdAt: $createdAt, sortDirection: $sortDirection, filter: $filter, limit: $limit, nextToken: $nextToken) {
			items {
				id
				owner
				messageId
				userId
				chatId
				chatUserId
				type
				body
				uploadId
				readAt
				createdAt
				updatedAt
				__typename
			}
			nextToken
			__typename
		}
	}
`;
exports.listMessageEventByChatUserId = /* GraphQL */ `
	query ListMessageEventByChatUserId(
		$chatUserId: ID!
		$createdAt: ModelStringKeyConditionInput
		$sortDirection: ModelSortDirection
		$filter: ModelMessageEventFilterInput
		$limit: Int
		$nextToken: String
	) {
		listMessageEventByChatUserId(
			chatUserId: $chatUserId
			createdAt: $createdAt
			sortDirection: $sortDirection
			filter: $filter
			limit: $limit
			nextToken: $nextToken
		) {
			items {
				id
				owner
				messageId
				userId
				chatId
				chatUserId
				type
				body
				uploadId
				readAt
				createdAt
				updatedAt
				__typename
			}
			nextToken
			__typename
		}
	}
`;
