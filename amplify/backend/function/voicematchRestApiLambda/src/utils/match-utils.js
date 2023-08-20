/**
 * @summary
 * Function to calculate the match percentage between two users
 *
 * @param {UserModel} user1
 * @param {UserModel} user2
 * @returns double - the match percentage between two users
 */
const calculateMatchPercentage = (user1, user2, verbose = true) => {
	if (verbose) {
		console.log('calculateMatchPercentage - input', JSON.stringify({ user1, user2 }, null, 2));
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

	let total = 0;
	let value = 0;

	for (let i = 0; i < matchingFields.length; i++) {
		const _field = matchingFields[i];

		// increment total
		total++;

		// age range
		if (_field === 'ageRange') {
			value++;
			continue;
		}

		if (Array.isArray(user1[_field]) && Array.isArray(user2[_field])) {
			// we need to subtract 1 - added above
			// also, we need to add the maximum number of values in either users
			// profile
			// e.g. the maximum number of languages in either users profile
			total = total - 1 + Math.max(user1[_field].length, user2[_field].length);

			// check if they have any common elements
			const commonElements = user1[_field].filter((element) => user2[_field].includes(element));

			// update value and continue
			value = value + commonElements.length;
			continue;
		}

		// any other matching field
		if (user1[_field] === user2[_field]) {
			value++;
		}
	}

	// Final match percentage considering both matched fields and matched languages
	const matchPercentage = (value / total) * 100;
	if (verbose) {
		console.log('calculateMatchPercentage', { value, total, matchPercentage });
	}

	// all done
	return matchPercentage;
};

module.exports = {
	calculateMatchPercentage,
};
