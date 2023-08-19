import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:localstorage/localstorage.dart';
import 'package:voicevibe/constants/env.dart';

class PushNotificationService {
  final FirebaseMessaging _fcm;

  // local storage - used to store badge counter
  final storage = LocalStorage('voicevibe.json');

  // currrent settings - can be used to access permissions and other information
  NotificationSettings? notificationSettings;

  PushNotificationService(this._fcm);

  // NotificationSettings settings = await messaging.getNotificationSettings();

  Future<void> saveFirebaseToken(String token) async {
    try {
      // get access token
      final authSession = await Amplify.Auth.fetchAuthSession(
        options: CognitoSessionOptions(getAWSCredentials: true),
      ) as CognitoAuthSession;
      final accessToken = authSession.userPoolTokens?.accessToken;

      // api url
      final url = Uri.parse('${apiEndPoint}api/v1/tokens');
      safePrint('saveFirebaseToken - url $url');

      // call api
      final res = await http.post(url,
          body: jsonEncode({
            'token': token,
          }),
          headers: {
            'Authorization': accessToken.toString(),
            'Content-Type': 'application/json',
          });
      safePrint('saveFirebaseToken - status code = ${res.statusCode}');
    } on ApiException catch (e) {
      safePrint('saveFirebaseToken - error: $e');
    } catch (err) {
      safePrint('saveFirebaseToken - error: $err');
    }
  }

  Future<void> onMessage(RemoteMessage message) async {
    safePrint('onMessage - message: $message');
    try {
      final int badgeCount = await storage.getItem('badgeCount') ?? 0;
      final int newBadgeCount = badgeCount + 1;
      await storage.setItem('badgeCount', newBadgeCount);
      // FlutterAppBadger.updateBadgeCount(newBadgeCount);
    } catch (e) {
      safePrint('onMessage - error - $e');
    }
  }

  Future<void> clearBadge() async {
    safePrint('clearBadge called');
    try {
      // FlutterAppBadger.removeBadge();
      await storage.setItem('badgeCount', 0);
    } catch (e) {
      safePrint('clearBadge - error - $e');
    }
  }

  Future init() async {
    safePrint('PushNotificationService - init');

    safePrint('Firebase init - clearBadge');
    clearBadge();

    if (Platform.isIOS) {
      //
    }

    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    notificationSettings = settings;

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      log('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      log('User granted provisional permission');
    } else {
      log('User declined or has not accepted permission');
    }

    // If you want to test the push notification locally,
    // you need to get the token and input to the Firebase console
    // https://console.firebase.google.com/project/YOUR_PROJECT_ID/notification/compose
    String? token = await _fcm.getToken();
    log("FirebaseMessaging token: $token");

    // save firebase token in user nickname
    if (token != null) {
      saveFirebaseToken(token);
    }

    // https://firebase.flutter.dev/docs/messaging/notifications
    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        safePrint('Received new notification ${message.notification?.title}');
        safePrint('Received new notification ${message.notification?.body}');
        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification?.android;

        // If `onMessage` is triggered with a notification, construct our own
        // local notification to show to users using the created channel.
        if (notification != null && android != null) {
          //
        }
      },
    );

    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      safePrint('onMessageOpenedApp - event - $event');
      clearBadge();
    });

    // FirebaseMessaging.onBackgroundMessage(onMessage);
  }
}
