import 'package:flutter/material.dart';
import 'package:voicematch/constants/colors.dart';

class P extends StatelessWidget {
  final String? text;
  final List<InlineSpan>? children;

  final TextStyle? style;

  final Color? bg;
  final Color? fg;

  final double? fz;
  final FontWeight? fw;
  final String? ff;
  final double? lh;
  final double? ls;
  final TextAlign? ta;
  final TextOverflow? ov;

  final bool? isH1;
  final bool? isH2;
  final bool? isH3;
  final bool? isH4;
  final bool? isH5;
  final bool? isH6;
  final bool? isBody1;
  final bool? isBody2;
  final bool? isSubtitle1;
  final bool? isSubtitle2;
  final bool? isButton;
  final bool? isCaption;
  final bool? isOverline;

  final int? lines;

  const P(
    this.text, {
    Key? key,
    this.children,
    this.style,
    this.bg,
    this.ff,
    this.fg,
    this.fz,
    this.fw,
    this.lh,
    this.ls,
    this.ta,
    this.ov,
    this.isH1,
    this.isH2,
    this.isH3,
    this.isH4,
    this.isH5,
    this.isH6,
    this.lines,
    this.isBody1,
    this.isBody2,
    this.isSubtitle1,
    this.isSubtitle2,
    this.isButton,
    this.isCaption,
    this.isOverline,
  }) : super(key: key);

  static const double defaultFontSize = 14;

  static const Color defaultBg = colorTransparent;
  static const Color defaultFg = colorGrey;

  static const TextAlign defaultTextAlign = TextAlign.left;

  static const FontWeight defaultFontWeight = FontWeight.normal;

  static const double deafultLineHeight = 1.3;

  @override
  Widget build(BuildContext context) {
    // bool isMini = MediaQueryUtils.isMini(MediaQuery.of(context));
    double? fontSize = defaultFontSize;
    double? lineHeight = deafultLineHeight;
    FontWeight? fontWeight = defaultFontWeight;

    if (isH1 == true) {
      fontSize = 96;
      lineHeight = 112 / fontSize;
      fontWeight = FontWeight.w300;
    }

    if (isH2 == true) {
      fontSize = 60;
      lineHeight = 72 / fontSize;
      fontWeight = FontWeight.w300;
    }

    if (isH3 == true) {
      fontSize = 48;
      lineHeight = 56 / fontSize;
      fontWeight = FontWeight.w400;
    }

    if (isH4 == true) {
      fontSize = 34;
      lineHeight = 36 / fontSize;
      fontWeight = FontWeight.w400;
    }

    if (isH5 == true) {
      fontSize = 24;
      lineHeight = 24 / fontSize;
      fontWeight = FontWeight.w400;
    }

    if (isH6 == true) {
      fontSize = 20;
      lineHeight = 24 / fontSize;
      fontWeight = FontWeight.w600;
    }

    if (isSubtitle1 == true) {
      fontSize = 16;
      lineHeight = 24 / fontSize;
      fontWeight = FontWeight.w400;
    }

    if (isSubtitle2 == true) {
      fontSize = 14;
      lineHeight = 24 / fontSize;
      fontWeight = FontWeight.w600;
    }

    if (isBody1 == true) {
      fontSize = 16;
      lineHeight = 24 / fontSize;
      fontWeight = FontWeight.w400;
    }

    if (isBody2 == true) {
      fontSize = 14;
      lineHeight = 20 / fontSize;
      fontWeight = FontWeight.w400;
    }

    if (isButton == true) {
      fontSize = 14;
      lineHeight = 16 / fontSize;
      fontWeight = FontWeight.w600;
    }

    if (isCaption == true) {
      fontSize = 12;
      lineHeight = 16 / fontSize;
      fontWeight = FontWeight.w400;
    }

    if (isOverline == true) {
      fontSize = 10;
      lineHeight = 16 / fontSize;
      fontWeight = FontWeight.w600;
    }

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Text.rich(
        maxLines: lines,
        overflow: ov,
        textAlign: ta ?? defaultTextAlign,
        TextSpan(
          text: text,
          children: children,
          style: TextStyle(
            decoration: TextDecoration.none,
            color: fg ?? defaultFg,
            fontFamily: ff,
            fontSize: fz ?? fontSize,
            fontWeight: fw ?? fontWeight,
            height: lh ?? lineHeight,
            letterSpacing: ls,
          ).merge(style),
        ),
      ),
    );
  }
}
