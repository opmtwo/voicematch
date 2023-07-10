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
import 'package:voicematch/form/checkbox.dart';
import 'package:voicematch/form/fab_button.dart';
import 'package:voicematch/form/input.dart';
import 'package:voicematch/form/progress_bar.dart';
import 'package:voicematch/form/select.dart';
import 'package:voicematch/icons/icon_down.dart';
import 'package:voicematch/layouts/app_layout.dart';
import 'package:voicematch/router.dart';

class SetupOtherScreen extends StatefulWidget {
  const SetupOtherScreen({Key? key}) : super(key: key);

  @override
  State<SetupOtherScreen> createState() => SetupOtherScreenState();
}

class SetupOtherScreenState extends State<SetupOtherScreen> {
  // age range
  final TextEditingController ageRangeController = TextEditingController();
  String? ageRangeError;

  // distance
  final TextEditingController distanceController = TextEditingController();
  String? distanceError;

  // locale
  final TextEditingController localeController = TextEditingController();
  String? localeError;

  List<String> locales = [];
  String? localesError;

  String? error;

  int ageRangeIndex = -1;
  int distanceIndex = -1;

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
      String ageRange = attributes
              .firstWhereOrNull((element) =>
                  element.userAttributeKey ==
                  const CognitoUserAttributeKey.custom('custom:age_range'))
              ?.value ??
          '';
      String distance = attributes
              .firstWhereOrNull((element) =>
                  element.userAttributeKey ==
                  const CognitoUserAttributeKey.custom('custom:distance'))
              ?.value ??
          '';
      String locale = attributes
              .firstWhereOrNull((element) =>
                  element.userAttributeKey == CognitoUserAttributeKey.locale)
              ?.value ??
          '';

      ageRangeIndex =
          ageGroupOptions.indexWhere((element) => element['id'] == ageRange);

      distanceIndex =
          distanceOptions.indexWhere((element) => element['id'] == distance);

      List<String> localeValues = [];
      safePrint('len locale ${locale.length}');
      try {
        localeValues =
            locale.isNotEmpty ? List<String>.from(jsonDecode(locale)) : [];
        safePrint('localeValues $localeValues');
      } catch (e) {
        safePrint(
            'Error parsing locale $locale - localeValues = $localeValues');
        localeValues = [];
      }

      setState(() {
        ageRangeIndex = ageRangeIndex;
        distanceIndex = distanceIndex;
        ageRangeController.text = ageGroupOptions.firstWhereOrNull(
                (element) => element['id'] == ageRange)?['name'] ??
            '';
        distanceController.text = distanceOptions.firstWhereOrNull(
                (element) => element['id'] == distance)?['name'] ??
            '';
        locales = localeValues;
        localeController.text = localeValues.join(', ');
        // localeController.text = distanceOptions.firstWhereOrNull(
        //         (element) => element['id'] == locale)?['name'] ??
        //     '';
      });

