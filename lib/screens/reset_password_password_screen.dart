import 'dart:async';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:voicevibe/components/logo.dart';
import 'package:voicevibe/constants/colors.dart';
import 'package:voicevibe/constants/theme.dart';
import 'package:voicevibe/elements/div.dart';
import 'package:voicevibe/elements/p.dart';
import 'package:voicevibe/form/button.dart';
import 'package:voicevibe/form/fab_button.dart';
import 'package:voicevibe/form/input.dart';
import 'package:voicevibe/icons/icon_eye_close.dart';
import 'package:voicevibe/icons/icon_eye_open.dart';
import 'package:voicevibe/layouts/app_layout.dart';
import 'package:voicevibe/router.dart';
import 'package:voicevibe/utils/user_utils.dart';

class ResetPasswordPasswordScreen extends StatefulWidget {
  const ResetPasswordPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ResetPasswordPasswordScreen> createState() =>
      ResetPasswordPasswordScreenState();
}

class ResetPasswordPasswordScreenState
    extends State<ResetPasswordPasswordScreen> {
  // password
  final TextEditingController passwordController = TextEditingController();
  String? passwordError;

  // confirmation
  final TextEditingController confirmationController = TextEditingController();
  String? confirmationError;

  // busy and erro
  bool? isBusy;
  String? error;

  // password input masked?
  bool isPasswordSecure = true;

  // confirmation input masked?
  bool isConfirmationSecure = true;

  // current password
  late String oldPassword;

  @override
  initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    final session = await Amplify.Auth.fetchAuthSession();
    final isSignedIn = session.isSignedIn;

    // user must be signed in to access this screen
    if (!isSignedIn) {
      Get.toNamed(Routes.signIn);
      return;
    }

    // password must be provided via parameters
    setState(() {
      oldPassword = Get.parameters['password'] as String;
    });
    safePrint('oldPassword - $oldPassword');
  }

  // Validate form
  Future<bool> isFormValid() async {
    String? err = '';
    bool isValid = true;

    String password = passwordController.text;
    safePrint({password});
    err = isPasswordValid(password)
        ? null
        : 'Password must be at least 8 characters long, contain one lowercase letter, one uppercase letter, one digit, and no spaces';
    setState(() => passwordError = err);
    isValid = err == null ? isValid : false;

    String confirmation = confirmationController.text;
    safePrint({confirmation});
    err = confirmation == password
        ? null
        : 'Password confirmation does not match';
    setState(() => confirmationError = err);
    isValid = err == null ? isValid : false;

    return isValid;
  }

  Future<void> onSubmit() async {
    EasyLoading.show(status: 'Loading');

    // validate form
    bool isValid = await isFormValid();
    if (!isValid) {
      safePrint('Form validation failed');
      EasyLoading.dismiss();
      return;
    }

    // get form data
    // String username = usernameController.text;
    String password = passwordController.text;

    // try and sign in
    try {
      await Amplify.Auth.updatePassword(
        oldPassword: oldPassword,
        newPassword: password,
      );

      // clear history and navigate
      await redirectUser();
    } on AuthException catch (e) {
      // something went wrong
      setState(() {
        error = e.message;
      });
    }

    // dismiss loader
    EasyLoading.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/splash.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: AppLayout(
          isGuestOnly: true,
          bg: colorTransparent,
          Div(
            [
              // auto expanding top block
              const Expanded(
                child: Div(
                  [
                    //
                  ],
                ),
              ),
              // bottom block
              Div(
                [
                  const Div(
                    [
                      Div(
                        [
                          Logo(),
                        ],
                        mb: gapTop,
                      ),
                    ],
                  ),
                  if (error != null)
                    Div(
                      [
                        P(
                          error,
                          isBody1: true,
                          fg: colorPrimary050,
                          fw: FontWeight.w600,
                        ),
                      ],
                      mb: gap,
                    ),
                  Div(
                    [
                      Stack(
                        children: [
                          Input(
                            passwordController,
                            placeholder: '*Password',
                            bw: 0,
                            bg: colorWhite,
                            fg: colorBlack,
                            isPassword: isPasswordSecure,
                            error: passwordError,
                            errorFg: colorPrimary100,
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: FabButton(
                              SvgPicture.string(
                                isPasswordSecure
                                    ? iconEyeClose()
                                    : iconEyeOpen(),
                                // width: 500,
                                height: 24,
                              ),
                              bg: colorTransparent,
                              onPress: () {
                                setState(() {
                                  isPasswordSecure = !isPasswordSecure;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                    mb: gap,
                  ),
                  Div(
                    [
                      Stack(
                        children: [
                          Input(
                            confirmationController,
                            placeholder: '*Confirm Password',
                            bw: 0,
                            bg: colorWhite,
                            fg: colorBlack,
                            isPassword: isConfirmationSecure,
                            error: confirmationError,
                            errorFg: colorPrimary100,
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: FabButton(
                              SvgPicture.string(
                                isConfirmationSecure
                                    ? iconEyeClose()
                                    : iconEyeOpen(),
                                // width: 500,
                                height: 24,
                              ),
                              bg: colorTransparent,
                              onPress: () {
                                setState(() {
                                  isConfirmationSecure = !isConfirmationSecure;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                    mb: gap,
                  ),
                  Div(
                    [
                      Button(
                        'change password & conti',
                        onPress: onSubmit,
                      ),
                    ],
                    mt: gap,
                    mb: gapTop,
                  ),
                ],
                pv: gapBottom,
                ph: gap,
                brTl: radiusLarge,
                brTr: radiusLarge,
                // bg: colorWhite,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
