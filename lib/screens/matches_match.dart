import 'dart:async';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/route_manager.dart';
import 'package:get/get.dart';
import 'package:voicematch/components/image_masked.dart';
import 'package:voicematch/components/logo.dart';
import 'package:voicematch/constants/colors.dart';
import 'package:voicematch/constants/theme.dart';
import 'package:voicematch/elements/div.dart';
import 'package:voicematch/elements/p.dart';
import 'package:voicematch/form/button.dart';
import 'package:voicematch/form/progress_bar.dart';
import 'package:voicematch/layouts/app_layout.dart';
import 'package:voicematch/router.dart';

class MatchesMatchScreen extends StatefulWidget {
  const MatchesMatchScreen({Key? key}) : super(key: key);

  @override
  State<MatchesMatchScreen> createState() => MatchesMatchScreenState();
}

class MatchesMatchScreenState extends State<MatchesMatchScreen> {
  // error and busy
  String? error;
  bool? isBusy;

  // recording?
  bool isRecording = false;
  bool isRecorded = false;

  // recording path
  String? recordingPath;

  // timer
  Timer? timer;

  // recording duration
  Duration duration = const Duration(seconds: 0);

  List<String> interests = ['Hiking Trips', 'Writing'];

  @override
  void initState() {
    super.initState();
    getUser();
  }

  Future<void> getUser() async {
    EasyLoading.show(status: 'loading...');
    try {
      setState(() {
        //
      });
    } on AuthException catch (e) {
      safePrint('getUser- error - ${e.message}');
    }
    EasyLoading.dismiss();
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
                ProgressBar(
                  value: 4 / 4,
                ),
              ],
              mt: gapTop,
            ),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Div(
                    [
                      Logo(),
                    ],
                    mb: gap,
                  ),
                  const Div(
                    [
                      P(
                        'Congratulations',
                        isH5: true,
                        fw: FontWeight.w600,
                      ),
                    ],
                    mb: gap / 2,
                  ),
                  const Div(
                    [
                      P(
                        'You have a match',
                        isBody1: true,
                        fw: FontWeight.w600,
                      ),
                    ],
                  ),
                  Div(
                    [
                      ImageMasked(
                        url: 'assets/images/avatar.png',
                        width: 160,
                        height: 160,
                      ),
                    ],
                    mv: gap,
                    br: 99,
                    shadow: [
                      BoxShadow(
                        color: colorBlack.withOpacity(0.1),
                        spreadRadius: 10,
                        blurRadius: 50,
                      )
                    ],
                  ),
                  const Div(
                    [
                      P(
                        'Mario',
                        isH5: true,
                        fg: colorBlack,
                      ),
                    ],
                  ),
                  const Div(
                    [
                      P(
                        'You’re both interested in - ',
                        isBody2: true,
                        fg: colorBlack,
                      ),
                    ],
                    mb: gap / 2,
                  ),
                  Div(
                    [
                      Wrap(
                        runSpacing: gap / 2,
                        spacing: gap / 2,
                        children: List.generate(
                          interests.length,
                          (index) {
                            return const Div(
                              [
                                P(
                                  'Hiking Trips',
                                  isBody1: true,
                                  fg: colorBlack,
                                ),
                              ],
                              ph: gap / 2,
                              pv: gap / 2,
                              bg: colorSeondary,
                              br: 99,
                            );
                          },
                        ),
                      ),
                    ],
                    mb: gap,
                  ),
                ],
                // ph: gap,
              ),
            ),
            Div(
              [
                Div(
                  [
                    Button(
                      'speak now',
                      onPress: () {
                        Get.toNamed(Routes.matchesChat, arguments: {
                          'id': 123,
                        });
                      },
                    ),
                  ],
                )
              ],
              ph: gap,
              pb: gapBottom,
            )
          ],
        ),
      ),
    );
  }
}
