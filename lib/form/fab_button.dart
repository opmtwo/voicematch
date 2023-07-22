import 'package:flutter/material.dart';
import 'package:voicematch/constants/colors.dart';

class FabButton extends StatelessWidget {
  final Widget child;

  final VoidCallback? onPress;

  final double? br;
  final double? brTr;
  final double? brBr;
  final double? brBl;
  final double? brTl;

  final Color? bc;
  final BorderStyle? bs;
  final double? bw;

  final Color? bg;
  final Color? fg;

  final double? w;
  final double? h;

  final double? mt;
  final double? mr;
  final double? mb;
  final double? ml;
  final double? mv;
  final double? mh;

  final Alignment? alignment;

  const FabButton(
    this.child, {
    Key? key,
    this.onPress,
    this.bc,
    this.bs,
    this.bw,
    this.br,
    this.brTr,
    this.brBr,
    this.brBl,
    this.brTl,
    this.bg,
    this.fg,
    this.w,
    this.h,
    this.mt,
    this.mr,
    this.mb,
    this.ml,
    this.mv,
    this.mh,
    this.alignment,
  }) : super(key: key);

  static const Color defaultBg = colorPrimary;
  static const Color defaultFg = colorWhite;

  static const double defaultRadius = 99;

  static const double defaultWidth = 48;
  static const double defaultHeight = 48;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: w ?? defaultWidth,
      height: h ?? defaultHeight,
      margin: EdgeInsets.only(
        top: mt ?? mv ?? 0,
        right: mr ?? mh ?? 0,
        bottom: mb ?? mv ?? 0,
        left: ml ?? mh ?? 0,
      ),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(brTr ?? br ?? defaultRadius),
          bottomRight: Radius.circular(brBr ?? br ?? defaultRadius),
          bottomLeft: Radius.circular(brBl ?? br ?? defaultRadius),
          topLeft: Radius.circular(brTl ?? br ?? defaultRadius),
        ),
        border: Border.all(
          color: bc ?? Colors.transparent,
          width: bw ?? 0,
          style: bs ?? BorderStyle.solid,
        ),
      ),
      child: Material(
        borderRadius: BorderRadius.circular(1000),
        color: bg ?? defaultBg,
        child: Center(
          child: InkWell(
            onTap: onPress,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(brTr ?? br ?? defaultRadius),
              bottomRight: Radius.circular(brBr ?? br ?? defaultRadius),
              bottomLeft: Radius.circular(brBl ?? br ?? defaultRadius),
              topLeft: Radius.circular(brTl ?? br ?? defaultRadius),
            ),
            child: SizedBox(
              width: w ?? defaultWidth,
              height: h ?? defaultHeight,
              child: Align(
                alignment: alignment ?? Alignment.center,
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
