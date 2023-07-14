import 'dart:async';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:voicematch/constants/colors.dart';
import 'package:voicematch/form/fab_button.dart';

class AudioFilePlayer extends StatefulWidget {
  // file path or url
  final String audioPath;

  // local file?
  final bool isLocal;

  // delete callback
  final VoidCallback? onPrev;

  // delete callback
  final VoidCallback? onNext;

  // callback when playback position changes
  final Function(Duration) onPositionChanged;

  // callback when playback state changes
  final Function(PlayerState) onStateChanged;

  // play icon - required
  final Widget iconPlay;

  // play icon - required
  final Widget iconPause;

  // play icon bg
  final Color? iconPlayBg;

  // pause icon bg
  final Color? iconPauseBg;

  // skip plus icon - optional
  final Widget? iconSkipPrev;

  // skip minus icon - optional
  final Widget? iconSkipNext;

  // left icon - optional
  final Widget? iconPrev;

  // left icon - optional
  final Widget? iconNext;

  const AudioFilePlayer({
    Key? key,
    required this.audioPath,
    required this.isLocal,
    required this.onPositionChanged,
    required this.onStateChanged,
    required this.iconPlay,
    required this.iconPause,
    this.iconPrev,
    this.iconNext,
    this.iconSkipPrev,
    this.iconSkipNext,
    this.iconPlayBg,
    this.iconPauseBg,
    this.onPrev,
    this.onNext,
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

  // audio stream subscriptions
  StreamSubscription<PlayerState>? playerStateSubscription;
  StreamSubscription<Duration>? positionSubscription;
  StreamSubscription<void>? completeSubscription;

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    playerStateSubscription?.cancel();
    positionSubscription?.cancel();
    completeSubscription?.cancel();
    super.dispose();
  }

  Future<void> init() async {
    audioPlayer = AudioPlayer();
    playerStateSubscription =
        audioPlayer.onPlayerStateChanged.listen((PlayerState state) async {
      widget.onStateChanged(state);
      if ([PlayerState.paused, PlayerState.stopped, PlayerState.completed]
          .contains(state)) {
        setState(() {
          isPlaying = false;
        });
      }
    });
    positionSubscription =
        audioPlayer.onPositionChanged.listen((Duration duration) {
      if (isComplete) {
        return;
      }
      widget.onPositionChanged(duration);
      setState(() {
        currentAudioTime = duration;
      });
    });
    completeSubscription = audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        isComplete = true;
      });
    });
  }

  Future<void> _playAudio() async {
    try {
      setState(() {
        isPlaying = true;
        isComplete = false;
      });
      if (widget.isLocal) {
        await audioPlayer.play(
          DeviceFileSource(widget.audioPath),
        );
      } else {
        await audioPlayer.play(UrlSource(
          widget.audioPath,
        ));
      }
    } catch (err) {
      safePrint('_playAudio - error - $err');
      setState(() {
        isPlaying = false;
        isComplete = false;
      });
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
        if (widget.iconPrev != null)
          FabButton(
            widget.iconPrev!,
            bg: colorTransparent,
            onPress: widget.onPrev,
          ),
        if (widget.iconSkipPrev != null)
          FabButton(
            widget.iconSkipPrev!,
            bg: colorTransparent,
            onPress: _skipBackward,
          ),
        FabButton(
          isPlaying ? widget.iconPause : widget.iconPlay,
          onPress: isPlaying ? _pauseAudio : _playAudio,
          bg: isPlaying ? widget.iconPauseBg : widget.iconPlayBg,
        ),
        if (widget.iconSkipNext != null)
          FabButton(
            widget.iconSkipNext!,
            bg: colorTransparent,
            onPress: _skipForward,
          ),
        if (widget.iconNext != null)
          FabButton(
            widget.iconNext!,
            bg: colorTransparent,
            onPress: widget.onNext,
          ),
      ],
    );
  }
}
