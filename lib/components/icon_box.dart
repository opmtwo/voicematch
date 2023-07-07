import 'package:flutter/material.dart';
import 'package:voicematch/elements/div.dart';

class IconBox extends StatelessWidget {
  final Widget child;
  final double? w;
  final double? h;
  final Color? bg;
  final double? br;

  const IconBox(
    this.child, {
    Key? key,
    this.w,
    this.h,
    this.bg,
    this.br,
  }) : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return Div(
      [
        Flexible(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [child],
          ),
        )
      ],
      w: w ?? h ?? 24,
      h: h ?? w ?? 24,
      bg: bg,
      br: br ?? 999,
    );
  }
}
