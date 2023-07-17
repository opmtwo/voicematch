import 'package:flutter/material.dart';
import 'package:voicematch/components/profile_pic.dart';
import 'package:voicematch/constants/types.dart';
import 'package:voicematch/elements/div.dart';

class ConnectionPic extends StatelessWidget {
  final ConnectionModel item;

  final double? w;
  final double? h;

  final bool? isUser;

  const ConnectionPic({
    Key? key,
    required this.item,
    this.w,
    this.h,
    this.isUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UserProfileModel? profile = isUser == true ? item.user : item.member;

    return Div(
      [
        if (profile?.pictureNormal != null)
          ProfilePic(
            src: profile?.pictureNormal as String,
            isLocal: false,
            w: w,
            h: h,
          ),
        if ((profile?.pictureNormal == null ||
                profile?.pictureNormal?.isEmpty == true) &&
            profile?.pictureMasked != null)
          ProfilePic(
            src: profile?.pictureMasked as String,
            isLocal: false,
            w: w,
            h: h,
          ),
        if ((profile?.pictureNormal == null ||
                profile?.pictureNormal?.isEmpty == true) &&
            (profile?.pictureMasked == null ||
                profile?.pictureMasked?.isEmpty == true))
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
