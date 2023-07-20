import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:voicematch/components/logo.dart';
import 'package:voicematch/constants/colors.dart';
import 'package:voicematch/constants/theme.dart';
import 'package:voicematch/elements/div.dart';
import 'package:voicematch/elements/p.dart';
import 'package:voicematch/layouts/app_layout.dart';
import 'package:voicematch/router.dart';
import 'package:voicematch/utils/user_utils.dart';

class ResetPasswordCodeScreen extends StatefulWidget {
  const ResetPasswordCodeScreen({Key? key}) : super(key: key);

  @override
  State<ResetPasswordCodeScreen> createState() =>
      ResetPasswordCodeScreenState();
}

class ResetPasswordCodeScreenState extends State<ResetPasswordCodeScreen> {
  bool isResent = false;

  late String email;
  late String phone;
  late String username;

  String? error;

  final TextEditingController codeController = TextEditingController();
  String? codeError;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    final session = await Amplify.Auth.fetchAuthSession();
    final isSignedIn = session.isSignedIn;

    // user is already signed in - redirect to the home page
    if (isSignedIn) {
      await redirectUser();
      return;
    }

    setState(() {
      email = Get.parameters['email'] ?? '';
      phone = Get.parameters['phone'] ?? '';
      username = Get.parameters['username'] ?? '';
    });
    safePrint('$email, $phone, $username');
  }

  Future<bool> isFormValid() async {
    String? error = '';
    bool isValid = true;

    error = codeController.text.trim().length == 6 ? null : 'Invalid code';
    setState(() => codeError = error);
    isValid = error == null ? isValid : false;

    return isValid;
  }

  Future<void> onSubmit() async {
    EasyLoading.show(status: 'Loading');
    if (await isFormValid() != true) {
      return;
    }

    setState(() {
      error = null;
    });

    String code = codeController.text.trim();
    String password = UUID().toString().substring(0, 8);
    safePrint('password $password');

    try {
      await Amplify.Auth.confirmResetPassword(
        username: username,
        confirmationCode: code,
        newPassword: password,
      );
      await Amplify.Auth.signIn(username: email, password: password);
      Get.toNamed(
        Routes.resetPasswordPassword,
        parameters: {
          'password': password,
        },
      );
    } on AuthException catch (e) {
      safePrint('onSubmit error - ${e.message}, $email, $password');
      setState(() {
        error = e.message;
      });
    }

    // dismiss loader
    EasyLoading.dismiss();
  }

  Future<void> onResend() async {
    setState(() {
      error = null;
    });
    EasyLoading.show(status: 'Loading');
    try {
      await Amplify.Auth.resetPassword(username: username);
      setState(() {
        isResent = true;
      });
    } on AuthException catch (e) {
      safePrint(e.message);
      setState(() {
        error = e.message;
      });
    }
    EasyLoading.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
        fontSize: 20,
        color: Color.fromRGBO(30, 60, 87, 1),
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromRGBO(234, 239, 243, 1)),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: const Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: const Color.fromRGBO(234, 239, 243, 1),
      ),
    );

    return GestureDetector(
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
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Div(
                        [
                          const Div(
                            [
                              Logo(),
                            ],
                            mb: gapBottom,
                          ),
                          const Div(
                            [
                              P(
                                'Verification',
                                isH4: true,
                                fg: colorWhite,
                                fw: FontWeight.bold,
                              ),
                            ],
                            mb: gapBottom,
                          ),
                          Pinput(
                            length: 6,
                            defaultPinTheme: defaultPinTheme,
                            focusedPinTheme: focusedPinTheme,
                            submittedPinTheme: submittedPinTheme,
                            validator: (s) {
                              // return s == '2222' ? null : 'Pin is incorrect';
                              return null;
                            },
                            pinputAutovalidateMode:
                                PinputAutovalidateMode.onSubmit,
                            showCursor: true,
                            onChanged: (value) {
                              setState(() {
                                codeController.text = value;
                              });
                            },
                            onCompleted: (pin) {
                              safePrint(pin);
                              onSubmit();
                            },
                          ),
                          const Div(
                            [
                              P(
                                'Please enter the code that was sent to your number',
                                isBody1: true,
                                fg: colorWhite,
                                ta: TextAlign.center,
                              ),
                            ],
                            mt: gapBottom,
                            mb: gap,
                          ),
                          if (!isResent)
                            Div(
                              [
                                Align(
                                  alignment: Alignment.center,
                                  child: GestureDetector(
                                    onTap: onResend,
                                    child: const P(
                                      'Resend Code',
                                      isBody1: true,
                                      fg: colorWhite,
                                      fw: FontWeight.w600,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          if (isResent)
                            Div(
                              [
                                Align(
                                  alignment: Alignment.center,
                                  child: P(
                                    'Verification code was resent to your email\n$email',
                                    fg: colorWhite,
                                    ta: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          Div(
                            [
                              if (codeError != null)
                                P(
                                  error,
                                  fg: colorPrimary,
                                  isH4: true,
                                  ta: TextAlign.center,
                                )
                            ],
                          )
                        ],
                        ph: gap,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
