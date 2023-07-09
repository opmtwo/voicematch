import 'dart:async';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/route_manager.dart';
import 'dart:io';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:voicematch/components/icon_box.dart';
import 'package:voicematch/components/logo.dart';
import 'package:voicematch/form/progress_bar_alt.dart';
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
import 'package:voicematch/layouts/app_layout.dart';
import 'package:voicematch/router.dart';
import 'package:uuid/uuid.dart';
import 'package:voicematch/utils/date_utils.dart';

Future<String?> uploadFile(String path) async {
  final user = await Amplify.Auth.getCurrentUser();
  final uuid = const Uuid().v4().toString();
  final today = getNow(format: 'yyyy-MM-dd');
  final key = '${user.username}/recordings/$today/$uuid';
  final localFile = File.fromUri(Uri.parse(path));
  try {
    final UploadFileResult result = await Amplify.Storage.uploadFile(
      local: localFile,
      key: key,
      onProgress: (progress) {
        // safePrint(
        //     'Fraction completed: ${progress.getFractionCompleted()}');
      },
    );
    safePrint('Successfully uploaded file: ${result.key}');
    await Amplify.Auth.updateUserAttribute(
      userAttributeKey: CognitoUserAttributeKey.picture,
      value: uuid,
    );
    safePrint('Successfully updated profile pic in user profile: $uuid');
    return key;
  } on StorageException catch (e) {
    safePrint('Error uploading file: $e');
  }
  return null;
}

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
      // String givenName = attributes
      //         .firstWhereOrNull((element) =>
      //             element.userAttributeKey == CognitoUserAttributeKey.givenName)
      //         ?.value ??
      //     '';
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
    Timer newTimer = Timer.periodic(const Duration(milliseconds: 33), (t) {
      if (isRecording != true) {
        timer?.cancel();
      }
      if (duration.inSeconds >= recordingDuration) {
        t.cancel();
        onStop();
        return;
      }
      setState(() {
        duration = Duration(milliseconds: duration.inMilliseconds + 33);
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
      safePrint('recordingPath $recordingPath');
      final key = await uploadFile(recordingPath as String);
      //
      Get.toNamed(Routes.setupDone);
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
                      ProgressBarAlt(
                        value: duration.inMilliseconds.toDouble(),
                        total: recordingDuration * 1000,
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
