import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:voicematch/constants/colors.dart';
import 'package:voicematch/constants/theme.dart';
import 'package:voicematch/elements/div.dart';
import 'package:voicematch/elements/p.dart';

class AppLinks extends StatelessWidget {
  final String? privacy = '';
  final String? terms = '';

  const AppLinks({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const TextStyle style = TextStyle(
      color: colorWhite,
      fontSize: 11,
      fontWeight: FontWeight.w600,
    );

    return Div(
      [
        Div(
          [
            P(
              'About us'.toUpperCase(),
              fg: colorWhite,
              fw: FontWeight.w600,
            ),
          ],
          mb: gap / 2,
        ),
        RichText(
          // textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              TextSpan(
                text: 'By signing up, you agree to our '.toUpperCase(),
                style: style,
              ),
              TextSpan(
                text: 'Terms'.toUpperCase(),
                style: style.copyWith(color: colorPrimary),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    // Handle Terms tap
                    // print('Terms tapped');
                    try {
                      launchUrl(
                        Uri.parse('https://www.voicematch.com/terms/'),
                        mode: LaunchMode.platformDefault,
                      );
                    } catch (e) {
                      // safePrint('onBack - error - $e');
                    }
                  },
              ),
              TextSpan(
                text: '. See how we use your data in our '.toUpperCase(),
                style: style,
              ),
              TextSpan(
                text: 'Privacy policy'.toUpperCase(),
                style: style.copyWith(color: colorPrimary),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    // Handle Privacy Policy tap
                    // print('Privacy Policy tapped');
                    try {
                      launchUrl(
                        Uri.parse('https://www.voicematch.com/privacy/'),
                        mode: LaunchMode.platformDefault,
                      );
                    } catch (e) {
                      // safePrint('onBack - error - $e');
                    }
                  },
              ),
              TextSpan(
                text: '. We never post on Facebook.'.toUpperCase(),
                style: style,
              ),
            ],
          ),
        ),
      ],
      ph: gap * 2,
    );
  }
}
