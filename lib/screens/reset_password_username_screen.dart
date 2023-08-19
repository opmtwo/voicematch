import 'dart:async';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:localstorage/localstorage.dart';
import 'package:voicevibe/components/logo.dart';
import 'package:voicevibe/constants/colors.dart';
import 'package:voicevibe/constants/theme.dart';
import 'package:voicevibe/elements/div.dart';
import 'package:voicevibe/elements/p.dart';
import 'package:voicevibe/form/button.dart';
import 'package:voicevibe/form/input.dart';
import 'package:voicevibe/layouts/app_layout.dart';
import 'package:voicevibe/router.dart';
import 'package:voicevibe/utils/user_utils.dart';

class ResetPasswordUsernameScreen extends StatefulWidget {
  const ResetPasswordUsernameScreen({Key? key}) : super(key: key);

  @override
  State<ResetPasswordUsernameScreen> createState() =>
      ResetPasswordUsernameScreenState();
}

class ResetPasswordUsernameScreenState
    extends State<ResetPasswordUsernameScreen> {
  // username
  final TextEditingController usernameController = TextEditingController();
  String? usernameError;

  final TextEditingController passwordController = TextEditingController();
  String? passwordError;

  // remember?
  bool isRemember = false;

  // busy and erro
  bool? isBusy;
  String? error;

  // password input masked?
  bool isPasswordSecure = true;

  // local storage - used to store badge counter
  final storage = LocalStorage('voicevibe.json');

  @override
  initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    final session = await Amplify.Auth.fetchAuthSession();
    final isSignedIn = session.isSignedIn;

    // user must be a guest
    if (!isSignedIn) {
      return;
    }

    // user is already signed in - redirect to the home page
    await redirectUser();
  }

  // Validate form
  Future<bool> isFormValid() async {
    String? err = '';
    bool isValid = true;

    String username = usernameController.text;
    safePrint({username});
    err = isEmailValid(username) ? null : 'Invalid email address';
    setState(() => usernameError = err);
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
    String username = usernameController.text;

    // reset password
    try {
      await Amplify.Auth.resetPassword(username: usernameController.text);
      Get.toNamed(Routes.resetPasswordCode, parameters: {
        'type': 'email',
        'username': username,
        'email': username,
      });
    } on AuthException catch (err) {
      // something went wrong
      setState(() {
        error = err.message;
      });
    }

    // dismiss loader
    EasyLoading.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Container(
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
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
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
                              Input(
                                usernameController,
                                kt: TextInputType.emailAddress,
                                placeholder: '*Email',
                                bc: colorTransparent,
                                bw: 0,
                                bg: colorWhite,
                                fg: colorBlack,
                                error: usernameError,
                                errorFg: colorPrimary100,
                              ), //
                            ],
                            mb: gap,
                          ),
                        ],
                        pt: gapBottom,
                        ph: gap,
                      ),
                    ],
                  ),
                ),
                // bottom block
                Div(
                  [
                    Div(
                      [
                        Button(
                          'reset',
                          onPress: onSubmit,
                        ),
                      ],
                      mt: gap,
                      mb: gapTop,
                    ),
                    Div(
                      [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Get.toNamed(Routes.signIn);
                              },
                              child: const P(
                                'Sign in',
                                fg: colorWhite,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Get.toNamed(Routes.signUp);
                              },
                              child: P(
                                'Create account'.toUpperCase(),
                                fg: colorWhite,
                              ),
                            ),
                          ],
                        )
                      ],
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
      ),
    );
  }
}
