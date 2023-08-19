import 'package:flutter/material.dart';
import 'package:voicevibe/components/connection_pic.dart';
import 'package:voicevibe/components/logo.dart';
import 'package:voicevibe/constants/colors.dart';
import 'package:voicevibe/constants/theme.dart';
import 'package:voicevibe/constants/types.dart';
import 'package:voicevibe/elements/div.dart';
import 'package:voicevibe/elements/p.dart';
import 'package:voicevibe/form/button.dart';

class RevealUserReady extends StatelessWidget {
  final ConnectionModel connection;
  final Duration duration;

  final String submitTitle;
  final String cancelTitle;

  final VoidCallback onSubmit;
  final VoidCallback onCancel;

  const RevealUserReady({
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
            'Great! You talked for another 10 Minutes. Would you like to reveal yourself fully?',
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
        pv: gapBottom,
      ),
      const Div(
        [
          P(
            'Ready or not, here I come..\nor not?',
            isH5: true,
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
