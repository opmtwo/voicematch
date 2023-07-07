import 'package:flutter/material.dart';

class Div extends StatelessWidget {
  final List<Widget> children;

  final Decoration? style;
  final Alignment? alignment;

  final double? w;
  final double? h;

  final double? mt;
  final double? mr;
  final double? mb;
  final double? ml;
  final double? mv;
  final double? mh;

  final double? pt;
  final double? pr;
  final double? pb;
  final double? pl;
  final double? pv;
  final double? ph;

  final double? bw;
  final Color? bc;
  final BorderStyle? bs;

  final Color? bg;
  final Gradient? gradient;
  final List<BoxShadow>? shadow;
  final DecorationImage? image;

  final double? br;
  final double? brTr;
  final double? brBr;
  final double? brBl;
  final double? brTl;

  const Div(
    this.children, {
    Key? key,
    this.style,
    this.alignment,
    this.w,
    this.h,
    this.mt,
    this.mr,
    this.mb,
    this.ml,
    this.mv,
    this.mh,
    this.pt,
    this.pr,
    this.pb,
    this.pl,
    this.pv,
    this.ph,
    this.bg,
    this.gradient,
    this.shadow,
    this.image,
    this.bw,
    this.bc,
    this.bs,
    this.br,
    this.brTr,
    this.brBr,
    this.brBl,
    this.brTl,
  }) : super(key: key);

  static double marginVertical = 0;
  static double marginHorizontal = 0;

  static double paddingVertical = 0;
  static double paddingHorizontal = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: w,
      height: h,
      margin: EdgeInsets.only(
        top: mt ?? mv ?? marginVertical,
        right: mr ?? mh ?? marginHorizontal,
        bottom: mb ?? mv ?? marginVertical,
        left: ml ?? mh ?? marginHorizontal,
      ),
      padding: EdgeInsets.only(
        top: pt ?? pv ?? paddingVertical,
        right: pr ?? ph ?? paddingHorizontal,
        bottom: pb ?? pv ?? paddingVertical,
        left: pl ?? ph ?? paddingHorizontal,
      ),
      alignment: alignment,
      decoration: BoxDecoration(
        boxShadow: shadow,
        color: bg,
        gradient: gradient,
        image: image,
        border: Border.all(
          color: bc ?? Colors.transparent,
          width: bw ?? 0,
          style: bs ?? BorderStyle.solid,
        ),
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(brTr ?? br ?? 0),
          bottomRight: Radius.circular(brBr ?? br ?? 0),
          bottomLeft: Radius.circular(brBl ?? br ?? 0),
          topLeft: Radius.circular(brTl ?? br ?? 0),
        ),
      ),
      child: Column(
        children: children,
      ),
    );
  }
}
