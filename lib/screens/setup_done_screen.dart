import 'dart:async';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/route_manager.dart';
import 'package:get/get.dart';
import 'package:voicematch/components/logo.dart';
import 'package:voicematch/constants/theme.dart';
import 'package:voicematch/elements/div.dart';
import 'package:voicematch/elements/p.dart';
import 'package:voicematch/form/button.dart';
import 'package:voicematch/form/progress_bar.dart';
import 'package:voicematch/layouts/app_layout.dart';
import 'package:voicematch/router.dart';

class SetupDoneScreen extends StatefulWidget {
  const SetupDoneScreen({Key? key}) : super(key: key);

  @override
  State<SetupDoneScreen> createState() => SetupDoneScreenState();
}

class SetupDoneScreenState extends State<SetupDoneScreen> {
  // error and busy
  String? error;
  bool? isBusy;

  // recording?
  bool isRecording = false;
  bool isRecorded = false;

  // recording path
  String? recordingPath;

  // timer
  Timer? timer;

  // recording duration
  Duration duration = const Duration(seconds: 0);

  @override
  void initState() {
    super.initState();
    initUser();
  }

  Future<void> initUser() async {
    EasyLoading.show(status: 'loading...');
    try {
      setState(() {
        //
      });
    } on AuthException catch (e) {
      safePrint('initUser- error - ${e.message}');
    }
    EasyLoading.dismiss();
  }

  void onBack() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppLayout(
        Div(
          [
            const Div(
              [
                ProgressBar(
                  value: 4 / 4,
                ),
              ],
              mv: gapBottom,
            ),
            Expanded(
              flex: 1,
              child: Div(
                [
                  const Div(
                    [
                      Logo(),
                    ],
                    mb: gap,
                  ),
                  Div(
                    [
                      Image.asset(
                        'assets/images/sign-up-done.png',
                        height: 200,
                      ),
                    ],
                    mv: gapBottom,
                  ),
                  const Div(
                    [
                      P(
                        'Congratulations',
                        isH5: true,
                        fw: FontWeight.w600,
                      ),
                    ],
                    mb: gap,
                  ),
                  const Div(
                    [
                      P(
                        'Now you are ready to listen to awesome people',
                        isBody1: true,
                      ),
                    ],
                    mv: gapBottom,
                  ),
                ],
                ph: gap,
              ),
            ),
            Div(
              [
                Div(
                  [
                    Button(
                      'next',
                      onPress: () {
                        Get.toNamed(Routes.matchesIndex);
                      },
                    ),
                  ],
                )
              ],
              ph: gap,
              pb: gapBottom,
            )
          ],
        ),
      ),
    );
  }
}
