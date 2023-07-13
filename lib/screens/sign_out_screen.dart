import 'dart:developer';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:voicematch/components/logo.dart';
import 'package:voicematch/constants/colors.dart';
import 'package:voicematch/layouts/app_layout.dart';
import 'package:voicematch/router.dart';

class SignOutScreen extends StatefulWidget {
  const SignOutScreen({Key? key}) : super(key: key);

  @override
  State<SignOutScreen> createState() => SignOutScreenState();
}

class SignOutScreenState extends State<SignOutScreen> {
  @override
  void initState() {
    super.initState();
    signOut();
  }

  Future<void> signOut() async {
    await EasyLoading.show(status: 'Loading');
    try {
      await Amplify.Auth.signOut();
    } catch (err) {
      log('signOut - error - $err');
    }
    Get.offNamedUntil(Routes.signIn, (route) => false);
    await EasyLoading.dismiss();
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
          bg: colorTransparent,
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Logo(),
            ],
          ),
        ),
      ),
    );
  }
}
