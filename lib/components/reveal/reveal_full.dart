import 'package:flutter/material.dart';
import 'package:voicematch/components/image_masked.dart';
import 'package:voicematch/components/logo.dart';
import 'package:voicematch/constants/colors.dart';
import 'package:voicematch/constants/theme.dart';
import 'package:voicematch/elements/div.dart';
import 'package:voicematch/elements/p.dart';
import 'package:voicematch/form/button.dart';

class RevealFull extends StatelessWidget {
  final Duration duration;

  final String submitTitle;
  final String cancelTitle;

  final VoidCallback onSubmit;
  final VoidCallback onCancel;

  const RevealFull({
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
              'Done! Mario can see you now and will get a notification that you revealed yourself.',
              fg: colorOnSurfaceMediumEmphasis,
              isH5: true,
              ta: TextAlign.center,
            ),
          ],
        ),
        Div(
          [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Div(
                  [
                    ImageMasked(
                      url: 'assets/images/avatar.png',
                      width: 80,
                    )
                  ],
                ),
                Div(
                  [
                    Logo(),
                  ],
                ),
                Div(
                  [
                    ImageMasked(
                      url: 'assets/images/avatar.png',
                      width: 80,
                    )
                  ],
                ),
              ],
            )
          ],
          mv: gapTop,
        ),
        Div(
          [
            P(
              'Show him those pretty teeths?',
              isH4: true,
              fg: colorBlack,
              ta: TextAlign.center,
            ),
          ],
          // ph: gap * 2,
        ),
        Div(
          [
            Button(
              'Continue',
            ),
          ],
          w: 160,
          mt: gapTop,
        ),
      ],
    );
  }
}
