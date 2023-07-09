import 'dart:async';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:record/record.dart';
import 'package:voicematch/components/image_masked.dart';
import 'package:voicematch/components/wave.dart';
import 'package:voicematch/constants/colors.dart';
import 'package:voicematch/constants/theme.dart';
import 'package:voicematch/elements/div.dart';
import 'package:voicematch/elements/p.dart';
import 'package:voicematch/form/fab_button.dart';
import 'package:voicematch/icons/icon_close.dart';
import 'package:voicematch/icons/icon_heart.dart';
import 'package:voicematch/icons/icon_pause.dart';
import 'package:voicematch/icons/icon_play.dart';
import 'package:voicematch/icons/icon_skip_left.dart';
import 'package:voicematch/icons/icon_skip_right.dart';
import 'package:voicematch/icons/icon_star.dart';
import 'package:voicematch/icons/icon_wave.dart';
import 'package:voicematch/layouts/app_layout.dart';
import 'package:voicematch/router.dart';
import 'package:voicematch/utils/svg_utils.dart';

class MatchesPreviewScreen extends StatefulWidget {
  const MatchesPreviewScreen({Key? key}) : super(key: key);

  @override
  State<MatchesPreviewScreen> createState() => _MatchesPreviewScreenState();
}

class _MatchesPreviewScreenState extends State<MatchesPreviewScreen> {
  // error and busy
  bool isBusy = false;
  String? error;

  List<String> interests = ['Hiking Trips', 'Writing'];

  // recording?
  bool isRecording = false;
  bool isRecorded = false;

  // recording path
  String? recordingPath;

  // timer
  Timer? timer;

  // recording duration
  Duration duration = const Duration(seconds: 0);

  Future<void> onContinue() async {
    EasyLoading.show(status: 'Loading');
    setState(() {
      error = null;
    });
    EasyLoading.dismiss();
  }

  void onStart() async {
    setState(() {
      error = null;
    });
    if (duration.inSeconds >= recordingDuration) {
      safePrint('onStart - maximum recording duration reached - exit');
      return;
    }
    try {
      timer?.cancel();
      await Record().start(); // Use an instance of the Record class
      Timer newTimer = await onStartTimer();
      setState(() {
        timer = newTimer;
        isRecording = true;
      });
    } catch (err) {
      safePrint('startRecording - error - $err');
    }
  }

  void onPause() async {
    setState(() {
      error = null;
    });
    try {
      await Record().pause();
      setState(() {
        isRecording = false;
      });
    } catch (err) {
      safePrint('onPause - error - $err');
    }
  }

  void onResume() async {
    setState(() {
      error = null;
    });
    if (duration.inSeconds >= recordingDuration) {
      safePrint('onResume - maximum recording duration reached - exit');
      return;
    }
    try {
      timer?.cancel();
      await Record().resume();
      Timer newTimer = await onStartTimer();
      setState(() {
        timer = newTimer;
        isRecording = true;
      });
    } catch (err) {
      safePrint('onResume - error - $err');
    }
  }

  void onStop() async {
    setState(() {
      error = null;
    });
    try {
      String? path = await Record().stop();
      timer?.cancel();
      safePrint('path $path');
      setState(() {
        isRecording = false;
        isRecorded = true;
        recordingPath = path;
      });
    } catch (err) {
      safePrint('onStop - error - $err');
    }
  }

  Future<Timer> onStartTimer() async {
    Timer newTimer = Timer.periodic(const Duration(milliseconds: 100), (t) {
      if (isRecording != true) {
        timer?.cancel();
      }
      if (duration.inSeconds >= recordingDuration) {
        t.cancel();
        onStop();
        return;
      }
      setState(() {
        duration = Duration(milliseconds: duration.inMilliseconds + 100);
      });
    });
    return newTimer;
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
                  flex: 1,
                  child: Div(
                    [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Div(
                            [
                              const Div(
                                [
                                  P(
                                    'Interst Match',
                                    fg: colorBlack,
                                  ),
                                ],
                              ),
                              const Div(
                                [
                                  P(
                                    '65%',
                                    fg: colorBlack,
                                    fw: FontWeight.w700,
                                  ),
                                ],
                                ph: gap,
                                br: 99,
                                bg: colorSeondary700,
                              ),
                              const Div(
                                [
                                  ImageMasked(
                                    url: 'assets/images/avatar.png',
                                    width: 160,
                                    height: 160,
                                  ),
                                ],
                                mv: gap,
                              ),
                              const Div(
                                [
                                  P(
                                    'Interested in',
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
                              const Div(
                                [
                                  P(
                                    'You are listening to',
                                    fg: colorBlack,
                                  ),
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
                                mv: gap / 2,
                              ),
                              Div(
                                [
                                  Wave(
                                    value: duration.inMilliseconds.toDouble(),
                                    total: recordingDuration * 1000,
                                  ),
                                ],
                              ),
                              Div(
                                [
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: P(
                                      '${duration.inMinutes.toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}',
                                      isBody2: true,
                                      fg: colorBlack,
                                    ),
                                  ),
                                ],
                                w: 256,
                              ),
                              Div(
                                [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Div(
                                        [
                                          FabButton(
                                            SvgPicture.string(
                                              iconSkipLeft(),
                                              color: colorSeondary100,
                                            ),
                                            w: 50,
                                            h: 50,
                                            bg: colorTransparent,
                                            onPress: () {
                                              //
                                            },
                                          ),
                                        ],
                                      ),
                                      Div(
                                        [
                                          FabButton(
                                            SvgPicture.string(
                                              isRecording
                                                  ? iconPause()
                                                  : iconPlay(),
                                              color: colorWhite,
                                            ),
                                            w: 50,
                                            h: 50,
                                            bg: colorSeondary200,
                                            onPress: () {
                                              isRecording
                                                  ? onPause()
                                                  : duration.inMicroseconds == 0
                                                      ? onStart()
                                                      : onResume();
                                            },
                                          ),
                                        ],
                                        mh: gap,
                                      ),
                                      Div(
                                        [
                                          FabButton(
                                            SvgPicture.string(
                                              iconSkipRight(),
                                              color: colorSeondary100,
                                            ),
                                            w: 50,
                                            h: 50,
                                            bg: colorTransparent,
                                            onPress: () {
                                              //
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  )
                                ],
                                mv: gap,
                              ),
                            ],
                            pv: gap,
                            bg: colorWhite,
                            br: radiusLarge,
                            shadow: [
                              BoxShadow(
                                color: colorBlack.withOpacity(0.2),
                                blurRadius: 10.0,
                                spreadRadius: 5.0,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                    mt: gapTop,
                  ),
                ),
                Div(
                  [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FabButton(
                          SvgPicture.string(
                            iconClose(),
                            width: 32,
                          ),
                          bg: colorWhite,
                          onPress: () {
                            Get.toNamed(Routes.matchesIndex);
                          },
                        ),
                        FabButton(
                          SvgPicture.string(
                            iconHeart(),
                            width: 24,
                          ),
                          bg: colorWhite,
                          onPress: () {
                            Get.toNamed(Routes.matchesMatch);
                          },
                        ),
                        FabButton(
                          SvgPicture.string(
                            iconStar(),
                            width: 24,
                          ),
                          bg: colorWhite,
                          onPress: () {
                            //
                          },
                        ),
                      ],
                    )
                  ],
                  pb: gapTop,
                  ph: gap,
                )
              ],
              ph: gap,
            ),
          ),
        ),
      ),
    );
  }
}
