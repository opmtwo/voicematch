import 'package:get/route_manager.dart';
import 'package:voicematch/screens/home_screen.dart';
import 'package:voicematch/screens/intro_screen.dart';
import 'package:voicematch/screens/setup_interests_screen.dart';
import 'package:voicematch/screens/setup_intro_screen.dart';
import 'package:voicematch/screens/setup_other_screen.dart';
import 'package:voicematch/screens/sign_in_otp_screen.dart';
import 'package:voicematch/screens/sign_in_screen.dart';
import 'package:voicematch/screens/sign_up_otp_screen.dart';
import 'package:voicematch/screens/sign_up_screen.dart';
import 'package:voicematch/screens/welcome_screen.dart';

abstract class Routes {
  static const welcome = '/welcome';
  static const intro = '/intro';

  static const signIn = '/sign-in';
  static const signInOtp = '/sign-in/otp';

  static const signUp = '/sign-up';
  static const signUpOtp = '/sign-up/otp';

  static const home = '/home';

  static const setupIntro = '/setup/intro';
  static const setupOther = '/setup/other';
  static const setupInterests = '/setup/interests';
}

final appPages = [
  GetPage(
    name: Routes.welcome,
    page: () => const WelcomeScreen(),
  ),
  GetPage(
    name: Routes.intro,
    page: () => const IntroScreen(),
  ),
  GetPage(
    name: Routes.signIn,
    page: () => const SignInScreen(),
  ),
  GetPage(
    name: Routes.signInOtp,
    page: () => const SignInOtpScreen(),
  ),
  GetPage(
    name: Routes.signUp,
    page: () => const SignUpScreen(),
  ),
  GetPage(
    name: Routes.signUpOtp,
    page: () => const SignUpOtpScreen(),
  ),
  GetPage(
    name: Routes.home,
    page: () => const HomeScreen(),
  ),
  GetPage(
    name: Routes.setupIntro,
    page: () => const SetupIntroScreen(),
  ),
  GetPage(
    name: Routes.setupOther,
    page: () => const SetupOtherScreen(),
  ),
  GetPage(
    name: Routes.setupInterests,
    page: () => const SetupInterestsScreen(),
  ),
];
