import 'package:flutter/material.dart';
import 'package:voicematch/constants/colors.dart';
import 'package:voicematch/elements/div.dart';

class ProfilePic extends StatelessWidget {
  final String src;
  final bool? isLocal;

  final double? w;
  final double? h;

  const ProfilePic({
    Key? key,
    required this.src,
    this.isLocal,
    this.w,
    this.h,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double width = w ?? 48;
    final double height = h ?? w ?? 48;
    return ClipRRect(
      borderRadius: BorderRadius.circular(100),
      child: Div(
        [
          if (isLocal == false)
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Image.network(
                src,
                width: width,
                height: height,
              ),
            ),
          if (isLocal == true)
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Image.asset(
                src,
                width: width,
                height: height,
              ),
            ),
        ],
        w: width,
        h: height,
        bg: colorGrey200,
      ),
    );
  }
}
