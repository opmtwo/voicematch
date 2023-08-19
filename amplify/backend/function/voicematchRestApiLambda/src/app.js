/* Amplify Params - DO NOT EDIT
	API_VOICEMATCHGRAPHAPI_CONNECTIONTABLE_ARN
	API_VOICEMATCHGRAPHAPI_CONNECTIONTABLE_NAME
	API_VOICEMATCHGRAPHAPI_GRAPHQLAPIENDPOINTOUTPUT
	API_VOICEMATCHGRAPHAPI_GRAPHQLAPIIDOUTPUT
	API_VOICEMATCHGRAPHAPI_MESSAGEEVENTTABLE_ARN
	API_VOICEMATCHGRAPHAPI_MESSAGEEVENTTABLE_NAME
	API_VOICEMATCHGRAPHAPI_MESSAGETABLE_ARN
	API_VOICEMATCHGRAPHAPI_MESSAGETABLE_NAME
	API_VOICEMATCHGRAPHAPI_ONLINEPRESENCETABLE_ARN
	API_VOICEMATCHGRAPHAPI_ONLINEPRESENCETABLE_NAME
	API_VOICEMATCHGRAPHAPI_RECORDINGTABLE_ARN
	API_VOICEMATCHGRAPHAPI_RECORDINGTABLE_NAME
	API_VOICEMATCHGRAPHAPI_TOKENTABLE_ARN
	API_VOICEMATCHGRAPHAPI_TOKENTABLE_NAME
	API_VOICEMATCHGRAPHAPI_UPLOADTABLE_ARN
	API_VOICEMATCHGRAPHAPI_UPLOADTABLE_NAME
	API_VOICEMATCHGRAPHAPI_USERTABLE_ARN
	API_VOICEMATCHGRAPHAPI_USERTABLE_NAME
	AUTH_VOICEMATCHC92D7B64_USERPOOLID
	ENV
	REGION
	STORAGE_VOICEMATCHSTORAGE_BUCKETNAME
Amplify Params - DO NOT EDIT */ /*
Copyright 2017 - 2017 Amazon.com, Inc. or its affiliates. All Rights Reserved.
Licensed under the Apache License, Version 2.0 (the "License"). You may not use this file except in compliance with the License. A copy of the License is located at
		http://aws.amazon.com/apache2.0/
or in the "license" file accompanying this file. This file is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and limitations under the License.
*/

const express = require('express');
const bodyParser = require('body-parser');
const awsServerlessExpressMiddleware = require('aws-serverless-express/middleware');

// declare a new express app
const app = express();
app.use(bodyParser.json());
app.use(awsServerlessExpressMiddleware.eventContext());

// Enable CORS for all methods
app.use(function (req, res, next) {
	res.header('Access-Control-Allow-Origin', '*');
	res.header('Access-Control-Allow-Headers', '*');
	next();
});

app.listen(3000, function () {
	console.log('App started');
});

// Export the app object. When executing the application local this does nothing. However,
// to port it to AWS Lambda we will create a wrapper around that will load the app from
// this file
module.exports = app;
