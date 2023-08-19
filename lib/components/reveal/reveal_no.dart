import 'package:flutter/material.dart';
import 'package:voicevibe/components/connection_pic.dart';
import 'package:voicevibe/components/logo.dart';
import 'package:voicevibe/constants/colors.dart';
import 'package:voicevibe/constants/theme.dart';
import 'package:voicevibe/constants/types.dart';
import 'package:voicevibe/elements/div.dart';
import 'package:voicevibe/elements/p.dart';
import 'package:voicevibe/form/button.dart';

class RevealNo extends StatelessWidget {
  final ConnectionModel connection;
  final Duration duration;

  final String submitTitle;
  final String cancelTitle;

  final VoidCallback onSubmit;
  final VoidCallback onCancel;

  const RevealNo({
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
              'OK got it, you got another 10 Min to get to know each other!',
              fg: colorOnSurfaceMediumEmphasis,
              isH6: true,
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
                    ConnectionPic(
                      item: connection,
                      isUser: true,
                      w: avatarMedium,
                    ),
                  ],
                ),
                const Div(
                  [
                    Logo(),
                  ],
                ),
                Div(
                  [
                    ConnectionPic(
                      item: connection,
                      w: avatarMedium,
                    ),
                  ],
                ),
              ],
            )
          ],
          mv: gapTop * 2,
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
