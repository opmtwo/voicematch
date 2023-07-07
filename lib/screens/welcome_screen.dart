import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:voicematch/components/welcome_slider.dart';
import 'package:voicematch/constants/colors.dart';
import 'package:voicematch/constants/theme.dart';
import 'package:voicematch/elements/div.dart';
import 'package:voicematch/form/button.dart';
import 'package:voicematch/layouts/app_layout.dart';
import 'package:voicematch/router.dart';

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
      Get.toNamed(Routes.intro);
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
                      Get.toNamed(Routes.intro);
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