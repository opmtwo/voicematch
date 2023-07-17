/**
 * @summary
 * Function to calculate the match percentage between two users
 *
 * @param {UserModel} user1
 * @param {UserModel} user2
 * @returns double - the match percentage between two users
 */
const calculateMatchPercentage = (user1, user2) => {
	// const matchingFields = [
	// 	'gender',
	// 	'lookingFor',
	// 	'ageRange',
	// 	'distance',
	// 	'locale',
	// 	'interestCreativity',
	// 	'interestSports',
	// 	'interestVideo',
	// 	'interestMusic',
	// 	'interestTravelling',
	// 	'interestPet',
	// ];

	// let matchCount = 0;

	// matchingFields.forEach((field) => {
	// 	if (Array.isArray(user1[field]) && Array.isArray(user2[field])) {
	// 		// If both fields are arrays, check if they have any common elements
	// 		const commonElements = user1[field].filter((element) => user2[field].includes(element));
	// 		if (commonElements.length > 0) {
	// 			matchCount++;
	// 		}
	// 	} else if (user1[field] === user2[field]) {
	// 		// If both fields are single values, check if they match
	// 		matchCount++;
	// 	}
	// });

	// // Calculate the match percentage based on the number of matching fields
	// const matchPercentage = (matchCount / matchingFields.length) * 100;

	// //
	// return matchPercentage;

	// Check if ageRange does not match, then return 0 match percentage
	if (user1.ageRange !== user2.ageRange) {
		return 0;
	}

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
	let localeMatchLanguages = [];

	matchingFields.forEach((field) => {
		if (field === 'ageRange') {
			// Age Range Check - We've already handled this condition above.
		} else if (Array.isArray(user1[field]) && Array.isArray(user2[field])) {
			// If both fields are arrays, check if they have any common elements
			const commonElements = user1[field].filter((element) => user2[field].includes(element));
			if (commonElements.length > 0) {
				matchCount++;
				if (field === 'locale') {
					// Store the matched languages for the 'locale' field
					localeMatchLanguages = commonElements;
				}
			}
		} else if (user1[field] === user2[field]) {
			// If both fields are single values, check if they match
			matchCount++;
			if (field === 'locale') {
				// Store the matched language for the 'locale' field
				localeMatchLanguages = [user1[field]];
			}
		}
	});

	// Calculate the match percentage based on the number of matching fields and matched languages
	const languageMatchPercentage = (localeMatchLanguages.length / user1.locale.length) * 100;
	const overallMatchPercentage = (matchCount / (matchingFields.length - 1)) * 100;

	// Final match percentage considering both matched fields and matched languages
	const matchPercentage = (languageMatchPercentage + overallMatchPercentage) / 2;

	return matchPercentage;
};

module.exports = {
	calculateMatchPercentage,
};