      safePrint('localeValues $localeValues, locale $locale');
      safePrint('ageRangeIndex $ageRangeIndex, distanceIndex $distanceIndex');
    } on AuthException catch (e) {
      safePrint('initUser- error - ${e.message}');
    }
    EasyLoading.dismiss();
  }

  Future<bool> isFormValid() async {
    String? err = '';
    bool isValid = true;

    err = ageRangeIndex < ageGroupOptions.toList().length
        ? null
        : 'Please select age range';
    setState(() => ageRangeError = err);
    isValid = err == null ? isValid : false;

    err = distanceIndex < distanceOptions.toList().length
        ? null
        : 'Please select age range';
    setState(() => distanceError = err);
    isValid = err == null ? isValid : false;

    err = localeController.text.isNotEmpty
        ? null
        : 'Please select one or more languages';
    setState(() => localeError = err);
    isValid = err == null ? isValid : false;

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
      await Amplify.Auth.updateUserAttributes(
        attributes: [
          AuthUserAttribute(
            userAttributeKey:
                const CognitoUserAttributeKey.custom('custom:age_range'),
            value: ageRangeController.text,
          ),
          AuthUserAttribute(
            userAttributeKey:
                const CognitoUserAttributeKey.custom('custom:distance'),
            value: distanceOptions[distanceIndex]['id'] ?? '',
          ),
          AuthUserAttribute(
            userAttributeKey: CognitoUserAttributeKey.locale,
            value: jsonEncode(locales),
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

      // all done
      Get.toNamed(Routes.setupInterests);
    } on AuthException catch (e) {
      safePrint('onSubmit - error ${e.message}');
      setState(() {
        error = e.message;
      });
    }
    EasyLoading.dismiss();
  }

  void onLocaleOpen() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: colorWhite,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, updateState) {
            return Container(
              height: MediaQuery.of(context).size.height *
                  0.66, // Adjust the height as needed
              child: SingleChildScrollView(
                child: ListBody(
                  children: [
                    Div(
                      List.generate(localeOptions.length, (index) {
                        String value = localeOptions[index];
                        bool isChecked = locales.contains(localeOptions[index]);

                        void onChange(bool isSelected) {
                          if (isSelected) {
                            locales.add(value);
                          } else {
                            locales.remove(value);
                          }
                          updateState(() {
                            locales = locales;
                            localeController.text = locales.join(', ');
                          });
                        }

                        return Div(
                          [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CheckBox(
                                  uncheckedBorderColor: colorBlack,
                                  checkColor: colorWhite,
                                  value: isChecked,
                                  onChanged: onChange,
                                ),
                                Div(
                                  [
                                    GestureDetector(
                                      onTap: () {
                                        onChange(!isChecked);
                                      },
                                      child: P(
                                        value.toUpperCase(),
                                        fg: colorBlack,
                                      ),
                                    ),
                                  ],
                                  ml: gap / 2,
                                )
                              ],
                            ),
                          ],
                          mh: gap,
                          mv: gap / 2,
                        );
                      }),
                      ph: gap,
                      pv: gapTop,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppLayout(
        Div(
          [
            const Div(
              [
                ProgressBar(value: 2 / 4),
              ],
              mv: gapTop,
            ),
            Div(
              [
                const Div(
                  [
                    Align(
                      alignment: Alignment.center,
                      child: Avatar(),
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
                        fw: FontWeight.w600,
                      ),
                    ],
                    mb: gap,
                  ),
                // Div(
                //   [
                //     Input(
                //       ageRangeController,
                //       placeholder: 'First Name',
                //       bc: colorOnSurfaceDisabled,
                //       bg: colorWhite,
                //       fg: colorBlack,
                //       error: ageRangeError,
                //     ), //
                //   ],
                //   mb: gap,
                // ),
                Div(
                  [
                    Stack(
                      children: [
                        Input(
                          ageRangeController,
                          placeholder: 'Age range',
                          bc: colorOnSurfaceDisabled,
                          fg: colorBlack,
                          error: ageRangeError,
                        ),
                        Positioned(
                          child: Opacity(
                            opacity: 0,
                            child: Select(
                              ageRangeController,
                              index: ageRangeIndex,
                              options: ageGroupOptions,
                              onChange: (int index) {
                                setState(() {
                                  ageRangeIndex = index;
                                });
                              },
                              error: distanceError,
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
                          distanceController,
                          placeholder: 'Distance',
                          bc: colorOnSurfaceDisabled,
                          fg: colorBlack,
                          error: distanceError,
                        ),
                        Positioned(
                          child: Opacity(
                            opacity: 0,
                            child: Select(
                              distanceController,
                              index: distanceIndex,
                              options: distanceOptions,
                              onChange: (int index) {
                                safePrint('distanceIndex $index');
                                setState(() {
                                  distanceIndex = index;
                                });
                              },
                              error: distanceError,
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
                    Stack(
                      children: [
                        Input(
                          localeController,
                          placeholder: 'Language',
                          bc: colorOnSurfaceDisabled,
                          fg: colorBlack,
                          error: localeError,
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          bottom: 0,
                          left: 0,
                          child: GestureDetector(
                            onTap: onLocaleOpen,
                            child: const Div([]),
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
                            onPress: onLocaleOpen,
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
