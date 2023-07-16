import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:record/record.dart';
import 'package:voicematch/components/audio_file_player.dart';
import 'package:voicematch/components/connection_pic.dart';
import 'package:voicematch/components/connection_tags.dart';
import 'package:voicematch/components/current_time.dart';
import 'package:voicematch/components/wave.dart';
import 'package:voicematch/constants/colors.dart';
import 'package:voicematch/constants/env.dart';
import 'package:voicematch/constants/theme.dart';
import 'package:voicematch/constants/types.dart';
import 'package:voicematch/elements/div.dart';
import 'package:voicematch/elements/p.dart';
import 'package:voicematch/form/circular_progress_bar.dart';
import 'package:voicematch/form/fab_button.dart';
import 'package:voicematch/icons/icon_close.dart';
import 'package:voicematch/icons/icon_heart.dart';
import 'package:voicematch/icons/icon_pause.dart';
import 'package:voicematch/icons/icon_play.dart';
import 'package:voicematch/icons/icon_skip_left.dart';
import 'package:voicematch/icons/icon_skip_right.dart';
import 'package:voicematch/icons/icon_star.dart';
import 'package:voicematch/layouts/app_layout.dart';
import 'package:voicematch/router.dart';

class MatchesPreviewScreen extends StatefulWidget {
  const MatchesPreviewScreen({Key? key}) : super(key: key);

  @override
  State<MatchesPreviewScreen> createState() => _MatchesPreviewScreenState();
}

class _MatchesPreviewScreenState extends State<MatchesPreviewScreen> {
  // error and busy
  bool isBusy = false;
  String? error;

  // match connection id
  late String id;

  // connection
  ConnectionModel? activeItem;

  // recording?
  bool isRecording = false;
  bool isRecorded = false;

