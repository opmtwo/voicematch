const { v4 } = require('uuid');
const { formatTimestamp } = require('./helper-utils');
const { ddbPut } = require('./ddb-utils');
const { idpGetUserAttribute } = require('./idp-utils');
const { API_UNFILTERED_LOGTABLE_NAME: LOGTABLE } = process.env;

/**
 * Log a CRUD activity with optional old and new values.
 *
 * @param {Object} user - Cognito user who performed the action.
 * @param {string} action - The CRUD action performed (create, read, update, delete).
 * @param {string} tableName - The name of the table or collection where the record was modified.
 * @param {number} recordId - The ID of the record that was modified.
 * @param {Object} oldValues - Optional dictionary of old values before the update.
 * @param {Object} newValues - Optional dictionary of new values after the update.
 * @param {boolean} verbose - Optional flag for verbose logging.
 * @returns {Object} params - The parameters of the logged activity.
 */
const logActivity = async (user, action, tableName, recordId, oldValues = null, newValues = null, verbose = true) => {
	if (verbose) {
		console.log(`logActivity - action=${action} tableName=${tableName} recordId=${recordId}`);
	}

	// Get the record's name or title, whichever is available
	let recordName;
	try {
		recordName = newValues?.name || newValues?.title || `Record ${recordId}`;
	} catch (err) {
		if (verbose) {
			console.log(`Error retrieving record name for recordId=${recordId} from tableName=${tableName}: ${err}`);
		}
		recordName = `Record ${recordId}`;
	}

	// Create log message - a basic summary of what happened
	let logMessage;
	if (action === 'create') {
		logMessage = `${recordName} created in ${tableName}`;
	} else if (action === 'read') {
		logMessage = `${recordName} read from ${tableName}`;
	} else if (action === 'update') {
		if (oldValues && newValues) {
			const changes = [];
			for (const [key, value] of Object.entries(newValues)) {
				if (oldValues[key] !== value) {
					changes.push(`${key}: ${oldValues[key]} -> ${value}`);
				}
			}
			logMessage = `${recordName} updated in ${tableName}. Changes: ${changes.join(', ')}`;
		} else {
			logMessage = `${recordName} updated in ${tableName}`;
		}
	} else if (action === 'delete') {
		logMessage = `${recordName} deleted from ${tableName}`;
	} else {
		logMessage = `${recordName} ${action} in ${tableName}`;
	}
	if (verbose) {
		console.log(`logActivity - logMessage=${logMessage}`);
	}

	// Basic user info
	const email = idpGetUserAttribute(user, 'email');
	const name = idpGetUserAttribute(user, 'name', email);

	// datetime of event
	const now = new Date().toISOString();
	const nowHuman = formatTimestamp(now, '%b %d, %y at %I:%M%p', true);

	// prepare params
	const params = {
		id: v4(),
		userId: user.Username,
		modelId: recordId,
		modelType: tableName,
		action,
		title: logMessage,
		description: `${logMessage} at ${nowHuman} by ${name}`,
		createdAt: now,
		updatedAt: now,
	};
	if (verbose) {
		console.log(`logActivity - params=${JSON.stringify(params)}`);
	}

	// add log and return data
	ddbPut(LOGTABLE, params);
	if (verbose) {
		console.log(`logActivity - ${action} activity logged`);
	}

	return params;
};

module.exports = {
	logActivity,
};
