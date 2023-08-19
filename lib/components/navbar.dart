import 'dart:developer';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:voicevibe/constants/colors.dart';
import 'package:voicevibe/constants/theme.dart';
import 'package:voicevibe/elements/div.dart';
import 'package:voicevibe/elements/p.dart';
import 'package:voicevibe/icons/icon_home.dart';
import 'package:voicevibe/icons/icon_settings.dart';
import 'package:voicevibe/icons/icon_sign_out.dart';
import 'package:voicevibe/router.dart';

class Navbar extends StatelessWidget {
  final int? index;

  const Navbar({Key? key, this.index}) : super(key: key);

  static List<Map> options = [
    {
      'url': Routes.matchesIndex,
      'title': 'Home',
      'icon': iconHome(),
      'width': 16.0,
    },
    {
      'url': Routes.profile,
      'title': 'Settings',
      'icon': iconSettings(),
      'width': 16.0,
    },
    {
      'url': Routes.signOut,
      'title': 'Sign out',
      'icon': iconSignOut(),
      'width': 14.0,
      'onPress': () async {
        await EasyLoading.show(status: 'Loading');
        try {
          await Amplify.Auth.signOut();
        } catch (err) {
          log('signOut - error - $err');
        }
        Get.offNamedUntil(Routes.signIn, (route) => false);
        EasyLoading.dismiss();
      }
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Div(
      [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(
            options.length,
            (i) {
              var data = options[i];
              bool isActive = i == index;
              void onTap() {
                if (data['onPress'] != null) {
                  data['onPress']();
                } else {
                  Get.toNamed(
                    data['url'],
                  );
                }
              }

              return Column(
                children: [
                  GestureDetector(
                    onTap: onTap,
                    child: Div(
                      [
                        Opacity(
                          opacity: isActive ? 1 : 1,
                          child: SvgPicture.string(
                            data['icon'],
                            color: isActive ? colorSeondary200 : colorGrey900,
                            width: data['width'],
                          ),
                        ),
                        Opacity(
                          opacity: isActive ? 1 : 1,
                          child: Div(
                            [
                              P(
                                data["title"],
                                isCaption: true,
                                fw: FontWeight.w600,
                                fg: isActive ? colorSeondary200 : colorGrey900,
                              ),
                            ],
                            mv: 5,
                          ),
                        )
                      ],
                    ),
                  ),
                  Div(
                    [
                      Opacity(
                        opacity: isActive ? 1 : 0,
                        child: const Div(
                          [],
                          bg: colorSeondary200,
                          w: 5,
                          h: 5,
                          br: 99,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ],
      pv: gap,
      ph: gap,
      bg: colorWhite,
      brTr: radiusLarge,
      brTl: radiusLarge,
      shadow: [
        BoxShadow(
          blurRadius: 10,
          color: colorBlack.withOpacity(0.1),
          spreadRadius: 1,
        ),
      ],
    );
  }
}
