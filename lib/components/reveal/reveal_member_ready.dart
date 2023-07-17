import 'package:flutter/material.dart';
import 'package:voicematch/components/connection_pic.dart';
import 'package:voicematch/components/logo.dart';
import 'package:voicematch/constants/colors.dart';
import 'package:voicematch/constants/theme.dart';
import 'package:voicematch/constants/types.dart';
import 'package:voicematch/elements/div.dart';
import 'package:voicematch/elements/p.dart';
import 'package:voicematch/form/button.dart';

class RevealMemberReady extends StatelessWidget {
  final ConnectionModel connection;
  final Duration duration;

  final String submitTitle;
  final String cancelTitle;

  final VoidCallback onSubmit;
  final VoidCallback onCancel;

  const RevealMemberReady({
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
            'Done! ${connection.member.givenName} can see you now and will get a notification that you revealed yourself.',
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
        pv: gapTop * 2,
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
    ]);
  }
}
