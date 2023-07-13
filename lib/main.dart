import 'dart:async';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:flutter/services.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:localstorage/localstorage.dart';
import 'package:voicematch/amplifyconfiguration.dart';
import 'package:voicematch/components/loader.dart';
import 'package:voicematch/constants/colors.dart';
import 'package:voicematch/observers/getx_route_observer.dart';
import 'package:voicematch/router.dart';
import 'package:voicematch/utils/user_utils.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // transparent status bar
      statusBarBrightness: Brightness.light, // dark status bar
      statusBarIconBrightness: Brightness.light, // dark text for status bar
    ),
  );
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const VoiceMatch());
}

class VoiceMatch extends StatefulWidget {
  const VoiceMatch({Key? key}) : super(key: key);

  @override
  State<VoiceMatch> createState() => _VoiceMatchState();
}

class _VoiceMatchState extends State<VoiceMatch> {
  // busy and error
  bool? isBusy;
  String? error;

  // logged in?
  bool isLoggedIn = false;

  // local storage - used to store badge counter
  final storage = LocalStorage('voicematch.json');

  // Initialize your custom RouteObserver
  final GetXRouteObserver routeObserver = GetXRouteObserver();

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    configLoading();
    await _configureAmplify();
    await _initAuth();
    // let amplify load before trying to init auth state
    // await Future.delayed(const Duration(milliseconds: 1500), _initAuth);
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

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'voicematchApp',
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
