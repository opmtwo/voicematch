import 'dart:async';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:voicematch/components/app_links.dart';
import 'package:voicematch/components/logo.dart';
import 'package:voicematch/constants/colors.dart';
import 'package:voicematch/constants/theme.dart';
import 'package:voicematch/elements/div.dart';
import 'package:voicematch/elements/p.dart';
import 'package:voicematch/form/button.dart';
import 'package:voicematch/form/checkbox.dart';
import 'package:voicematch/form/input.dart';
import 'package:voicematch/layouts/app_layout.dart';
import 'package:voicematch/router.dart';
import 'package:voicematch/utils/user_utils.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => SignInScreenState();
}

class SignInScreenState extends State<SignInScreen> {
  // username
  final TextEditingController usernameController = TextEditingController();
  String? usernameError;

  final TextEditingController passwordController = TextEditingController();
  String? passwordError;

  bool isRemember = false;

  String? error;

  // Validate form
  Future<bool> isFormValid() async {
    String? err = '';
    bool isValid = true;

    String username = usernameController.text;
    safePrint({username});
    err = isEmailValid(username) ? null : 'Invalid email address';
    setState(() => usernameError = err);
    isValid = err == null ? isValid : false;

    String password = passwordController.text;
    safePrint({password});
    err = isPasswordValid(password)
        ? null
        : 'Password must be at least 8 characters long, contain one lowercase letter, one uppercase letter, one digit, and no spaces';
    setState(() => passwordError = err);
    isValid = err == null ? isValid : false;

    return isValid;
  }

  Future<void> onSubmit() async {
    EasyLoading.show(status: 'Loading');

    bool isValid = await isFormValid();
    if (!isValid) {
      safePrint('Form validation failed');
      EasyLoading.dismiss();
      return;
    }

    String username = usernameController.text;
    String password = passwordController.text;

    try {
      final session = await Amplify.Auth.fetchAuthSession();
      final isSignedIn = session.isSignedIn;
      if (!isSignedIn) {
        await Amplify.Auth.signIn(
          username: username,
          password: password,
        );
      }
      Get.toNamed(Routes.home);
    } on AuthException catch (e) {
      if (e.message.contains('not confirmed') ||
          e.message.contains('no registered')) {
        await Amplify.Auth.resendSignUpCode(username: usernameController.text);
        Get.toNamed(Routes.signUpOtp, arguments: {
          'type': 'email',
          'username': username,
          'email': username,
          'password': password,
        });
      } else {
        setState(() {
          error = e.message;
        });
      }
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
                      Input(
                        usernameController,
                        placeholder: '*Email',
                        bc: colorTransparent,
                        bw: 0,
                        bg: colorWhite,
                        fg: colorBlack,
                      ), //
                    ],
                    mb: gap,
                  ),
                  Div(
                    [
                      Input(
                        passwordController,
                        placeholder: '*Password',
                        bw: 0,
                        bg: colorWhite,
                        fg: colorBlack,
                      ), //
                    ],
                    mb: gap,
                  ),
                  Div(
                    [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CheckBox(
                            value: isRemember,
                            onChanged: (value) {
                              setState(() {
                                isRemember = value;
                              });
                            },
                          ),
                          Div(
                            [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isRemember = !isRemember;
                                  });
                                },
                                child: P(
                                  'Remember me'.toUpperCase(),
                                  fg: colorWhite,
                                ),
                              ),
                            ],
                            ml: gap / 2,
                          )
                        ],
                      ),
                    ],
                    mb: gap,
                  ),
                  Div(
                    [
                      Button(
                        'sign in',
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
                              //
                            },
                            child: const P(
                              'Forget Password?',
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
                    mb: gap,
                  ),
                  const Div(
                    [
                      AppLinks(),
                    ],
                    mt: gap / 2,
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
