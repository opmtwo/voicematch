import 'dart:math';

import 'package:flutter/material.dart';
import 'package:voicevibe/components/connection_pic.dart';
import 'package:voicevibe/constants/colors.dart';
import 'package:voicevibe/constants/theme.dart';
import 'package:voicevibe/constants/types.dart';
import 'package:voicevibe/elements/div.dart';
import 'package:voicevibe/elements/p.dart';
import 'package:voicevibe/form/button.dart';
import 'package:voicevibe/form/progress_bar_alt.dart';

class RevealNotReady extends StatelessWidget {
  final ConnectionModel connection;
  final Duration duration;

  final String submitTitle;
  final String cancelTitle;

  final VoidCallback onSubmit;
  final VoidCallback onCancel;

  const RevealNotReady({
    Key? key,
    required this.connection,
    required this.duration,
    required this.submitTitle,
    required this.cancelTitle,
    required this.onSubmit,
    required this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Div(
      [
        Div(
          [
            P(
              'You talked for ${duration.inMinutes} min with ${connection.member.givenName}, You need to at least 10 Min Conversation to reveal yourself',
              fg: colorOnSurfaceMediumEmphasis,
              isH6: true,
              ta: TextAlign.center,
            ),
          ],
        ),
        Div(
          [
            ConnectionPic(
              item: connection,
              w: avatarExtraLarge,
            ),
          ],
          mv: gapBottom,
        ),
        Div(
          [
            ProgressBarAlt(
              gutter: (gap * 3).toInt(),
              value: min(duration.inMilliseconds.toDouble(),
                  const Duration(minutes: 10).inMilliseconds.toDouble()),
              total: const Duration(minutes: 10).inMilliseconds.toDouble(),
            ),
          ],
          mb: gapBottom,
        ),
        Div(
          [
            Button(
              submitTitle,
              onPress: onSubmit,
            ),
          ],
          w: 160,
        ),
      ],
    );
  }
}
