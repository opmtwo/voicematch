import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:voicevibe/components/welcome_slider.dart';
import 'package:voicevibe/constants/colors.dart';
import 'package:voicevibe/constants/theme.dart';
import 'package:voicevibe/elements/div.dart';
import 'package:voicevibe/form/button.dart';
import 'package:voicevibe/layouts/app_layout.dart';
import 'package:voicevibe/router.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => WelcomeScreenState();
}

class WelcomeScreenState extends State<WelcomeScreen> {
  int index = 0;

  void onContinue(int newIndex) {
    // make sure not to navigate by mistake
    if (Get.currentRoute.startsWith('/welcome') != true) {
      return;
    }
    if (newIndex == 0 && index == 2) {
      Get.toNamed(Routes.signIn);
      return;
    }
    setState(() {
      index = newIndex.abs() % 3;
    });
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
                flex: 1,
                child: Stack(
                  children: [
                    Div(
                      [
                        WelcomeSlider(
                          index: index,
                          length: 3,
                          onContinue: onContinue,
                        )
                      ],
                    )
                  ],
                ),
              ),
              Div(
                [
                  Button(
                    'Continue',
                    onPress: () {
                      Get.toNamed(Routes.signIn);
                    },
                  )
                ],
                ph: gap,
                pb: gapTop,
              )
            ],
          ),
        ),
      ),
    );
  }
}
