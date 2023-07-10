import 'package:flutter/material.dart';
import 'package:voicematch/components/image_masked.dart';
import 'package:voicematch/constants/colors.dart';
import 'package:voicematch/constants/theme.dart';
import 'package:voicematch/elements/div.dart';
import 'package:voicematch/elements/p.dart';
import 'package:voicematch/form/button.dart';
import 'package:voicematch/form/progress_bar_alt.dart';

class RevealNotReady extends StatelessWidget {
  final Duration duration;

  final String submitTitle;
  final String cancelTitle;

  final VoidCallback onSubmit;
  final VoidCallback onCancel;

  const RevealNotReady({
    Key? key,
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
              'You talked for ${duration.inMinutes} min with Mario, You need to at least 10 Min Conversation to reveal yourself',
              fg: colorOnSurfaceMediumEmphasis,
              isH5: true,
              ta: TextAlign.center,
            ),
          ],
          mv: gap,
        ),
        Div(
          [
            ImageMasked(
              url: 'assets/images/avatar.png',
              width: 160,
              height: 160,
            ),
          ],
          br: 99,
        ),
        Div(
          [
            ProgressBarAlt(
              gutter: (gap * 3).toInt(),
              value: 10 * 1000,
              total: const Duration(seconds: 10).inMilliseconds.toDouble(),
            ),
          ],
          mt: gapTop,
          mb: gap,
        ),
        Div(
          [
            Button(
              'Continue',
            ),
          ],
          w: 160,
        ),
      ],
    );
  }
}
