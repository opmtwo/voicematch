import 'dart:async';
import 'dart:developer';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:record/record.dart';
import 'package:voicevibe/components/current_time.dart';
import 'package:voicevibe/constants/colors.dart';
import 'package:voicevibe/constants/theme.dart';
import 'package:voicevibe/elements/div.dart';
import 'package:voicevibe/form/fab_button.dart';
import 'package:voicevibe/icons/icon_mic.dart';

class AudioRecorder extends StatefulWidget {
  final Future<void> Function(String, Duration) onSubmit;

  final double? w;
  final double? h;
  final double? d;

  const AudioRecorder({
    Key? key,
    required this.onSubmit,
    this.w,
    this.h,
    this.d,
  }) : super(key: key);

  @override
  State<AudioRecorder> createState() => _AudioRecorderState();
}

class _AudioRecorderState extends State<AudioRecorder> {
  _AudioRecorderState();

  // error and busy
  String? error;
  bool? isBusy;

  // recording?
  bool isRecording = false;
  bool isRecorded = false;

  // recording path
  String? recordingPath;

  // recording duration
  Duration duration = const Duration(seconds: 0);

  // stream to keep track of recording duration
  StreamSubscription<Duration>? subscription;

  @override
  initState() {
    super.initState();
  }

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  void onStart() async {
    try {
      setState(() {
        error = null;
        isRecording = true;
      });
      final record = Record();
      if (await record.hasPermission()) {
        await Record().start();
      }
      startRecordingDuration();
    } catch (err) {
      log('startRecording - error - $err');
      setState(() {
        error = err.toString();
        isRecording = false;
      });
    }
  }

  void onStop() async {
    try {
      String? path = await Record().stop();
      // log('path $path');
      await stopRecordingDuration();
      if (path is String) {
        Duration? audioDuration;
        try {
          final audioPlayer = AudioPlayer();
          await audioPlayer.setSource(
            DeviceFileSource(path),
          );
          audioDuration = await audioPlayer.getDuration();
        } catch (err) {
          safePrint('Error loading audio file to find duration - $err');
        }
        await widget.onSubmit(path, audioDuration ?? duration);
      }
      setState(() {
        error = null;
        isRecording = false;
        recordingPath = path;
        isRecorded = true;
        duration = const Duration();
      });
    } catch (err) {
      // log('onStop - error - $err');
      setState(() {
        error = err.toString();
        isRecording = false;
        isRecorded = false;
      });
    }
  }

  void startRecordingDuration() {
    subscription = Stream.periodic(const Duration(milliseconds: 50), (_) {
      return duration + const Duration(milliseconds: 50);
    }).listen((newDuration) {
      // log('newDuration - ${newDuration.inMilliseconds}');
      setState(() {
        duration = newDuration;
      });
    });
  }

  Future<void> stopRecordingDuration() async {
    await subscription?.cancel();
    setState(() {
      subscription = null;
    });
  }

  final double defaultWidth = 64;
  final double defaultHeight = 64;
  final double defaultDiff = 8;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        FabButton(
          SvgPicture.string(
            iconMic(opacity: 0),
            height: (widget.h ?? defaultHeight) - (widget.d ?? defaultDiff),
          ),
          onPress: () {
            isRecording ? onStop() : onStart();
          },
          w: widget.w ?? defaultWidth,
          h: widget.h ?? defaultHeight,
          bg: isRecording ? colorPrimary : colorSeondary100,
        ),
        if (isRecording)
          IgnorePointer(
            child: Div(
              [
                CurrentTime(
                  duration: duration,
                  style: const TextStyle(
                    color: colorWhite,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
