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
			memberId
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
