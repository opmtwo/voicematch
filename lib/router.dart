import 'package:get/route_manager.dart';
// import 'package:voicevibe/screens/home_screen.dart';
import 'package:voicevibe/screens/intro_screen.dart';
import 'package:voicevibe/screens/matches_chat_screen.dart';
import 'package:voicevibe/screens/matches_index_screen.dart';
import 'package:voicevibe/screens/matches_match_screen.dart';
import 'package:voicevibe/screens/matches_preview_screen.dart';
import 'package:voicevibe/screens/profile_screen.dart';
import 'package:voicevibe/screens/reset_password_code_screen.dart';
import 'package:voicevibe/screens/reset_password_password_screen.dart';
import 'package:voicevibe/screens/reset_password_username_screen.dart';
import 'package:voicevibe/screens/setup_done_screen.dart';
import 'package:voicevibe/screens/setup_interests_screen.dart';
import 'package:voicevibe/screens/setup_intro_screen.dart';
import 'package:voicevibe/screens/setup_other_screen.dart';
import 'package:voicevibe/screens/setup_record_screen.dart';
import 'package:voicevibe/screens/sign_in_screen.dart';
import 'package:voicevibe/screens/sign_out_screen.dart';
import 'package:voicevibe/screens/sign_up_otp_screen.dart';
import 'package:voicevibe/screens/sign_up_screen.dart';
import 'package:voicevibe/screens/welcome_screen.dart';

abstract class Routes {
  static const welcome = '/welcome';
  static const intro = '/intro';

  static const signIn = '/sign-in';
  static const signInOtp = '/sign-in/otp';

  static const signUp = '/sign-up';
  static const signUpOtp = '/sign-up/otp';

  static const resetPasswordUsername = '/reset-password/username';
  static const resetPasswordCode = '/reset-password/code';
  static const resetPasswordPassword = '/reset-password/password';

  static const signOut = '/sign-out';

  static const home = '/home';

  static const setupIntro = '/setup/intro';
  static const setupOther = '/setup/other';
  static const setupInterests = '/setup/interests';
  static const setupRecording = '/setup/recording';
  static const setupDone = '/setup/done';

  static const profile = '/profile';

  static const matchesIndex = '/matches';
  static const matchesPreview = '/matches/:id/preview';
  static const matchesView = '/matches/:id';
  static const matchesReveal = '/matches/:id/reveal';
  static const matchesMatch = '/matches/:id/match';
  static const matchesChat = '/matches/:id/chat';
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
    name: Routes.signUp,
    page: () => const SignUpScreen(),
  ),
  GetPage(
    name: Routes.signUpOtp,
    page: () => const SignUpOtpScreen(),
  ),
  GetPage(
    name: Routes.resetPasswordUsername,
    page: () => const ResetPasswordUsernameScreen(),
  ),
  GetPage(
    name: Routes.resetPasswordCode,
    page: () => const ResetPasswordCodeScreen(),
  ),
  GetPage(
    name: Routes.resetPasswordPassword,
    page: () => const ResetPasswordPasswordScreen(),
  ),
  GetPage(
    name: Routes.signOut,
    page: () => const SignOutScreen(),
  ),
  // GetPage(
  //   name: Routes.home,
  //   page: () => const HomeScreen(),
  // ),
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
  GetPage(
    name: Routes.setupRecording,
    page: () => const SetupRecordScreen(),
  ),
  GetPage(
    name: Routes.setupDone,
    page: () => const SetupDoneScreen(),
  ),
  GetPage(
    name: Routes.profile,
    page: () => const ProfileScreen(),
  ),
  GetPage(
    name: Routes.matchesIndex,
    page: () => const MatchesIndexScreen(),
  ),
  GetPage(
    name: Routes.matchesPreview,
    page: () => const MatchesPreviewScreen(),
    transition: Transition.cupertinoDialog,
    transitionDuration: const Duration(milliseconds: 500),
  ),
  GetPage(
    name: Routes.matchesMatch,
    page: () => const MatchesMatchScreen(),
  ),
  GetPage(
    name: Routes.matchesChat,
    page: () => const MatchesChatScreen(),
  ),
];
