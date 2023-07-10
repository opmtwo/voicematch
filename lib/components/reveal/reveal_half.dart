import 'package:flutter/material.dart';
import 'package:voicematch/components/image_masked.dart';
import 'package:voicematch/components/logo.dart';
import 'package:voicematch/constants/colors.dart';
import 'package:voicematch/constants/theme.dart';
import 'package:voicematch/elements/div.dart';
import 'package:voicematch/elements/p.dart';
import 'package:voicematch/form/button.dart';

class RevealHalf extends StatelessWidget {
  final Duration duration;

  final String submitTitle;
  final String cancelTitle;

  final VoidCallback onSubmit;
  final VoidCallback onCancel;

  const RevealHalf({
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
              'Great! You talked for another 10 Minutes. Would you like to reveal yourself fully?',
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Div(
                  [
                    Button(
                      'Yes',
                    ),
                  ],
                  w: 80,
                ),
                Div(
                  [
                    Button(
                      'No',
                    ),
                  ],
                  w: 80,
                ),
              ],
            ),
          ],
          mt: gapTop,
        ),
      ],
    );
  }
}
