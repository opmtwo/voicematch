import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:voicevibe/components/audio_file_player.dart';
import 'package:voicevibe/components/connection_pic.dart';
import 'package:voicevibe/components/current_time.dart';
import 'package:voicevibe/components/wave.dart';
import 'package:voicevibe/constants/colors.dart';
import 'package:voicevibe/constants/theme.dart';
import 'package:voicevibe/constants/types.dart';
import 'package:voicevibe/elements/div.dart';
import 'package:voicevibe/elements/p.dart';
import 'package:voicevibe/form/fab_button.dart';
import 'package:voicevibe/icons/icon_delete.dart';
import 'package:voicevibe/icons/icon_pause.dart';
import 'package:voicevibe/icons/icon_play.dart';
import 'package:voicevibe/icons/icon_send.dart';

class ChatMessage extends StatefulWidget {
  final MessageEventModel message;
  final ConnectionModel connection;
  final Function(String id) onPublish;
  final Function(String id) onDelete;

  const ChatMessage({
    Key? key,
    required this.message,
    required this.connection,
    required this.onPublish,
    required this.onDelete,
  }) : super(key: key);

  @override
  State<ChatMessage> createState() => _ChatMessageState();
}

class _ChatMessageState extends State<ChatMessage> {
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

  // playback state
  PlayerState playbackState = PlayerState.stopped;

  // playback duration
  Duration playbackDuration = const Duration(seconds: 0);

  @override
  initState() {
    super.initState();
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
    final isLocalMessage =
        widget.message.recording?.url.startsWith('https://') == false;

    final isImage = widget.message.upload?.url != null;
    final isLocalImage =
        widget.message.upload?.url.startsWith('https://') == false;

    if (widget.message.type?.toLowerCase() == 'file' && isImage == true) {
      return Column(
        children: [
          Row(
            mainAxisAlignment: widget.message.isSender == true
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            children: [
              Div(
                [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Div(
                      [
                        // P(widget.message.upload?.url),
                        if (isImage == true && isLocalImage == true)
                          Image.asset(
                            widget.message.upload?.url as String,
                            width: 128,
                            height: 128,
                            fit: BoxFit.cover,
                          ),
                        if (isImage == true && isLocalImage == false)
                          Image.network(
                            widget.message.upload?.url as String,
                            width: 128,
                            height: 128,
                            fit: BoxFit.cover,
                          ),
                      ],
                      bg: colorGrey200,
                      h: avatarLarge,
                      w: avatarLarge,
                    ),
                  ),
                ],
                // br: 99,
              ),
            ],
          )
        ],
      );
    }

    if (widget.message.type?.toLowerCase() == 'text') {
      return Column(
        children: [
          Row(
            mainAxisAlignment: widget.message.isSender == true
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            children: [
              Div(
                [
                  P(
                    widget.message.body,
                    fg: colorWhite,
                  ),
                ],
                ph: gap,
                pv: gap / 2,
                bg: const Color(0xFF34332D),
                br: 99,
              ),
            ],
          )
        ],
      );
    }

    final List<Widget> children = [
      if (isLocalMessage == true)
        Div(
          [
            FabButton(
              isBusy == true || widget.message.isBusy == true
                  ? Transform.scale(
                      scale: 0.75,
                      child: const CircularProgressIndicator(
                        color: colorWhite,
                        strokeWidth: 2,
                      ),
                    )
                  : SvgPicture.string(
                      iconSend(),
                      color: colorWhite,
                      width: avatarSmall,
                    ),
              w: avatarSmall,
              h: avatarSmall,
              bg: colorSeondary700,
              onPress: isBusy == true || widget.message.isBusy == true
                  ? null
                  : () {
                      widget.onPublish(widget.message.id);
                    },
            ),
          ],
          ml: widget.message.isSender == true ? gap / 2 : null,
          mr: widget.message.isReceiver == true ? gap / 2 : null,
        ),
      Div(
        [
          ConnectionPic(
            item: widget.connection,
          ),
        ],
      ),
      if (widget.message.recording?.url != null)
        Div(
          [
            AudioFilePlayer(
              audioPath: widget.message.recording?.url as String,
              isLocal:
                  widget.message.recording?.url.startsWith('file://') == true,
              width: avatarSmall,
              height: avatarSmall,
              onPositionChanged: onPositionChanged,
              onStateChanged: onStateChanged,
              iconPlay: SvgPicture.string(
                iconPlay(
                  code: colorWhite,
                ),
                width: 32,
              ),
              iconPlayBg: colorGrey,
              iconPause: SvgPicture.string(
                iconPause(
                  code: colorWhite,
                ),
                width: 16,
              ),
              iconPauseBg: colorBlack,
            )
          ],
          mh: gap / 2,
        ),
      if (widget.message.recording?.url != null)
        Div(
          [
            Wave(
              value: playbackDuration.inMilliseconds.toDouble(),
              total: widget.message.recording?.duration.toDouble() as double,
              w: (MediaQuery.of(context).size.width * 0.7) -
                  ((40 * 2) + (gap * (isLocalMessage ? 4 : 1))),
              bg: const Color(0xFFC3D1FF),
              alt: true,
            ),
          ],
        )
    ];

    return Column(
      children: [
        Row(
          mainAxisAlignment: widget.message.isSender == true
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: [
            Div(
              [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: widget.message.isSender == true
                      ? children.reversed.toList()
                      : children,
                ),
              ],
              pv: gap / 2,
              bg: colorBlack.withOpacity(0.05),
              br: 16,
              w: MediaQuery.of(context).size.width * 0.8,
            ),
          ],
        ),
        if (widget.message.recording?.url != null)
          Div(
            [
              Row(
                mainAxisAlignment: widget.message.isSender == true
                    ? MainAxisAlignment.start
                    : MainAxisAlignment.end,
                children: [
                  Div(
                    [
                      CurrentTime(
                        duration: Duration(
                          milliseconds:
                              widget.message.recording?.duration.toInt() as int,
                        ),
                      ),
                    ],
                    pv: gap / 4,
                  ),
                  if (isLocalMessage == true)
                    Div(
                      [
                        FabButton(
                          SvgPicture.string(
                            iconDelete(),
                            width: 20,
                            color: colorGrey,
                          ),
                          w: avatarExtraSmall,
                          h: avatarExtraSmall,
                          bg: colorTransparent,
                          onPress: () {
                            widget.onDelete(widget.message.id);
                          },
                        )
                      ],
                      mh: gap,
                    ),
                ],
              )
            ],
            w: MediaQuery.of(context).size.width * 0.6,
            ph: gap,
          ),
      ],
    );
  }
}
