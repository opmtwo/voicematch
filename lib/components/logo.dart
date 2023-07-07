import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  final double? w;
  final double? h;

  const Logo({Key? key, this.w, this.h}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/logo.png',
      width: w ?? (h == null ? 80 : null),
      height: h,
    );
  }
}