  // recording path
  String? recordingPath;

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
    setState(() {
      id = Get.arguments['id'];
    });
    getConnection();
  }

  Future<void> getConnection() async {
    await EasyLoading.show(status: 'loading...');
    try {
      // get access token
      final result = await Amplify.Auth.fetchAuthSession(
        options: CognitoSessionOptions(getAWSCredentials: true),
      ) as CognitoAuthSession;
      final accessToken = result.userPoolTokens?.accessToken;

      // update profile via oboard api
      final url = Uri.parse('${apiEndPoint}api/v1/connections/$id');
      safePrint('getConnection - url $url');
      final response = await http.get(url, headers: {
        'Authorization': accessToken.toString(),
      });
      safePrint('getConnection - status code = ${response.statusCode}');

      // non 200 response code
      if (response.statusCode != 200) {
        throw Exception('getConnection - non-200 code: ${response.statusCode}');
      }

      // decode response
      final json = await jsonDecode(response.body);
      // log('getConnection - json - ${response.body}');

      // parse records
      // List<ConnectionModel> newConnections = [];
      // for (int i = 0; i < json.length; i++) {
      //   newConnections.add(ConnectionModel.fromJson(json[i]));
      // }
      // log('Found ${newConnections.length} connections');

      // update state
      setState(() {
        activeItem = ConnectionModel.fromJson(json);
      });
    } catch (err) {
      safePrint('getConnection- error - $err');
    }
    await EasyLoading.dismiss();
  }

  Future<void> onContinue() async {
    EasyLoading.show(status: 'Loading');
    setState(() {
      error = null;
    });
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

  Future<void> onPinToggle(String id) async {
    EasyLoading.show(status: 'loading...');
    try {
      // get access token
      final result = await Amplify.Auth.fetchAuthSession(
        options: CognitoSessionOptions(getAWSCredentials: true),
      ) as CognitoAuthSession;
      final accessToken = result.userPoolTokens?.accessToken;

      final bool shouldPin = activeItem?.isPinned == true ? false : true;

      // update profile via oboard api
      final url = Uri.parse(
          '${apiEndPoint}api/v1/connections/$id/${shouldPin ? "pin" : "unpin"}');
      safePrint('onPin - url $url');
      final response = await http.post(url, headers: {
        'Authorization': accessToken.toString(),
      });
      safePrint('onPin - status code = ${response.statusCode}');

      // non 200 response code
      if (response.statusCode != 200) {
        throw Exception('onPin - non 200 code - ${response.statusCode}');
      }

      // refresh connection
      await getConnection();
    } catch (err) {
      safePrint('onPin - error $err');
      setState(() {
        error = err.toString();
      });
    }
    EasyLoading.dismiss();
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
                          if (activeItem != null)
                            Div(
                              [
                                Div(
                                  [
                                    const P(
                                      'Interst Match',
                                      fg: colorBlack,
                                    ),
                                    CircularProgressBar(
                                      value: (activeItem?.matchPercentage
                                                  .toInt() ??
                                              0) /
                                          100,
                                      w: 48,
                                      h: 48,
                                      caption: P(
                                        '${activeItem?.matchPercentage.toInt()}%',
                                        fz: 9,
                                        fw: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                // Div(
                                //   [
                                //     P(
                                //       '${activeItem?.matchPercentage.toInt()}%',
                                //       fg: colorBlack,
                                //       fw: FontWeight.w700,
                                //     ),
                                //   ],
                                //   ph: gap,
                                //   br: 99,
                                //   bg: colorSeondary700,
                                // ),
                                Div(
                                  [
                                    ConnectionPic(
                                      item: activeItem!,
                                      w: avatarLarge,
                                    ),
                                  ],
                                  mv: gap,
                                ),
                                ConnectionTags(
                                  item: activeItem as ConnectionModel,
                                  label: 'Interested in',
                                ),
                                const Div(
                                  [
                                    P(
                                      'You are listening to',
                                      fg: colorBlack,
                                    ),
                                  ],
                                ),
                                Div(
                                  [
                                    P(
                                      activeItem?.member.givenName as String,
                                      isH5: true,
                                      fg: colorBlack,
                                    ),
                                  ],
                                  mv: gap / 2,
                                ),
                                Div(
                                  [
                                    Wave(
                                      value: playbackDuration.inMilliseconds
                                          .toDouble(),
                                      total: recordingDuration * 1000,
                                    ),
                                  ],
                                ),
                                Div(
                                  [
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: CurrentTime(
                                        duration: playbackDuration,
                                      ),
                                    ),
                                  ],
                                  w: 256,
                                ),
                                if (activeItem?.member.intro?.url != null)
                                  Div(
                                    [
                                      AudioFilePlayer(
                                        audioPath: activeItem?.member.intro?.url
                                            as String,
                                        isLocal: false,
                                        iconPlay: SvgPicture.string(
                                          iconPlay(code: colorWhite),
                                          width: 36,
                                        ),
                                        iconPlayBg: colorSeondary200,
                                        iconPause: SvgPicture.string(
                                          iconPause(code: colorWhite),
                                          width: 16,
                                        ),
                                        iconPauseBg: colorSeondary200,
                                        iconSkipPrev: SvgPicture.string(
                                          iconSkipLeft(),
                                          height: 24,
                                        ),
                                        iconSkipNext: SvgPicture.string(
                                          iconSkipRight(),
                                          height: 24,
                                        ),
                                        onPositionChanged: onPositionChanged,
                                        onStateChanged: onStateChanged,
                                      ),
                                    ],
                                    w: 200,
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
                            // Get.toNamed(Routes.matchesIndex);
                            Get.back();
                          },
                        ),
                        FabButton(
                          SvgPicture.string(
                            iconHeart(
                              code: activeItem?.isPinned == true
                                  ? colorPrimary
                                  : colorGrey900,
                            ),
                            width: 24,
                          ),
                          bg: colorWhite,
                          onPress: () {
                            onPinToggle(activeItem?.id as String);
                          },
                        ),
                        FabButton(
                          SvgPicture.string(
                            iconStar(),
                            width: 24,
                          ),
                          bg: colorWhite,
                          onPress: () {
                            Get.toNamed(Routes.matchesMatch, arguments: {
                              'id': activeItem?.id as String,
                            });
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
