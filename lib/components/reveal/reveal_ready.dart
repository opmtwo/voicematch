import 'package:flutter/material.dart';
import 'package:voicematch/components/connection_pic.dart';
import 'package:voicematch/components/logo.dart';
import 'package:voicematch/constants/colors.dart';
import 'package:voicematch/constants/theme.dart';
import 'package:voicematch/constants/types.dart';
import 'package:voicematch/elements/div.dart';
import 'package:voicematch/elements/p.dart';
import 'package:voicematch/form/button.dart';

class RevealReady extends StatelessWidget {
  final ConnectionModel connection;
  final Duration duration;

  final String submitTitle;
  final String cancelTitle;

  final VoidCallback onSubmit;
  final VoidCallback onCancel;

  const RevealReady({
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
    return Div([
      Div(
        [
          P(
            'Great! You talked for more than 10 Minutes. Would you like to reveal yourself fully?',
            fg: colorOnSurfaceMediumEmphasis,
            isH6: true,
            ta: TextAlign.center,
          ),
        ],
      ),
      Div(
        [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Div(
                [
                  ConnectionPic(
                    item: connection,
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
        pv: gapBottom,
      ),
      const Div(
        [
          P(
            'Show him those pretty teeths?',
            isH4: true,
            fg: colorBlack,
            ta: TextAlign.center,
          ),
        ],
        pb: gapBottom,
      ),
      Div(
        [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Div(
                [
                  Button(
                    submitTitle,
                    onPress: onSubmit,
                  ),
                ],
                w: 80,
              ),
              Div(
                [
                  Button(
                    cancelTitle,
                    onPress: onCancel,
                  ),
                ],
                w: 80,
              ),
            ],
          ),
        ],
      ),
    ]);
  }
}
