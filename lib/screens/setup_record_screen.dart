import 'dart:async';
import 'dart:math';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/route_manager.dart';
import 'package:get/get.dart';
import 'package:record/record.dart';
import 'package:voicematch/components/icon_box.dart';
import 'package:voicematch/components/logo.dart';
import 'package:voicematch/constants/colors.dart';
import 'package:voicematch/constants/options.dart';
import 'package:voicematch/constants/theme.dart';
import 'package:voicematch/elements/div.dart';
import 'package:voicematch/elements/p.dart';
import 'package:voicematch/form/button.dart';
import 'package:voicematch/form/fab_button.dart';
import 'package:voicematch/form/progress_bar.dart';
import 'package:voicematch/icons/icon_delete.dart';
import 'package:voicematch/icons/icon_mic.dart';
import 'package:voicematch/icons/icon_pause.dart';
import 'package:voicematch/icons/icon_play.dart';
import 'package:voicematch/icons/icon_rewind_minus.dart';
import 'package:voicematch/icons/icon_rewind_plus.dart';
import 'package:voicematch/icons/icon_stop.dart';
import 'package:voicematch/layouts/app_layout.dart';
import 'package:voicematch/router.dart';

class SetupRecordScreen extends StatefulWidget {
  const SetupRecordScreen({Key? key}) : super(key: key);

  @override
  State<SetupRecordScreen> createState() => SetupRecordScreenState();
}

class SetupRecordScreenState extends State<SetupRecordScreen> {
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
      setState(() {
        //
      });
    } on AuthException catch (e) {
      safePrint('initUser- error - ${e.message}');
    }
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

  void onDelete() async {
    setState(() {
      error = null;
    });
    EasyLoading.show(status: 'loading...');
    try {
      await Record().stop();
      setState(() {
        isRecording = false;
        isRecorded = false;
        duration = const Duration(milliseconds: 0);
      });
    } catch (err) {
      safePrint('onDelete - error - $err');
    }
    EasyLoading.dismiss();
  }

  Future<bool> isFormValid() async {
    String? err = '';
    bool isValid = true;

    err = isRecorded && recordingPath != null
        ? null
        : 'Please record your audio to continue';
    setState(() => error = err);
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
      //
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
            const Div(
              [
                ProgressBar(value: 1 / 4),
              ],
              mv: gapTop,
            ),
            Expanded(
              flex: 1,
              child: Div(
                [
                  const Div(
                    [
                      Logo(),
                    ],
                    mb: gap,
                  ),
                  const Div(
                    [
                      P(
                        'Please record a short $recordingDuration second voice message. Just imagine you introduce yourself to a new friend.',
                        isBody1: true,
                        ta: TextAlign.center,
                      ),
                    ],
                    mb: gap,
                  ),
                  Div(
                    [
                      P(
                        '00.${duration.inSeconds.toString().padLeft(2, "0")}.00',
                        fg: colorBlack,
                        isBody1: true,
                        ta: TextAlign.center,
                      ),
                    ],
                  ),
                  Div(
                    [
                      Stack(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: const [
                              Div(
                                [],
                                h: 40,
                              ),
                            ],
                          ),
                          Div([
                            ProgressBar(
                              value: duration.inSeconds / recordingDuration,
                              h: 4,
                              gutter: (gap * 2).toInt(),
                            ),
                          ], pt: 18),
                          Positioned(
                            top: 0,
                            left: duration.inSeconds /
                                recordingDuration *
                                (MediaQuery.of(context).size.width -
                                    (gap * 2) -
                                    40),
                            child: const IconBox(
                              Div([]),
                              w: 40,
                              h: 40,
                              bg: colorSeondary050,
                            ),
                          ),
                          Positioned(
                            top: 10,
                            left: duration.inSeconds /
                                    recordingDuration *
                                    (MediaQuery.of(context).size.width -
                                        (gap * 2) - // gap on both sides
                                        40) + // circle width
                                10, // shift center circle to center of parent circle
                            child: const IconBox(
                              Div([]),
                              w: 20,
                              h: 20,
                              bg: colorSeondary500,
                            ),
                          ),
                        ],
                      ),
                    ],
                    mv: gapBottom,
                  ),
                ],
                ph: gap,
              ),
            ),
            Div(
              [
                if (error != null)
                  Div(
                    [
                      P(
                        error,
                        isBody1: true,
                        fg: colorPrimary,
                        fw: FontWeight.w600,
                      ),
                    ],
                    mb: gap,
                  ),
                Div(
                  [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const FabButton(
                          Div([]),
                          bg: colorTransparent,
                        ),
                        FabButton(
                          SvgPicture.string(
                            iconRewindMinus(),
                            height: 24,
                          ),
                          bg: colorTransparent,
                          onPress: () {
                            //
                          },
                        ),
                        FabButton(
                          SvgPicture.string(
                            isRecording ? iconPause() : iconPlay(),
                            height: isRecording ? 24 : 32,
                          ),
                          onPress: isRecording ? onStop : onStart,
                          bg: colorTransparent,
                        ),
                        FabButton(
                          SvgPicture.string(
                            iconRewindPlus(),
                            height: 24,
                          ),
                          bg: colorTransparent,
                          onPress: () {
                            //
                          },
                        ),
                        FabButton(
                          SvgPicture.string(
                            iconDelete(),
                            height: 24,
                          ),
                          bg: colorTransparent,
                          onPress: onDelete,
                        ),
                      ],
                    )
                  ],
                  mv: gapTop,
                ),
                Div(
                  [
                    ConstrainedBox(
                      constraints: const BoxConstraints.tightForFinite(
                        width: 100,
                        height: 100,
                      ),
                      child: Stack(
                        children: [
                          const Positioned(
                            top: 0,
                            right: 0,
                            left: 0,
                            child: Div(
                              [
                                IconBox(
                                  Div([]),
                                  w: 100,
                                  h: 100,
                                ),
                              ],
                              bg: colorSeondary050,
                              br: 50,
                            ),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            left: 0,
                            child: IconBox(
                              SvgPicture.string(
                                iconMic(),
                                // width: 500,
                                height: 100,
                              ),
                              w: 100,
                              h: 100,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  mb: gap * 2,
                ),
                Div(
                  [
                    Button(
                      'next',
                      onPress: onSubmit,
                    ),
                  ],
                )
              ],
              ph: gap,
              pb: gapTop,
            )
          ],
        ),
      ),
    );
  }
}
