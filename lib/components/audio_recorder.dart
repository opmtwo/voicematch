import 'dart:async';
import 'dart:developer';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:record/record.dart';
import 'package:voicematch/components/current_time.dart';
import 'package:voicematch/constants/colors.dart';
import 'package:voicematch/constants/theme.dart';
import 'package:voicematch/elements/div.dart';
import 'package:voicematch/form/fab_button.dart';
import 'package:voicematch/icons/icon_mic.dart';

class AudioRecorder extends StatefulWidget {
  final Future<void> Function(String, Duration) onSubmit;

  const AudioRecorder({
    Key? key,
    required this.onSubmit,
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

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        FabButton(
          SvgPicture.string(
            iconMic(opacity: 0),
            height: 56,
          ),
          onPress: () {
            isRecording ? onStop() : onStart();
          },
          w: 64,
          h: 64,
          bg: isRecording ? colorPrimary : colorSeondary100,
        ),
        if (isRecording)
          Div(
            [
              CurrentTime(
                duration: duration,
                style: const TextStyle(
                  color: colorWhite,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
            ph: gap,
            pt: 2,
            // bg: colorWhite.withOpacity(0.9),
          ),
      ],
    );
  }
}
