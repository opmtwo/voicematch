import 'dart:async';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:voicevibe/components/logo.dart';
import 'package:voicevibe/constants/colors.dart';
import 'package:voicevibe/constants/theme.dart';
import 'package:voicevibe/elements/div.dart';
import 'package:voicevibe/elements/p.dart';
import 'package:voicevibe/form/button.dart';
import 'package:voicevibe/form/checkbox.dart';
import 'package:voicevibe/form/fab_button.dart';
import 'package:voicevibe/form/input.dart';
import 'package:voicevibe/icons/icon_eye_close.dart';
import 'package:voicevibe/icons/icon_eye_open.dart';
import 'package:voicevibe/layouts/app_layout.dart';
import 'package:voicevibe/router.dart';
import 'package:voicevibe/utils/user_utils.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // first name
  final TextEditingController givenNameController = TextEditingController();
  String? givenNameError;

  // email
  final TextEditingController usernameController = TextEditingController();
  String? usernameError;

  // password
  final TextEditingController passwordController = TextEditingController();
  String? passwordError;

  // confirmation
  final TextEditingController confirmationController = TextEditingController();
  String? confirmationError;

  // remember password
  bool isRemember = false;

  // password input masked?
  bool isPasswordSecure = true;

  // confirmation input masked?
  bool isConfirmationSecure = true;

  // error message
  String? error;

  // Validate form
  Future<bool> isFormValid() async {
    String? err = '';
    bool isValid = true;

    String givenName = givenNameController.text;
    safePrint({givenName});
    err = givenName.trim().length > 2
        ? null
        : 'Name must contain at least 2 characters';
    setState(() => givenNameError = err);
    isValid = err == null ? isValid : false;

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

    String confirmation = confirmationController.text;
    safePrint({confirmation});
    err = confirmation == password
        ? null
        : 'Password confirmation does not match';
    setState(() => confirmationError = err);
    isValid = err == null ? isValid : false;

    return isValid;
  }

  Future<void> onContinue() async {
    EasyLoading.show(status: 'Loading');
    setState(() {
      error = null;
    });

    bool isValid = await isFormValid();
    if (!isValid) {
      safePrint('Form validation failed');
      EasyLoading.dismiss();
      return;
    }

    String username = usernameController.text;
    String password = passwordController.text;

    try {
      error = null;
      final result = await Amplify.Auth.signUp(
        username: usernameController.text,
        password: passwordController.text,
        options: CognitoSignUpOptions(userAttributes: {
          CognitoUserAttributeKey.phoneNumber: '',
          CognitoUserAttributeKey.email: username,
          CognitoUserAttributeKey.givenName: givenNameController.text,
        }),
      );

      // next step info
      safePrint(result.nextStep);
      safePrint(result.nextStep.signUpStep);

      // confirmation needed
      if (result.nextStep.signUpStep == 'CONFIRM_SIGN_UP_STEP') {
        Get.toNamed(Routes.signUpOtp, parameters: {
          'type': 'email',
          'email': username,
          'username': username,
          'password': password,
        });
        EasyLoading.dismiss();
        return;
      }

      // confirmation not needed - sign in
      await Amplify.Auth.signIn(username: username, password: password);

      // redirect to the home page
      await redirectUser();
    } on AuthException catch (e) {
      safePrint(e.recoverySuggestion);
      safePrint(e.underlyingException);

      // user already exists
      if (e.message.contains('already exists')) {
        //
      }

      // something went wrong
      safePrint('register - onContinue - error - ${e.message}');
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
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 9,
              sigmaY: 9,
            ),
            child: AppLayout(
              isGuestOnly: true,
              bg: colorTransparent,
              Div(
                [
                  // auto expanding top block
                  Expanded(
                    child: Div(
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
                              givenNameController,
                              placeholder: '*First Name',
                              bc: colorTransparent,
                              bw: 0,
                              bg: colorWhite,
                              fg: colorBlack,
                              error: givenNameError,
                              errorFg: colorPrimary100,
                            ), //
                          ],
                          mb: gap,
                        ),
                        Div(
                          [
                            Input(
                              usernameController,
                              kt: TextInputType.emailAddress,
                              placeholder: '*Email Address',
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
                        Div(
                          [
                            Stack(
                              children: [
                                Input(
                                  passwordController,
                                  kt: TextInputType.visiblePassword,
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
                                  kt: TextInputType.visiblePassword,
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
                                        isConfirmationSecure =
                                            !isConfirmationSecure;
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
                        ),
                      ],
                      pt: gapTop,
                      ph: gap,
                    ),
                  ),
                  // bottom block
                  Div(
                    [
                      Div(
                        [
                          Button(
                            'Next',
                            onPress: onContinue,
                          ),
                        ],
                        mv: gapBottom,
                      ),
                      Div(
                        [
                          GestureDetector(
                            onTap: () {
                              Get.toNamed(Routes.signIn);
                            },
                            child: P(
                              'I have account! Sign In'.toUpperCase(),
                              fg: colorWhite,
                            ),
                          ),
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
      ),
    );
  }
}
