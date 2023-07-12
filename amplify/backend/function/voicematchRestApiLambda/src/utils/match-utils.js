/**
 * @summary
 * Function to calculate the match percentage between two users
 *
 * @param {UserModel} user1
 * @param {UserModel} user2
 * @returns double - the match percentage between two users
 */
const calculateMatchPercentage = (user1, user2) => {
	const matchingFields = [
		'gender',
		'lookingFor',
		'ageRange',
		'distance',
		'locale',
		'interestCreativity',
		'interestSports',
		'interestVideo',
		'interestMusic',
		'interestTravelling',
		'interestPet',
	];

	let matchCount = 0;

	matchingFields.forEach((field) => {
		if (Array.isArray(user1[field]) && Array.isArray(user2[field])) {
			// If both fields are arrays, check if they have any common elements
			const commonElements = user1[field].filter((element) => user2[field].includes(element));
			if (commonElements.length > 0) {
				matchCount++;
			}
		} else if (user1[field] === user2[field]) {
			// If both fields are single values, check if they match
			matchCount++;
		}
	});

	// Calculate the match percentage based on the number of matching fields
	const matchPercentage = (matchCount / matchingFields.length) * 100;

	// 
	return matchPercentage;
};

module.exports = {
	calculateMatchPercentage,
};
