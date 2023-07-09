import 'dart:async';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:record/record.dart';
import 'package:voicematch/components/image_masked.dart';
import 'package:voicematch/components/wave.dart';
import 'package:voicematch/constants/colors.dart';
import 'package:voicematch/constants/theme.dart';
import 'package:voicematch/elements/div.dart';
import 'package:voicematch/elements/p.dart';
import 'package:voicematch/form/fab_button.dart';
import 'package:voicematch/icons/icon_pause.dart';
import 'package:voicematch/icons/icon_play.dart';

class Message extends StatefulWidget {
  final bool? isSender;
  final String? message;
  final String? recordingUrl;
  final int? recordingDuration;

  const Message({
    super.key,
    this.isSender,
    this.message,
    this.recordingUrl,
    this.recordingDuration,
  });

  @override
  State<Message> createState() => _MessageState();
}

/// AnimationControllers can be created with `vsync: this` because of TickerProviderStateMixin.
class _MessageState extends State<Message> with TickerProviderStateMixin {
  // error and busy
  String? error;
  bool? isBusy;

  // recording?
  bool isPlaying = false;
  bool isRecorded = false;

  // recording path
  String? recordingPath;

  // timer
  Timer? timer;

  // recording duration
  Duration duration = const Duration(seconds: 0);

  @override
  initState() {
    super.initState();
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
        isPlaying = true;
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
        isPlaying = false;
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
        isPlaying = true;
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
        isPlaying = false;
        isRecorded = true;
        recordingPath = path;
      });
    } catch (err) {
      safePrint('onStop - error - $err');
    }
  }

  Future<Timer> onStartTimer() async {
    Timer newTimer = Timer.periodic(const Duration(milliseconds: 100), (t) {
      if (isPlaying != true) {
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
    final List<Widget> children = [
      Div(
        [
          ImageMasked(
            url: 'assets/images/avatar.png',
            width: 40,
            height: 40,
            sigmaX: 2,
            sigmaY: 2,
          ),
        ],
      ),
      Div(
        [
          FabButton(
            SvgPicture.string(
              isPlaying ? iconPause() : iconPlay(),
              color: colorWhite,
            ),
            w: 40,
            h: 40,
            bg: isPlaying ? colorBlack : colorOnSurfaceDisabled,
            onPress: () {
              isPlaying
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
          Wave(
            value: duration.inMilliseconds.toDouble(),
            total: recordingDuration * 1000,
            w: (MediaQuery.of(context).size.width * 0.75) -
                ((40 * 2) + (gap * 4)),
            bg: const Color(0xFFC3D1FF),
            alt: true,
          ),
        ],
      )
    ];

    return Column(
      children: [
        Row(
          mainAxisAlignment: widget.isSender == true
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: [
            Div(
              [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: widget.isSender == true
                      ? children.reversed.toList()
                      : children,
                ),
              ],
              pv: gap / 2,
              bg: colorBlack.withOpacity(0.05),
              br: 16,
              w: MediaQuery.of(context).size.width * 0.75,
            ),
          ],
        ),
        if (widget.recordingDuration != null)
          Div(
            [
              Align(
                alignment: widget.isSender == true
                    ? Alignment.topLeft
                    : Alignment.topRight,
                child: P(
                  '${(Duration(seconds: widget.recordingDuration as int)).inMinutes.toString().padLeft(2, '0')}:${(Duration(
                        seconds: widget.recordingDuration as int,
                      ).inSeconds % 60).toString().padLeft(2, '0')}',
                  isBody1: true,
                ),
              ),
            ],
            w: MediaQuery.of(context).size.width * 0.6,
            ph: gap,
          )
      ],
    );
  }
}
