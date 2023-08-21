import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:localstorage/localstorage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:voicevibe/amplifyconfiguration.dart';
import 'package:voicevibe/components/loader.dart';
import 'package:voicevibe/constants/colors.dart';
import 'package:voicevibe/firebase_options.dart';
import 'package:voicevibe/observers/getx_route_observer.dart';
import 'package:voicevibe/router.dart';
import 'package:voicevibe/services/lifecycle_service.dart';
import 'package:voicevibe/services/push_notification_service.dart';
import 'package:voicevibe/utils/user_utils.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // transparent status bar
      statusBarBrightness: Platform.isIOS == true
          ? Brightness.light
          : Brightness.dark, // dark status bar
      statusBarIconBrightness: Platform.isIOS == true
          ? Brightness.light
          : Brightness.dark, // dark text for status bar
    ),
  );
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const VoiceVibe());
}

class VoiceVibe extends StatefulWidget {
  const VoiceVibe({Key? key}) : super(key: key);

  @override
  State<VoiceVibe> createState() => _VoiceVibeState();
}

class _VoiceVibeState extends State<VoiceVibe> {
  // busy and error
  bool? isBusy;
  String? error;

  // logged in?
  bool isLoggedIn = false;

  // local storage - used to store badge counter
  final storage = LocalStorage('voicevibe.json');

  // Initialize your custom RouteObserver
  final GetXRouteObserver routeObserver = GetXRouteObserver();

// firebase messaging
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    configLoading();
    await _configureAmplify();
    await _initAuth();
    await _configureFirebase();
    // let amplify load before trying to init auth state
    // await Future.delayed(const Duration(milliseconds: 1500), _initAuth);
    await logoutIfNotRemember();
  }

  Future<void> _configureFirebase() async {
    var status = await Permission.notification.request();
    if (status.isGranted) {
      log('_configureFirebase - permissions have been granted');
      await PushNotificationService(firebaseMessaging).init();
    } else {
      log('_configureFirebase - permissions have been denied');
    }
  }

  void configLoading() {
    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 2000)
      ..indicatorType = EasyLoadingIndicatorType.fadingCircle
      ..loadingStyle = EasyLoadingStyle.custom
      ..maskType = EasyLoadingMaskType.custom
      ..textStyle = const TextStyle(fontSize: 0)
      ..indicatorSize = 64.0
      ..indicatorWidget = const Loader()
      ..radius = 16.0
      ..progressColor = colorPrimary
      ..backgroundColor = colorTransparent
      ..indicatorColor = colorTransparent
      ..textColor = colorPrimary
      ..maskColor = colorPrimary.withOpacity(0.15)
      ..userInteractions = true
      ..boxShadow = <BoxShadow>[]
      ..dismissOnTap = false
      ..customAnimation = null;
  }

  Future<void> _configureAmplify() async {
    try {
      // add auth
      final auth = AmplifyAuthCognito();
      // await Amplify.addPlugin(auth);

      // s3 storage
      final storage = AmplifyStorageS3();
      // await Amplify.addPlugin(storage);

      // add api
      // final api = AmplifyAPI(modelProvider: ModelProvider.instance);
      // await Amplify.addPlugin(api);

      // rest api
      final restApi = AmplifyAPI();
      // await Amplify.addPlugin(restApi);

      // load all plugins at once
      Future.wait(
        [
          Amplify.addPlugin(auth),
          Amplify.addPlugin(storage),
          Amplify.addPlugin(restApi)
        ],
      );

      // configure
      await Amplify.configure(amplifyconfig);
    } on Exception catch (e) {
      safePrint('An error occurred configuring Amplify: $e');
    }
  }

  Future<void> _initAuth() async {
    var isSignedIn = false;
    try {
      final session = await Amplify.Auth.fetchAuthSession();
      isSignedIn = session.isSignedIn;
      safePrint('main - isSignedIn = $isSignedIn');
    } on Exception catch (e) {
      safePrint('main - An error occurred configuring Amplify: $e');
      // AuthService().setIsLoggedIn(false);
    }
    setState(() {
      isBusy = false;
      isLoggedIn = isSignedIn;
    });
    if (isSignedIn == true) {
      await redirectUser();
    }
    // let the screen load in the background before removing the splash screen
    Future.delayed(const Duration(milliseconds: 500), () {
      FlutterNativeSplash.remove();
    });
  }

  Future<void> logoutIfNotRemember() async {
    final isRemember = storage.getItem('isRemember');
    safePrint('logoutIfNotRemember - isRemember = $isRemember');
    if (isRemember != 'yes') {
      safePrint('logoutIfNotRemember - remember me not set - logging out');
      await Amplify.Auth.signOut();
      await Get.toNamed(Routes.welcome);
    }
  }

  // clear notifications badge when app resumes
  Future<void> clearBadgeOnResume() async {
    WidgetsBinding.instance.addObserver(
      LifecycleEventService(
        resumeCallBack: () async {
          // log('clearBadgeOnResume - resumeCallBack invoked');
          final session = await Amplify.Auth.fetchAuthSession();
          var isSignedIn = session.isSignedIn;
          if (!isSignedIn) {
            // log('clearBadgeOnResume - user is not signed in - return');
            return;
          }
          // final List<AuthUserAttribute> userAttributes =
          //     await Amplify.Auth.fetchUserAttributes();
          // final profile = userAttributes
          //         .firstWhereOrNull((element) =>
          //             element.userAttributeKey ==
          //             CognitoUserAttributeKey.profile)
          //         ?.value ??
          //     '';
          // UserProfileModel? userProfile;
          // try {
          //   userProfile = UserProfileModel.fromJson(jsonDecode(profile));
          // } catch (e) {
          //   safePrint('clearBadgeOnResume - error - user profile not found');
          //   return;
          // }
          // if (userProfile.hasNotifications != true ||
          //     userProfile.hasPushNotifications != true) {
          //   safePrint(
          //       'clearBadgeOnResume - error - push notifications not enabled');
          //   return;
          // }

          // invoking clear badge needs notifications permission
          // if invoked during app startup without any check - causes permissions
          // popup to be shown
          final int badgeCount = await storage.getItem('badgeCount') ?? 0;
          if (badgeCount == 0) {
            return;
          }

          safePrint('clearBadge called');
          try {
            // FlutterAppBadger.removeBadge();
            await storage.setItem('badgeCount', 0);
          } catch (e) {
            safePrint('clearBadge - error - $e');
          }

          // when subscription is cancelled - the loader keeps showing - remove the loader here
          // EasyLoading.dismiss();
        },
      ),
    );
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'voicevibeApp',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
        fontFamily: 'Nunito',
        listTileTheme: const ListTileThemeData(
          contentPadding: EdgeInsets.zero,
          minVerticalPadding: 0,
          horizontalTitleGap: 0,
          minLeadingWidth: 0,
        ),
      ),
      getPages: appPages,
      initialRoute: Routes.welcome,
      builder: EasyLoading.init(),
      navigatorObservers: [routeObserver],
    );
  }
}
