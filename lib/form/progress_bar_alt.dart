import 'package:flutter/material.dart';
import 'package:voicematch/components/icon_box.dart';
import 'package:voicematch/constants/colors.dart';
import 'package:voicematch/constants/theme.dart';
import 'package:voicematch/elements/div.dart';
import 'package:voicematch/form/progress_bar.dart';

class ProgressBarAlt extends StatelessWidget {
  final double total;
  final double value;
  final Color? trackBg;
  final Color? trackFg;
  final Color? thumbBg = colorSeondary050;
  final Color? thumbFg = colorSeondary500;

  const ProgressBarAlt({
    Key? key,
    required this.value,
    required this.total,
    this.trackBg,
    this.trackFg,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: const [
            Div(
              [],
              h: 40,
            ),
          ],
        ),
        Div([
          ProgressBar(
            value: value / total,
            h: 4,
            gutter: (gap * 2).toInt(),
            bg: trackBg,
            fg: trackFg,
            br: radius,
          ),
        ], pt: 18),
        Positioned(
          top: 0,
          left: value /
              total *
              (MediaQuery.of(context).size.width - (gap * 2) - 40),
          child: IconBox(
            const Div([]),
            w: 40,
            h: 40,
            bg: thumbBg,
          ),
        ),
        Positioned(
          top: 10,
          left: value /
                  total *
                  (MediaQuery.of(context).size.width -
                      (gap * 2) - // gap on both sides
                      40) + // circle width
              10, // shift center circle to center of parent circle
          child: IconBox(
            const Div([]),
            w: 20,
            h: 20,
            bg: thumbFg,
          ),
        ),
      ],
    );
  }
}
