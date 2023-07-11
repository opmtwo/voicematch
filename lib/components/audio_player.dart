import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/route_manager.dart';
import 'package:get/get.dart';
import 'package:voicematch/constants/colors.dart';
import 'package:voicematch/form/fab_button.dart';
import 'package:voicematch/icons/icon_delete.dart';
import 'package:voicematch/icons/icon_pause.dart';
import 'package:voicematch/icons/icon_play.dart';
import 'package:voicematch/icons/icon_rewind_minus.dart';
import 'package:voicematch/icons/icon_rewind_plus.dart';
import 'package:voicematch/icons/icon_settings.dart';
import 'package:voicematch/router.dart';

class AudioFilePlayer extends StatefulWidget {
  // file path or url
  final String audioPath;

  // local file?
  final bool isLocal;

  // delete callback
  final VoidCallback onDelete;

  // callback when playback position changes
  final Function(Duration) onPositionChanged;

  // callback when playback state changes
  final Function(PlayerState) onStateChanged;

  const AudioFilePlayer({
    Key? key,
    required this.audioPath,
    required this.isLocal,
    required this.onDelete,
    required this.onPositionChanged,
    required this.onStateChanged,
  }) : super(key: key);

  @override
  AudioFilePlayerState createState() => AudioFilePlayerState();
}

class AudioFilePlayerState extends State<AudioFilePlayer> {
  // audio player instance
  late AudioPlayer audioPlayer;

  // playing?
  bool isPlaying = false;

  // complete?
  bool isComplete = false;

  // current time
  Duration? currentAudioTime;

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  Future<void> init() async {
    audioPlayer = AudioPlayer();
    audioPlayer.onPlayerStateChanged.listen((PlayerState state) async {
      widget.onStateChanged(state);
      if ([PlayerState.paused, PlayerState.stopped, PlayerState.completed]
          .contains(state)) {
        setState(() {
          isPlaying = false;
        });
      }
    });
    audioPlayer.onPositionChanged.listen((Duration duration) {
      if (isComplete) {
        return;
      }
      widget.onPositionChanged(duration);
      setState(() {
        currentAudioTime = duration;
      });
    });
    audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        isComplete = true;
      });
    });
  }

  Future<void> _playAudio() async {
    try {
      if (widget.isLocal) {
        await audioPlayer.play(
          DeviceFileSource(widget.audioPath),
        );
      } else {
        await audioPlayer.play(UrlSource(
          widget.audioPath,
        ));
      }
      setState(() {
        isPlaying = true;
        isComplete = false;
      });
    } catch (err) {
      safePrint('_playAudio - error - $err');
    }
  }

  Future<void> _pauseAudio() async {
    try {
      await audioPlayer.pause();
      setState(() {
        isPlaying = false;
        isComplete = false;
      });
    } catch (err) {
      safePrint('_pauseAudio - error - $err');
    }
  }

  Future<void> _stopAudio() async {
    try {
      await audioPlayer.stop();
      setState(() {
        isPlaying = false;
        isComplete = false;
      });
    } catch (err) {
      safePrint('_stopAudio - error - $err');
    }
  }

  Future<void> _skipForward(
      {Duration duration = const Duration(seconds: 5)}) async {
    try {
      Duration? currentPosition = await audioPlayer.getCurrentPosition();
      if (currentPosition != null) {
        await audioPlayer.seek(currentPosition + duration);
      }
    } catch (err) {
      safePrint('_skipForward - error - $err');
    }
  }

  Future<void> _skipBackward(
      {Duration duration = const Duration(seconds: 5)}) async {
    try {
      Duration? currentPosition = await audioPlayer.getCurrentPosition();
      if (currentPosition != null) {
        Duration newPosition = currentPosition - duration;
        await audioPlayer
            .seek(newPosition < Duration.zero ? Duration.zero : newPosition);
      }
    } catch (err) {
      safePrint('_rewindBackward - error - $err');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        FabButton(
          SvgPicture.string(
            iconSettings(),
            height: 24,
          ),
          bg: colorTransparent,
          onPress: () {
            Get.toNamed(Routes.profile);
          },
        ),
        FabButton(
          SvgPicture.string(
            iconRewindMinus(),
            height: 24,
          ),
          bg: colorTransparent,
          onPress: _skipBackward,
        ),
        FabButton(
          SvgPicture.string(
            isPlaying ? iconPause() : iconPlay(),
            height: isPlaying ? 24 : 32,
          ),
          onPress: isPlaying ? _pauseAudio : _playAudio,
          bg: colorTransparent,
        ),
        FabButton(
          SvgPicture.string(
            iconRewindPlus(),
            height: 24,
          ),
          bg: colorTransparent,
          onPress: _skipForward,
        ),
        FabButton(
          SvgPicture.string(
            iconDelete(),
            height: 24,
          ),
          bg: colorTransparent,
          onPress: widget.onDelete,
        ),
      ],
    );
  }
}
