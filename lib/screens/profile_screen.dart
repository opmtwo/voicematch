import 'dart:convert';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:voicematch/components/avatar.dart';
import 'package:voicematch/constants/colors.dart';
import 'package:voicematch/constants/theme.dart';
import 'package:voicematch/elements/div.dart';
import 'package:voicematch/elements/p.dart';
import 'package:voicematch/form/button.dart';
import 'package:voicematch/form/progress_bar.dart';
import 'package:voicematch/icons/icon_right.dart';
import 'package:voicematch/layouts/app_layout.dart';
import 'package:voicematch/router.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  // error and busy
  bool isBusy = false;
  String? error;

  // given name
  String givenName = '';

  // gender
  String gender = '';

  // target gender
  String targetGender = '';

  // age range
  String ageRange = '';

  // distance
  String distance = '';

  // locale / languages
  String locale = '';

  // creativity
  String interestCreativity = '';

  // sports
  String interestSports = '';

  // video
  String interestVideo = '';

  // music
  String interestMusic = '';

  // travelling
  String interestTravelling = '';

  // pet
  String interestPet = '';

  // list of options
  final options = [
    {
      'id': 'givenName',
      'label': 'First Name',
      'callback': () {
        Get.toNamed(Routes.setupIntro);
      }
    },
    {
      'id': 'gender',
      'label': 'Gender',
      'callback': () {
        Get.toNamed(Routes.setupIntro);
      }
    },
    {
      'id': 'targetGender',
      'label': 'I am looking for',
      'callback': () {
        Get.toNamed(Routes.setupIntro);
      }
    },
    {
      'id': 'ageRange',
      'label': 'Age range',
      'callback': () {
        Get.toNamed(Routes.setupOther);
      }
    },
    {
      'id': 'distance',
      'label': 'Distance',
      'callback': () {
        Get.toNamed(Routes.setupOther);
      }
    },
    {
      'id': 'locale',
      'label': 'Language',
      'callback': () {
        Get.toNamed(Routes.setupOther);
      }
    },
    {
      'id': 'interests',
      'label': 'Interests',
      'callback': () {
        Get.toNamed(Routes.setupInterests);
      }
    },
    {
      'id': 'intro',
      'label': 'Intro Recording',
      'callback': () {
        Get.toNamed(Routes.setupRecording);
      }
    },
    {
      'id': 'logout',
      'label': 'Logout',
      'callback': () async {
        try {
          await Amplify.Auth.signOut();
          Get.toNamed(Routes.signIn);
        } catch (err) {
          safePrint('logout - error - $err');
        }
      }
    }
  ];

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

      // given name
      String attrGivenName = attributes
              .firstWhereOrNull((element) =>
                  element.userAttributeKey == CognitoUserAttributeKey.givenName)
              ?.value ??
          '';

      // age range
      String attrAgeRange = attributes
              .firstWhereOrNull((element) =>
                  element.userAttributeKey ==
                  const CognitoUserAttributeKey.custom('custom:age_range'))
              ?.value ??
          '';

      // gender
      String attrGender = attributes
              .firstWhereOrNull((element) =>
                  element.userAttributeKey == CognitoUserAttributeKey.gender)
              ?.value ??
          '';

      // target gender
      String attrTargetGender = attributes
              .firstWhereOrNull((element) =>
                  element.userAttributeKey ==
                  const CognitoUserAttributeKey.custom('custom:target_gender'))
              ?.value ??
          '';

      // distance
      String attrDistance = attributes
              .firstWhereOrNull((element) =>
                  element.userAttributeKey ==
                  const CognitoUserAttributeKey.custom('custom:distance'))
              ?.value ??
          '';

      // locale / languages
      String attrLocale = attributes
              .firstWhereOrNull((element) =>
                  element.userAttributeKey == CognitoUserAttributeKey.locale)
              ?.value ??
          '';

      // creativity
      String attrCreativity = attributes
              .firstWhereOrNull((element) =>
                  element.userAttributeKey ==
                  const CognitoUserAttributeKey.custom(
                      'custom:interest_creativity'))
              ?.value ??
          '';

      // sports
      String attrSports = attributes
              .firstWhereOrNull((element) =>
                  element.userAttributeKey ==
                  const CognitoUserAttributeKey.custom(
                      'custom:interest_sports'))
              ?.value ??
          '';

      // video
      String attrVideo = attributes
              .firstWhereOrNull((element) =>
                  element.userAttributeKey ==
                  const CognitoUserAttributeKey.custom('custom:interest_video'))
              ?.value ??
          '';

      // music
      String attrMusic = attributes
              .firstWhereOrNull((element) =>
                  element.userAttributeKey ==
                  const CognitoUserAttributeKey.custom('custom:interest_music'))
              ?.value ??
          '';

      // travelling
      String attrTravelling = attributes
              .firstWhereOrNull((element) =>
                  element.userAttributeKey ==
                  const CognitoUserAttributeKey.custom(
                      'custom:interest_travelling'))
              ?.value ??
          '';

      // pet
      String attrPet = attributes
              .firstWhereOrNull((element) =>
                  element.userAttributeKey ==
                  const CognitoUserAttributeKey.custom('custom:interest_pet'))
              ?.value ??
          '';

      setState(() {
        givenName = attrGivenName;
        gender = attrGender;
        ageRange = attrAgeRange;
        targetGender = attrTargetGender;
        distance = attrDistance;
        locale = attrLocale;
        interestCreativity = attrCreativity;
        interestSports = attrSports;
        interestVideo = attrVideo;
        interestMusic = attrMusic;
        interestTravelling = attrTravelling;
        interestPet = attrPet;
      });

      // safePrint('gender $gender, targetGender $targetGender');
      // safePrint(
      //     'genderIndex $genderIndex, targetGenderIndex $targetGenderIndex');
    } on AuthException catch (e) {
      safePrint('initUser- error - ${e.message}');
    }
    EasyLoading.dismiss();
  }

  getValue(String id) {
    if (id == 'givenName') {
      return givenName;
    }
    if (id == 'gender') {
      return gender.capitalize;
    }
    if (id == 'targetGender') {
      return targetGender.capitalize;
    }
    if (id == 'ageRange') {
      return ageRange;
    }
    if (id == 'distance') {
      return distance;
    }
    if (id == 'locale') {
      try {
        return List<String>.from(jsonDecode(locale)).join(', ');
      } catch (e) {
        return '';
      }
    }
    if (id == 'interests') {
      return [
        interestCreativity,
        interestSports,
        interestVideo,
        interestMusic,
        interestTravelling,
        interestPet,
      ].takeWhile((value) => value.isNotEmpty).join(', ');
    }
    if (id == 'intro') {
      return '$recordingDuration seconds';
    }
  }

  void onBack() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppLayout(
        Div(
          [
            const Div(
              [
                ProgressBar(value: 1),
              ],
              mt: gapTop,
            ),
            Expanded(
              flex: 1,
              child: MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: ListView(
                  children: [
                    Div(
                      [
                        const Div(
                          [
                            Div(
                              [
                                Avatar(),
                              ],
                              mb: gap,
                            )
                          ],
                          mt: gapTop,
                        ),
                        Div(
                          List.generate(
                            options.length,
                            (i) {
                              final item = options[i];
                              final id = item['id'] as String;
                              final label = item['label'] as String;
                              final value = getValue(id) ?? '';
                              final callback = item['callback'] as Function;
                              return GestureDetector(
                                onTap: () {
                                  callback();
                                },
                                child: Div(
                                  [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Div(
                                          [
                                            P(
                                              label,
                                              isBody1: true,
                                              fg: colorSeondary200,
                                            ),
                                          ],
                                        ),
                                        Div(
                                          [
                                            Row(
                                              children: [
                                                Div(
                                                  [
                                                    Align(
                                                      alignment:
                                                          Alignment.topRight,
                                                      child: P(
                                                        value,
                                                        isBody1: true,
                                                        fg: colorBlack,
                                                        lines: 6,
                                                        ta: TextAlign.right,
                                                        ov: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                  ],
                                                  w: 150,
                                                ),
                                                Div(
                                                  [
                                                    SvgPicture.string(
                                                      iconRight(),
                                                      width: 16,
                                                    ),
                                                  ],
                                                  pl: gap / 4,
                                                ),
                                              ],
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ],
                                  mb: gap / 2,
                                  ph: gap,
                                  pv: gap * 0.7,
                                  bc: colorOnSurfaceDisabled,
                                  br: radius,
                                ),
                              );
                            },
                          ),
                        )
                      ],
                      ph: gap,
                    ),
                  ],
                ),
              ),
            ),
            Div(
              [
                Button(
                  'next',
                  onPress: () {
                    Get.toNamed(Routes.matchesIndex);
                  },
                ),
              ],
              mb: gapTop,
              pt: gap,
              ph: gap,
            ),
          ],
        ),
      ),
    );
  }
}
