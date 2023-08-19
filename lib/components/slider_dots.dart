import 'package:flutter/material.dart';
import 'package:voicevibe/constants/colors.dart';
import 'package:voicevibe/elements/div.dart';

class SliderDots extends StatelessWidget {
  final int total;
  final int index;

  final double? w;
  final double? h;

  const SliderDots({
    Key? key,
    required this.index,
    required this.total,
    this.w,
    this.h,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        for (var i = 0; i < total; i++)
          Div(
            const [],
            w: w ?? 12,
            h: h ?? 12,
            br: 12,
            mh: 6,
            bg: index == i ? colorPrimary : const Color(0xFFD9D9D9),
          )
      ],
    );
  }
}
