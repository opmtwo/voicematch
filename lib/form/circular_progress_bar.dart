import 'package:flutter/material.dart';
import 'package:voicematch/constants/colors.dart';

class CircularProgressBar extends StatelessWidget {
  final double value;

  final Widget? caption;

  final double? w;
  final double? h;

  final Color? bg;
  final Color? fg;

  final double? bgBw;
  final double? fgBw;

  const CircularProgressBar({
    Key? key,
    required this.value,
    this.caption,
    this.w,
    this.h,
    this.bg,
    this.fg,
    this.bgBw,
    this.fgBw,
  }) : super(key: key);

  final double defaultW = 48;
  final double defaultH = 48;

  final Color defaultBg = colorGrey200;
  final Color defaultFg = colorSeondary200;

  final double defaultBw = 4.0;

  @override
  Widget build(BuildContext context) {
    final double width = w ?? defaultW;
    final double height = h ?? defaultH;

    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Transform.scale(
            scale: width / defaultW, // Adjust the scale based on width
            child: CircularProgressIndicator(
              value: 1,
              valueColor: AlwaysStoppedAnimation<Color>(bg ?? defaultBg),
              strokeWidth: bgBw ?? defaultBw,
            ),
          ),
          Transform.scale(
            scale: width / defaultW, // Adjust the scale based on width
            child: CircularProgressIndicator(
              value: value,
              valueColor: AlwaysStoppedAnimation<Color>(fg ?? defaultFg),
              strokeWidth: fgBw ?? defaultBw,
            ),
          ),
          if (caption != null)
            Positioned(
              child: caption!,
            )
        ],
      ),
    );
  }
}
