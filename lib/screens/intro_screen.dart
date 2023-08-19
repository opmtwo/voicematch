import 'package:flutter/material.dart';
import 'package:voicevibe/components/logo.dart';
import 'package:voicevibe/constants/colors.dart';
import 'package:voicevibe/constants/theme.dart';
import 'package:voicevibe/elements/div.dart';
import 'package:voicevibe/elements/p.dart';
import 'package:voicevibe/form/button.dart';
import 'package:voicevibe/layouts/app_layout.dart';
import 'package:voicevibe/utils/user_utils.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  State<IntroScreen> createState() => IntroScreenState();
}

class IntroScreenState extends State<IntroScreen> {
  Future<void> onSubmit() async {
    await redirectUser();
  }

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
                              onPress: onSubmit,
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
