import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/route_manager.dart';
import 'package:get/get.dart';
import 'package:voicematch/components/icon_box.dart';
import 'package:voicematch/constants/colors.dart';
import 'package:voicematch/constants/options.dart';
import 'package:voicematch/constants/theme.dart';
import 'package:voicematch/elements/div.dart';
import 'package:voicematch/elements/hr.dart';
import 'package:voicematch/elements/p.dart';
import 'package:voicematch/form/button.dart';
import 'package:voicematch/form/progress_bar.dart';
import 'package:voicematch/icons/icon_check.dart';
import 'package:voicematch/layouts/app_layout.dart';
import 'package:voicematch/router.dart';

class SetupInterestsScreen extends StatefulWidget {
  const SetupInterestsScreen({Key? key}) : super(key: key);

  @override
  State<SetupInterestsScreen> createState() => SetupInterestsScreenState();
}

class SetupInterestsScreenState extends State<SetupInterestsScreen> {
  String interestCreativity = '';
  String? interestCreativityError;

  String interestSports = '';
  String? interestSportsError;

  String interestVideo = '';
  String? interestVideoError;

  String interestMusic = '';
  String? interestMusicError;

  String interestTravelling = '';
  String? interestTravellingError;

  String interestPet = '';
  String? interestPetError;

  String? error;

  final options = [
    {
      'id': 'creativity',
      'label': 'Creativity',
      'options': interestCreativityOptions,
    },
    {
      'id': 'sports',
      'label': 'Sports',
      'options': interestSportsOptions,
    },
    {
      'id': 'video',
      'label': 'Film & TV',
      'options': interestVideoOptions,
    },
    {
      'id': 'music',
      'label': 'Music',
      'options': interestMusicOptions,
    },
    {
      'id': 'travelling',
      'label': 'Travelling',
      'options': interestTravellingOptions,
    },
    {
      'id': 'pets',
      'label': 'Pets',
      'options': interestPetOptions,
    }
  ];

  @override
  void initState() {
    super.initState();
    initUser();
  }

  onChange(String id, String value) {
    if (id == 'creativity') {
      setState(() {
        interestCreativity = value;
      });
    }
    if (id == 'sports') {
      setState(() {
        interestSports = value;
      });
    }
    if (id == 'video') {
      setState(() {
        interestVideo = value;
      });
    }
    if (id == 'music') {
      setState(() {
        interestMusic = value;
      });
    }
    if (id == 'travelling') {
      setState(() {
        interestTravelling = value;
      });
    }
    if (id == 'pets') {
      setState(() {
        interestPet = value;
      });
    }
  }

  getError(String id) {
    if (id == 'creativity') {
      return interestCreativityError;
    }
    if (id == 'sports') {
      return interestSportsError;
    }
    if (id == 'video') {
      return interestVideoError;
    }
    if (id == 'music') {
      return interestMusicError;
    }
    if (id == 'travelling') {
      return interestTravellingError;
    }
    if (id == 'pets') {
      return interestPetError;
    }
  }

  getIsChecked(String id, String value) {
    // safePrint('id = $id, value = $value');
    // safePrint({
    //   interestCreativity,
    //   interestSports,
    //   interestVideo,
    //   interestMusic,
    //   interestTravelling,
    //   interestPet,
    // });
    if (id == 'creativity') {
      return interestCreativity == value;
    }
    if (id == 'sports') {
      return interestSports == value;
    }
    if (id == 'video') {
      return interestVideo == value;
    }
    if (id == 'music') {
      return interestMusic == value;
    }
    if (id == 'travelling') {
      return interestTravelling == value;
    }
    if (id == 'pets') {
      return interestPet == value;
    }
    return false;
  }

  Future<void> initUser() async {
    EasyLoading.show(status: 'loading...');
    try {
      List<AuthUserAttribute> attributes =
          await Amplify.Auth.fetchUserAttributes();

      // creativity
      String creativity = attributes
              .firstWhereOrNull((element) =>
                  element.userAttributeKey ==
                  const CognitoUserAttributeKey.custom(
                      'custom:interest_creativity'))
              ?.value ??
          '';

      // sports
      String sports = attributes
              .firstWhereOrNull((element) =>
                  element.userAttributeKey ==
                  const CognitoUserAttributeKey.custom(
                      'custom:interest_sports'))
              ?.value ??
          '';

      // video
      String video = attributes
              .firstWhereOrNull((element) =>
                  element.userAttributeKey ==
                  const CognitoUserAttributeKey.custom('custom:interest_video'))
              ?.value ??
          '';

      // music
      String music = attributes
              .firstWhereOrNull((element) =>
                  element.userAttributeKey ==
                  const CognitoUserAttributeKey.custom('custom:interest_music'))
              ?.value ??
          '';

      // travelling
      String travelling = attributes
              .firstWhereOrNull((element) =>
                  element.userAttributeKey ==
                  const CognitoUserAttributeKey.custom(
                      'custom:interest_travelling'))
              ?.value ??
          '';

      // pet
      String pet = attributes
              .firstWhereOrNull((element) =>
                  element.userAttributeKey ==
                  const CognitoUserAttributeKey.custom('custom:interest_pet'))
              ?.value ??
          '';

      setState(() {
        interestCreativity = creativity;
        interestSports = sports;
        interestVideo = video;
        interestMusic = music;
        interestTravelling = travelling;
        interestPet = pet;
      });

      // safePrint('gender $gender, targetGender $targetGender');
    } on AuthException catch (e) {
      safePrint('initUser- error - ${e.message}');
    }
    EasyLoading.dismiss();
  }

