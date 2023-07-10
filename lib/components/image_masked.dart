import 'package:flutter/material.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';

class ImageMasked extends StatelessWidget {
  final String url;
  final double? width;
  final double? height;
  final double? sigmaX;
  final double? sigmaY;

  const ImageMasked({
    Key? key,
    required this.url,
    this.width,
    this.height,
    this.sigmaX,
    this.sigmaY,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(100),
      child: Stack(
        children: [
          Image.asset(
            url,
            width: width,
            height: height,
            fit: BoxFit.cover,
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: sigmaX != null ? sigmaX as double : 8,
                sigmaY: sigmaX != null ? sigmaY as double : 8,
              ),
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
