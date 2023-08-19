import 'package:flutter/material.dart';
import 'package:voicevibe/constants/colors.dart';

class Button extends StatelessWidget {
  final String child;

  final VoidCallback? onPress;

  final IconData? iconLeft;
  final IconData? iconRight;

  final Widget? textLeft;
  final Widget? textRight;

  final double? height;

  final double? mt;
  final double? mr;
  final double? mb;
  final double? ml;
  final double? mv;
  final double? mh;

  final double? br;
  final double? brTr;
  final double? brBr;
  final double? brBl;
  final double? brTl;

  final Color? bg;
  final Color? fg;

  final Color? iconBg;
  final Color? iconFg;

  final Color? bc;
  final double? bw;

  final double? fz;
  final FontWeight? fw;

  final double? ls;

  final List<BoxShadow>? boxShadow;

  static const double defaultHeight = 56;
  static const double defaultRadius = 99;

  static const Color defaultBg = colorPrimary;
  static const Color defaultFg = colorWhite;

  static const Color defaultIconBg = colorTransparent;
  static const Color defaultIconFg = colorWhite;

  static const double deafultFontSize = 14;
  static const FontWeight defaultFontWeight = FontWeight.w600;

  const Button(
    this.child, {
    Key? key,
    this.onPress,
    this.iconLeft,
    this.iconRight,
    this.textLeft,
    this.textRight,
    this.height,
    this.br,
    this.brTr,
    this.brBr,
    this.brBl,
    this.brTl,
    this.mt,
    this.mr,
    this.mb,
    this.ml,
    this.mv,
    this.mh,
    this.boxShadow,
    this.bg,
    this.fg,
    this.bc,
    this.bw,
    this.fw,
    this.fz,
    this.ls,
    this.iconBg,
    this.iconFg,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Container(
        margin: EdgeInsets.only(
          top: mt ?? mv ?? 0,
          right: mr ?? mh ?? 0,
          bottom: mb ?? mv ?? 0,
          left: ml ?? mh ?? 0,
        ),
        decoration: BoxDecoration(
          color: bg ?? defaultBg,
          border: Border.all(
            color:
                bc ?? Colors.transparent, //                   <--- border color
            width: bw ?? 0,
          ),
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(brTr ?? br ?? defaultRadius),
            bottomRight: Radius.circular(brBr ?? br ?? defaultRadius),
            bottomLeft: Radius.circular(brBl ?? br ?? defaultRadius),
            topLeft: Radius.circular(brTl ?? br ?? defaultRadius),
          ),
          boxShadow: boxShadow,
        ),
        child: SizedBox(
          height: height ?? defaultHeight,
          child: Stack(
            children: [
              Row(
                children: <Widget>[
                  Container(
                    width: iconLeft != null ? height ?? defaultHeight : 0,
                    height: height ?? defaultHeight,
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      color: iconBg ?? defaultIconBg,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(brTr ?? br ?? defaultRadius),
                        bottomRight:
                            Radius.circular(brBr ?? br ?? defaultRadius),
                        bottomLeft:
                            Radius.circular(brBl ?? br ?? defaultRadius),
                        topLeft: Radius.circular(brTl ?? br ?? defaultRadius),
                      ),
                    ),
                    child: Center(
                      child: Icon(iconLeft, color: iconFg ?? defaultIconFg),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    fit: FlexFit.loose,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        textLeft ?? const Text(''),
                        const SizedBox(width: 5),
                        Text.rich(
                          TextSpan(
                            text: child.toUpperCase(),
                            style: TextStyle(
                              decoration: TextDecoration.none,
                              fontSize: fz ?? deafultFontSize,
                              fontWeight: fw ?? defaultFontWeight,
                              color: fg ?? defaultFg,
                              letterSpacing: ls ?? 1.25,
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                        textRight ?? const Text(''),
                      ],
                    ),
                  ),
                  Container(
                    width: iconRight != null ? height ?? defaultHeight : 0,
                    height: height ?? defaultHeight,
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      color: iconBg ?? defaultIconBg,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(brTr ?? br ?? defaultRadius),
                        bottomRight:
                            Radius.circular(brBr ?? br ?? defaultRadius),
                        bottomLeft:
                            Radius.circular(brBl ?? br ?? defaultRadius),
                        topLeft: Radius.circular(brTl ?? br ?? defaultRadius),
                      ),
                    ),
                    child: Center(
                      child: Icon(iconRight, color: iconFg ?? defaultIconFg),
                    ),
                  ),
                ],
              ),
              Material(
                type: MaterialType.transparency,
                child: InkWell(
                  onTap: onPress,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(brTr ?? br ?? defaultRadius),
                    bottomRight: Radius.circular(brBr ?? br ?? defaultRadius),
                    bottomLeft: Radius.circular(brBl ?? br ?? defaultRadius),
                    topLeft: Radius.circular(brTl ?? br ?? defaultRadius),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
