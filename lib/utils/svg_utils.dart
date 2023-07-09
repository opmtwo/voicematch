import 'package:flutter/material.dart';

class PercentageClipper extends CustomClipper<Path> {
  final double percent;

  PercentageClipper({required this.percent});

  @override
  Path getClip(Size size) {
    final path = Path();
    final clipWidth = size.width * (1 - percent / 100);

    path.moveTo(0, 0);
    path.lineTo(clipWidth, 0);
    path.lineTo(clipWidth, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(PercentageClipper oldClipper) =>
      percent != oldClipper.percent;
}
