const joi = require('joi');

const validateFormData = (schema) => {
	return (req, res, next) => {
		const { error } = schema.validate(req.body);
		if (error) {
			return res.status(422).json(error);
		} else {
			// Validation succeeded, so we move on to the next middleware
			next();
		}
	};
};

const IIds = joi.object({ ids: joi.array().items(joi.string().max(100)).min(1).max(200) }).options({ abortEarly: false });

const IAvatar = joi
	.object({
		key: joi.string().max(200).required(),
	})
	.options({ abortEarly: false });

const IUser = joi
	.object({
		email: joi.string().email().required(),
		isEnabled: joi.bool().default(true),
		givenName: joi.string().max(100).required(),
		familyName: joi.string().max(100).required(),
	})
	.options({ abortEarly: false });

const IMessage = joi
	.object({
		body: joi.string().max(40000).required(),
		isSilent: joi.bool().optional().default(false),
		type: joi.string().optional().valid('image', 'video', 'audio', 'document', 'link', 'file', 'other'),
		fileKey: joi.string().optional().max(1000),
		fileSize: joi.number().optional().min(1),
		fileMime: joi.string().when('fileSize', {
			is: joi.exist(),
			then: joi.string().required().max(100),
			otherwise: joi.string().optional().max(100),
		}),
		isUploaded: joi.bool().optional(),
	})
	.options({ abortEarly: false });

const IConnection = joi
	.object({
		memberId: joi.string().max(100).required(),
		isSilent: joi.bool().optional().default(false),
	})
	.options({ abortEarly: false });

const IConnectionMessage = joi
	.object({
		body: joi.string().min(1).max(40000).required(),
		isSilent: joi.bool().optional().default(false),
		type: joi.string().optional().valid('image', 'video', 'audio', 'document', 'link', 'file', 'other'),
		fileKey: joi.string().optional().max(1000),
		fileSize: joi.number().optional().min(1),
		fileMime: joi.string().when('fileSize', {
			is: joi.exist(),
			then: joi.string().required().max(100),
			otherwise: joi.string().optional().max(100),
		}),
		isUploaded: joi.bool().optional(),
	})
	.options({ abortEarly: false });

module.exports = {
	validateFormData,
	IIds,
	IAvatar,
	IUser,
	IMessage,
	IConnection,
	IConnectionMessage,
};