  Future<bool> isFormValid() async {
    String? err = '';
    bool isValid = true;

    err = interestCreativity.isNotEmpty
        ? null
        : 'Please select creativity interest';
    setState(() => interestCreativityError = err);
    isValid = err == null ? isValid : false;

    err = interestSports.isNotEmpty ? null : 'Please select sports interest';
    setState(() => interestSportsError = err);
    isValid = err == null ? isValid : false;

    err = interestVideo.isNotEmpty ? null : 'Please select film & tv interest';
    setState(() => interestVideoError = err);
    isValid = err == null ? isValid : false;

    err = interestMusic.isNotEmpty ? null : 'Please select music interest';
    setState(() => interestMusicError = err);
    isValid = err == null ? isValid : false;

    err = interestTravelling.isNotEmpty
        ? null
        : 'Please select travelling interest';
    setState(() => interestTravellingError = err);
    isValid = err == null ? isValid : false;

    err = interestPet.isNotEmpty ? null : 'Please select pets interest';
    setState(() => interestPetError = err);
    isValid = err == null ? isValid : false;

    return isValid;
  }

  void onBack() {
    Navigator.pop(context);
  }

  Future<void> onSubmit() async {
    final isValid = await isFormValid();
    if (!isValid) {
      return;
    }
    EasyLoading.show(status: 'loading...');
    try {
      await Amplify.Auth.updateUserAttributes(
        attributes: [
          AuthUserAttribute(
            userAttributeKey: const CognitoUserAttributeKey.custom(
                'custom:interest_creativity'),
            value: interestCreativity,
          ),
          AuthUserAttribute(
            userAttributeKey:
                const CognitoUserAttributeKey.custom('custom:interest_sports'),
            value: interestSports,
          ),
          AuthUserAttribute(
            userAttributeKey:
                const CognitoUserAttributeKey.custom('custom:interest_video'),
            value: interestVideo,
          ),
          AuthUserAttribute(
            userAttributeKey:
                const CognitoUserAttributeKey.custom('custom:interest_music'),
            value: interestMusic,
          ),
          AuthUserAttribute(
            userAttributeKey: const CognitoUserAttributeKey.custom(
                'custom:interest_travelling'),
            value: interestTravelling,
          ),
          AuthUserAttribute(
            userAttributeKey:
                const CognitoUserAttributeKey.custom('custom:interest_pet'),
            value: interestPet,
          ),
        ],
      );
      // Get.toNamed(Routes.setupOther);
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
            Div(
              [
                const ProgressBar(value: 3 / 4),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: const [
                    Div(
                      [
                        P(
                          'Select your passions',
                          isH6: true,
                          fg: colorBlack,
                        )
                      ],
                      pv: gap,
                      ph: gap,
                      bg: colorPrimary100,
                    ),
                  ],
                )
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
                        Div(
                          List.generate(
                            options.length,
                            (i) {
                              final item = options[i];
                              final id = item['id'] as String;
                              final label = item['label'] as String;
                              final errMsg = getError(id);
                              final items = item['options'] as List<String>;
                              return Div(
                                [
                                  Div(
                                    [
                                      Div(
                                        [
                                          P(
                                            label.toUpperCase(),
                                            isCaption: true,
                                            fg: colorBlack,
                                            fw: FontWeight.w600,
                                            ls: 3,
                                          ),
                                        ],
                                        mb: gap / 2,
                                      ),
                                      if (errMsg != null && errMsg.isNotEmpty)
                                        Div(
                                          [
                                            P(
                                              errMsg,
                                              fg: colorPrimary,
                                              fw: FontWeight.w600,
                                              isBody1: true,
                                            )
                                          ],
                                          mb: gap / 2,
                                        ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          Wrap(
                                            crossAxisAlignment:
                                                WrapCrossAlignment.center,
                                            alignment:
                                                WrapAlignment.spaceBetween,
                                            runSpacing: gap / 2,
                                            spacing: gap / 4,
                                            children: List.generate(
                                              items.length,
                                              (j) {
                                                final tag = items[j];
                                                final isChecked =
                                                    getIsChecked(id, tag);
                                                return GestureDetector(
                                                  onTap: () {
                                                    onChange(id, tag);
                                                  },
                                                  child: Div(
                                                    [
                                                      Div(
                                                        [
                                                          P(isChecked
                                                              ? 'Yes'
                                                              : 'No'),
                                                        ],
                                                      ),
                                                      Div(
                                                        [
                                                          Wrap(
                                                            crossAxisAlignment:
                                                                WrapCrossAlignment
                                                                    .center,
                                                            children: [
                                                              if (isChecked)
                                                                IconBox(
                                                                  SvgPicture
                                                                      .string(
                                                                    iconCheck(),
                                                                    // width: 500,
                                                                    height: 20,
                                                                  ),
                                                                  w: 20,
                                                                  h: 20,
                                                                  bg: colorOnSurfaceDisabled,
                                                                ),
                                                              Div(
                                                                [
                                                                  P(
                                                                    tag,
                                                                    isBody2:
                                                                        true,
                                                                    fg: colorBlack,
                                                                  ),
                                                                ],
                                                                ml: isChecked
                                                                    ? gap / 4
                                                                    : null,
                                                              )
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                    pv: gap / 2,
                                                    ph: gap * .75,
                                                    bg: isChecked
                                                        ? colorSeondary
                                                        : colorGrey200,
                                                    br: 99,
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Div(
                                        [
                                          Hr(),
                                        ],
                                        pt: gap / 2,
                                      ),
                                    ],
                                  ),
                                ],
                                mb: gap * 2,
                              );
                            },
                          ),
                        ),
                      ],
                      pt: gap,
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
                  onPress: onSubmit,
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