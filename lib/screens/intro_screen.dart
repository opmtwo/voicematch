import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:voicematch/components/logo.dart';
import 'package:voicematch/constants/colors.dart';
import 'package:voicematch/constants/theme.dart';
import 'package:voicematch/elements/div.dart';
import 'package:voicematch/elements/p.dart';
import 'package:voicematch/form/button.dart';
import 'package:voicematch/layouts/app_layout.dart';
import 'package:voicematch/router.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  State<IntroScreen> createState() => IntroScreenState();
}

class IntroScreenState extends State<IntroScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/splash.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: AppLayout(
          isGuestOnly: true,
          bg: colorTransparent,
          Div(
            [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Div(
                      [
                        const Div(
                          [
                            Logo(),
                          ],
                        ),
                        const Div(
                          [
                            P(
                              'We are a small team want to change the superficial game of dating all over the world. We believe that there  are different ways and voice can help to elevate a deeper connection than anything else. ',
                              isBody1: true,
                              fg: colorWhite,
                              ta: TextAlign.center,
                            )
                          ],
                          mv: gapTop,
                        ),
                        Div(
                          [
                            Button(
                              'Join us on this journey!',
                              onPress: () {
                                Get.offNamedUntil(
                                  Routes.home,
                                  (route) => false,
                                );
                              },
                            ),
                          ],
                        )
                      ],
                      pv: gapBottom,
                      ph: gap,
                      brTl: radiusLarge,
                      brTr: radiusLarge,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
