import 'dart:convert';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/route_manager.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:voicematch/components/avatar.dart';
import 'package:voicematch/constants/colors.dart';
import 'package:voicematch/constants/env.dart';
import 'package:voicematch/constants/options.dart';
import 'package:voicematch/constants/theme.dart';
import 'package:voicematch/elements/div.dart';
import 'package:voicematch/elements/p.dart';
import 'package:voicematch/form/button.dart';
import 'package:voicematch/form/fab_button.dart';
import 'package:voicematch/form/input.dart';
import 'package:voicematch/form/progress_bar.dart';
import 'package:voicematch/form/select.dart';
import 'package:voicematch/icons/icon_down.dart';
import 'package:voicematch/layouts/app_layout.dart';
import 'package:voicematch/router.dart';

class SetupIntroScreen extends StatefulWidget {
  const SetupIntroScreen({Key? key}) : super(key: key);

  @override
  State<SetupIntroScreen> createState() => SetupIntroScreenState();
}

class SetupIntroScreenState extends State<SetupIntroScreen> {
  // username
  final TextEditingController givenNameController = TextEditingController();
  String? givenNameError;

  final TextEditingController genderController = TextEditingController();
  String? genderError;

  final TextEditingController targetGenderController = TextEditingController();
  String? targetGenderError;

  bool isRemember = false;

  String? error;

  int genderIndex = -1;
  int targetGenderIndex = -1;

  @override
  void initState() {
    super.initState();
    initUser();
  }

  Future<void> initUser() async {
    EasyLoading.show(status: 'loading...');
    try {
      List<AuthUserAttribute> attributes =
          await Amplify.Auth.fetchUserAttributes();
      String givenName = attributes
              .firstWhereOrNull((element) =>
                  element.userAttributeKey == CognitoUserAttributeKey.givenName)
              ?.value ??
          '';
      String gender = attributes
              .firstWhereOrNull((element) =>
                  element.userAttributeKey == CognitoUserAttributeKey.gender)
              ?.value ??
          '';
      String targetGender = attributes
              .firstWhereOrNull((element) =>
                  element.userAttributeKey ==
                  const CognitoUserAttributeKey.custom('custom:target_gender'))
              ?.value ??
          '';

      genderIndex =
          genderOptions.indexWhere((element) => element['id'] == gender);

      targetGenderIndex =
          genderOptions.indexWhere((element) => element['id'] == targetGender);

      setState(() {
        givenNameController.text = givenName;
        genderIndex = genderIndex;
        targetGenderIndex = targetGenderIndex;
        genderController.text = genderOptions.firstWhereOrNull(
                (element) => element['id'] == gender)?['name'] ??
            '';
        targetGenderController.text = genderOptions.firstWhereOrNull(
                (element) => element['id'] == targetGender)?['name'] ??
            '';
      });

      // safePrint('gender $gender, targetGender $targetGender');
      // safePrint(
      //     'genderIndex $genderIndex, targetGenderIndex $targetGenderIndex');
    } on AuthException catch (e) {
      safePrint('initUser- error - ${e.message}');
    }
    EasyLoading.dismiss();
  }

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

    error = [0, 1].contains(genderIndex) ? null : 'Please select your gender';
    setState(() => genderError = error);
    isValid = error == null ? isValid : false;

    error = [0, 1].contains(targetGenderIndex)
        ? null
        : 'Please select interested gender';
    setState(() => targetGenderError = error);
    isValid = error == null ? isValid : false;

    return isValid;
  }

  void onBack() {
    Navigator.pop(context);
  }

  Future<void> onSubmit() async {
    if (await isFormValid() != true) {
      return;
    }
    EasyLoading.show(status: 'loading...');
    try {
      // update user attributes
      await Amplify.Auth.updateUserAttributes(
        attributes: [
          AuthUserAttribute(
            userAttributeKey: CognitoUserAttributeKey.givenName,
            value: givenNameController.text,
          ),
          AuthUserAttribute(
            userAttributeKey: CognitoUserAttributeKey.gender,
            value: genderOptions[genderIndex]['id'] ?? '',
          ),
          AuthUserAttribute(
            userAttributeKey:
                const CognitoUserAttributeKey.custom('custom:target_gender'),
            value: genderOptions[targetGenderIndex]['id'] ?? '',
          ),
        ],
      );

      // get access token
      final result = await Amplify.Auth.fetchAuthSession(
        options: CognitoSessionOptions(getAWSCredentials: true),
      ) as CognitoAuthSession;
      final accessToken = result.userPoolTokens?.accessToken;

      // update profile via oboard api
      final url = Uri.parse('${apiEndPoint}api/v1/onboard');
      safePrint('onSubmit - url $url');
      final response = await http.post(url, body: jsonEncode({}), headers: {
        'Authorization': accessToken.toString(),
      });
      safePrint('onSubmit - status code = ${response.statusCode}');

      Get.toNamed(Routes.setupOther);
    } on AuthException catch (e) {
      safePrint('onSubmit - error ${e.message}');
      setState(() {
        error = e.message;
      });
    }
    EasyLoading.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppLayout(
        Div(
          [
            const Div(
              [
                ProgressBar(value: 1 / 5),
              ],
              mv: gapTop,
            ),
            Div(
              [
                const Div(
                  [
                    Align(
                      alignment: Alignment.center,
                      child: Avatar(
                        w: 160,
                        h: 160,
                      ),
                    )
                  ],
                  mb: gapTop,
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
                      placeholder: 'First Name',
                      bc: colorOnSurfaceDisabled,
                      bg: colorWhite,
                      fg: colorBlack,
                      error: givenNameError,
                    ), //
                  ],
                  mb: gap,
                ),
                Div(
                  [
                    Stack(
                      children: [
                        Input(
                          genderController,
                          placeholder: 'Gender',
                          bc: colorOnSurfaceDisabled,
                          fg: colorBlack,
                          error: genderError,
                        ),
                        Positioned(
                          child: Opacity(
                            opacity: 0,
                            child: Select(
                              genderController,
                              index: genderIndex,
                              options: genderOptions,
                              onChange: (int index) {
                                safePrint('genderIndex $index');
                                setState(() {
                                  genderIndex = index;
                                });
                              },
                              error: genderError,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: FabButton(
                            bg: colorTransparent,
                            SvgPicture.string(
                              iconDown(),
                              height: 20,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                  mb: gap,
                ),
                Div(
                  [
                    Stack(
                      children: [
                        Input(
                          targetGenderController,
                          placeholder: 'I am looking for',
                          bc: colorOnSurfaceDisabled,
                          fg: colorBlack,
                          error: targetGenderError,
                        ),
                        Positioned(
                          child: Opacity(
                            opacity: 0,
                            child: Select(
                              targetGenderController,
                              index: targetGenderIndex,
                              options: genderOptions,
                              onChange: (int index) {
                                safePrint('genderIndex $index');
                                setState(() {
                                  targetGenderIndex = index;
                                });
                              },
                              error: targetGenderError,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: FabButton(
                            bg: colorTransparent,
                            SvgPicture.string(
                              iconDown(),
                              height: 20,
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                  mb: gap,
                ),
                Div(
                  [
                    Button(
                      'next',
                      onPress: onSubmit,
                    ),
                  ],
                  mt: gap,
                  mb: gapTop,
                ),
              ],
              ph: gap,
            )
          ],
        ),
      ),
    );
  }
}
