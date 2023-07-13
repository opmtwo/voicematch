import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:voicematch/constants/colors.dart';
import 'package:voicematch/constants/theme.dart';
import 'package:voicematch/elements/div.dart';
import 'package:voicematch/elements/p.dart';
import 'package:voicematch/icons/icon_home.dart';
import 'package:voicematch/icons/icon_settings.dart';
import 'package:voicematch/icons/icon_sign_out.dart';
import 'package:voicematch/router.dart';

class Navbar extends StatelessWidget {
  final int? index;

  const Navbar({Key? key, this.index}) : super(key: key);

  static List<Map> options = [
    {
      'url': Routes.matchesIndex,
      'title': 'Home',
      'icon': iconHome(),
      'width': 20.0,
    },
    {
      'url': Routes.profile,
      'title': 'Settings',
      'icon': iconSettings(),
      'width': 20.0,
    },
    {
      'url': Routes.signOut,
      'title': 'Sign out',
      'icon': iconSignOut(),
      'width': 20.0,
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
                Get.toNamed(
                  data['url'],
                );
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
                            color: isActive ? colorWhite : colorSeondary500,
                            width: data['width'],
                          ),
                        ),
                        Opacity(
                          opacity: isActive ? 1 : 1,
                          child: Div(
                            [
                              P(
                                data["title"],
                                fw: FontWeight.w600,
                                fg: isActive ? colorWhite : colorSeondary500,
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
                          bg: colorWhite,
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
      pv: gapHorizontal,
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
