import 'package:flutter/material.dart';
import 'package:voicematch/constants/colors.dart';
import 'package:voicematch/elements/div.dart';

class ProgressBar extends StatelessWidget {
  final double value;
  final String? title;

  final Color? bg;
  final Color? fg;

  final double? w;
  final double? h;

  final double? br;

  const ProgressBar({
    Key? key,
    required this.value,
    this.title,
    this.bg,
    this.fg,
    this.w,
    this.h,
    this.br,
  }) : super(key: key);

  final double defaultHeight = 4;

  final Color defaultBg = colorSeondary100;
  final Color defaultFg = colorSeondary500;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Stack(
          children: [
            Div(
              const [],
              h: h ?? defaultHeight,
              br: br,
            ),
            Positioned(
              top: 0,
              right: 0,
              bottom: 0,
              left: 0,
              child: Opacity(
                opacity: 0.4,
                child: Div(
                  const [],
                  bg: bg ?? defaultBg,
                  br: br,
                ),
              ),
            ),
            Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              width: value * MediaQuery.of(context).size.width,
              child: Div(
                const [],
                h: h ?? defaultHeight,
                bg: fg ?? defaultFg,
                br: br,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
