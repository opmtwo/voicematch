import 'package:flutter/material.dart';
import 'package:voicematch/components/profile_pic.dart';
import 'package:voicematch/constants/types.dart';
import 'package:voicematch/elements/div.dart';

class ConnectionPic extends StatelessWidget {
  final ConnectionModel item;
  final double? w;
  final double? h;

  const ConnectionPic({
    Key? key,
    required this.item,
    this.w,
    this.h,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Div(
      [
        if (item.member.pictureNormal != null)
          ProfilePic(
            src: item.member.pictureNormal as String,
            isLocal: false,
            w: w,
            h: h,
          ),
        if (item.member.pictureNormal?.isEmpty == true &&
            item.member.pictureMasked != null)
          ProfilePic(
            src: item.member.pictureMasked as String,
            isLocal: false,
            w: w,
            h: h,
          ),
        if (item.member.pictureNormal?.isEmpty == true &&
            item.member.pictureMasked?.isEmpty == true)
          ProfilePic(
            src: 'assets/images/avatar.png',
            isLocal: true,
            w: w,
            h: h,
          ),
      ],
    );
  }
}
