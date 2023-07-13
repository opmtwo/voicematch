import 'dart:developer';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:voicematch/constants/env.dart';

class GetXRouteObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    // Execute your code here whenever a route is pushed
    log('Route changed to: ${route.settings.name}');
    logOnline();
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    // Execute your code here whenever a route is popped
    log('Route popped: ${route.settings.name}');
    logOnline();
  }

  Future<void> logOnline() async {
    try {
      final session = await Amplify.Auth.fetchAuthSession();
      final isSignedIn = session.isSignedIn;

      if (!isSignedIn) {
        log('logOnline - user not signed in - exit');
        return;
      }

      // get access token
      final result = await Amplify.Auth.fetchAuthSession(
        options: CognitoSessionOptions(getAWSCredentials: true),
      ) as CognitoAuthSession;
      final accessToken = result.userPoolTokens?.accessToken;

      // update profile via oboard api
      final url = Uri.parse('${apiEndPoint}api/v1/online');
      safePrint('onSubmit - url $url');
      final response = await http.post(url, headers: {
        'Authorization': accessToken.toString(),
      });
      safePrint('logOnline - status code = ${response.statusCode}');
    } catch (err) {
      log('logOnline - error - $err');
    }
  }
}
