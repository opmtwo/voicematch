import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/route_manager.dart';
import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:voicematch/components/audio_file_player.dart';
import 'package:voicematch/components/current_time.dart';
import 'package:voicematch/components/logo.dart';
import 'package:voicematch/constants/env.dart';
import 'package:voicematch/form/progress_bar_alt.dart';
import 'package:voicematch/constants/colors.dart';
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
import 'package:voicematch/icons/icon_settings.dart';
import 'package:voicematch/layouts/app_layout.dart';
import 'package:voicematch/router.dart';
import 'package:uuid/uuid.dart';
import 'package:voicematch/utils/date_utils.dart';

Future<String> uploadFile(String path) async {
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
      options: UploadFileOptions(
        contentType: 'audio/mp4',
      ),
    );
    safePrint('Successfully uploaded file: ${result.key}');
    await Amplify.Auth.updateUserAttribute(
      userAttributeKey:
          const CognitoUserAttributeKey.custom('custom:intro_recording'),
      value: 'public/$key',
    );
    await Amplify.Auth.updateUserAttribute(
      userAttributeKey:
          const CognitoUserAttributeKey.custom('custom:intro_duration'),
      value: recordingDuration.toString(),
    );
    safePrint('Successfully updated intro recording user profile: $uuid');
    return key;
  } on StorageException catch (err) {
    safePrint('Error uploading file: $err');
    rethrow;
  }
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

  // current recording url
  String? userRecordingUrl;

  // current recording url
  int? userRecordingDuration;

  // timer
  Timer? timer;

  // recording duration
  Duration duration = const Duration(seconds: 0);

  // playback state
  PlayerState playbackState = PlayerState.stopped;

  // playback duration
  Duration playbackDuration = const Duration(seconds: 0);

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
      String attrRecordingUrl = attributes
              .firstWhereOrNull((element) =>
                  element.userAttributeKey ==
                  const CognitoUserAttributeKey.custom(
                      'custom:intro_recording_url'))
              ?.value ??
          '';
      String attrRecordingDuration = attributes
              .firstWhereOrNull((element) =>
                  element.userAttributeKey ==
                  const CognitoUserAttributeKey.custom('custom:intro_duration'))
              ?.value ??
          '';
      setState(() {
        userRecordingUrl = attrRecordingUrl;
        if (attrRecordingDuration.isNotEmpty) {
          userRecordingDuration = int.parse(attrRecordingDuration);
        }
      });
      if (userRecordingUrl != null && userRecordingDuration != null) {
        setState(() {
          isRecorded = true;
        });
      }
      safePrint(
          'userRecordingUrl $userRecordingUrl, userRecordingDuration $userRecordingDuration');
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
        // here we set the playback time as the total recording time
        // because we don't want to show zero after the user has recorded the audio
        playbackDuration = const Duration(seconds: recordingDuration);
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
        playbackState = PlayerState.stopped;
        playbackDuration = const Duration(milliseconds: 0);
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

      // get access token
      final result = await Amplify.Auth.fetchAuthSession(
        options: CognitoSessionOptions(getAWSCredentials: true),
      ) as CognitoAuthSession;
      final accessToken = result.userPoolTokens?.accessToken;

      // update profile via oboard api
      final url = Uri.parse(
          '${apiEndPoint}api/v1/onboard?recording=true&duration=$recordingDuration');
      safePrint('onSubmit - url $url');
      final response = await http.post(url, body: jsonEncode({}), headers: {
        'Authorization': accessToken.toString(),
      });
      safePrint('onSubmit - status code = ${response.statusCode}');

      // all done
      Get.toNamed(Routes.setupDone);
    } on AuthException catch (e) {
      safePrint('onSubmit - error ${e.message}');
      setState(() {
        error = e.message;
      });
    }
    EasyLoading.dismiss();
  }

  void onPositionChanged(Duration duration) {
    setState(() {
      playbackDuration = duration;
    });
  }

  void onStateChanged(PlayerState state) {
    setState(() {
      playbackState = state;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppLayout(
        Div(
          [
            const Div(
              [
                ProgressBar(value: 4 / 5),
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
                  // this shows recording time or current playback time based on the current state
                  Div(
                    [
                      CurrentTime(
                        duration: isRecorded ? playbackDuration : duration,
                      ),
                    ],
                  ),
                  // this shows recording progress or current playback progress based on the current state
                  Div(
                    [
                      ProgressBarAlt(
                        value: isRecorded
                            ? min(recordingDuration * 1000,
                                playbackDuration.inMilliseconds.toDouble())
                            : duration.inMilliseconds.toDouble(),
                        total: recordingDuration * 1000,
                        gutter: (gap * 2).toInt(),
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
                if (isRecorded &&
                    ((recordingPath != null &&
                            recordingPath?.trim().isNotEmpty == true) ||
                        (userRecordingUrl != null &&
                            userRecordingUrl?.trim().isNotEmpty == true)))
                  Div(
                    [
                      AudioFilePlayer(
                        audioPath: recordingPath != null &&
                                recordingPath?.trim().isNotEmpty == true
                            ? recordingPath as String
                            : userRecordingUrl as String,
                        isLocal: recordingPath != null &&
                            recordingPath?.trim().isNotEmpty == true,
                        iconPlay: SvgPicture.string(
                          iconPlay(
                            code: colorWhite,
                          ),
                          width: 32,
                        ),
                        iconPause: SvgPicture.string(
                          iconPause(
                            code: colorWhite,
                          ),
                          width: 16,
                        ),
                        iconSkipPrev: SvgPicture.string(
                          iconRewindMinus(),
                          height: 24,
                        ),
                        iconSkipNext: SvgPicture.string(
                          iconRewindPlus(),
                          height: 24,
                        ),
                        iconPrev: SvgPicture.string(
                          iconSettings(),
                          height: 24,
                        ),
                        iconNext: SvgPicture.string(
                          iconDelete(),
                          height: 24,
                        ),
                        onPrev: () {
                          Get.toNamed(Routes.profile);
                        },
                        onNext: onDelete,
                        onPositionChanged: onPositionChanged,
                        onStateChanged: onStateChanged,
                      ),
                    ],
                    h: 100,
                  ),
                if (!isRecorded)
                  Div(
                    [
                      FabButton(
                        SvgPicture.string(
                          isRecording
                              ? iconPause(code: colorWhite)
                              : iconMic(
                                  opacity: 0,
                                ),
                          height: isRecording ? 36 : 100,
                        ),
                        w: 100,
                        h: 100,
                        bg: isRecording ? colorPrimary : colorSeondary100,
                        onPress: isRecording
                            ? onPause
                            : duration.inMicroseconds == 0
                                ? onStart
                                : onResume,
                      ),
                    ],
                    h: 100,
                  ),
                Div(
                  [
                    Button(
                      'next',
                      onPress: onSubmit,
                    ),
                  ],
                  mt: gapTop,
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
