import 'package:flutter/material.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:voicematch/components/header.dart';
import 'package:voicematch/components/reveal/reveal_done.dart';
import 'package:voicematch/components/reveal/reveal_full.dart';
import 'package:voicematch/components/reveal/reveal_half.dart';
import 'package:voicematch/components/reveal/reveal_not_ready.dart';
import 'package:voicematch/components/reveal/reveal_ready.dart';
import 'package:voicematch/constants/colors.dart';
import 'package:voicematch/constants/theme.dart';
import 'package:voicematch/elements/div.dart';

class Reveal extends StatelessWidget {
  final Duration duration;

  final bool isUserHalfRevealed;
  final bool isUserFullRevealed;

  final bool isMemberHalfRevealed;
  final bool isMemberFullRevealed;

  final List<Widget> header;

  final Color? bg = colorWhite;

  final VoidCallback onPrev;

  final String submitTitle;
  final VoidCallback onSubmit;

  final String cancelTitle;
  final VoidCallback onCancel;

  final String yesTitle;
  final VoidCallback onYes;

  final String noTitle;
  final VoidCallback onNo;

  const Reveal({
    Key? key,
    required this.duration,
    required this.isUserHalfRevealed,
    required this.isUserFullRevealed,
    required this.isMemberHalfRevealed,
    required this.isMemberFullRevealed,
    required this.header,
    required this.submitTitle,
    required this.cancelTitle,
    required this.yesTitle,
    required this.noTitle,
    required this.onPrev,
    required this.onSubmit,
    required this.onCancel,
    required this.onYes,
    required this.onNo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/splash.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 9,
          sigmaY: 9,
        ),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Div(
              [
                Header(
                  bg: colorWhite,
                  hasPrev: true,
                  onPrev: onPrev,
                  children: header,
                ),
              ],
              pt: gapTop,
              bg: colorWhite,
            ),
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Div(
                    [
                      Div(
                        [
                          if (duration.inMinutes < 10)
                            RevealNotReady(
                              duration: duration,
                              submitTitle: 'Continue',
                              cancelTitle: 'Cancel',
                              onSubmit: onSubmit,
                              onCancel: onCancel,
                            ),
                          if (duration.inMinutes > 10 &&
                              isUserHalfRevealed != true)
                            RevealReady(
                              duration: duration,
                              submitTitle: 'Yes',
                              cancelTitle: 'No',
                              onSubmit: onSubmit,
                              onCancel: onCancel,
                            ),
                          if (duration.inMinutes > 10 &&
                              duration.inMinutes < 20 &&
                              isUserHalfRevealed == true &&
                              isUserFullRevealed == false)
                            RevealHalf(
                              duration: duration,
                              submitTitle: 'Yes',
                              cancelTitle: 'No',
                              onSubmit: onSubmit,
                              onCancel: onCancel,
                            ),
                          if (duration.inMinutes > 20 &&
                              isUserFullRevealed != true)
                            RevealHalf(
                              duration: duration,
                              submitTitle: 'Yes',
                              cancelTitle: 'No',
                              onSubmit: onSubmit,
                              onCancel: onCancel,
                            ),
                          if (isUserHalfRevealed == true &&
                              isUserFullRevealed == true &&
                              isMemberFullRevealed != true)
                            RevealFull(
                              duration: duration,
                              submitTitle: 'Yes',
                              cancelTitle: 'No',
                              onSubmit: onSubmit,
                              onCancel: onCancel,
                            ),
                          if (isUserHalfRevealed == true &&
                              isUserFullRevealed == true &&
                              isMemberFullRevealed == true)
                            RevealDone(
                              duration: duration,
                              submitTitle: 'Yes',
                              cancelTitle: 'No',
                              onSubmit: onSubmit,
                              onCancel: onCancel,
                            ),
                        ],
                        ph: gap,
                        pv: gapTop,
                        bg: colorWhite,
                        br: radiusLarge,
                      ),
                    ],
                    pb: gap,
                    ph: gap / 2,
                    shadow: [
                      BoxShadow(
                        color: colorBlack.withOpacity(0.1),
                        blurRadius: 50,
                        spreadRadius: 25,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
