import 'dart:async';
import 'dart:convert';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/route_manager.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:voicematch/components/logo.dart';
import 'package:voicematch/constants/env.dart';
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
    // initUser();
  }

  Future<void> initUser() async {
    EasyLoading.show(status: 'loading...');
    try {
      setState(() {
        //
      });
    } catch (err) {
      safePrint('initUser- error - $err');
    }
    EasyLoading.dismiss();
  }

  void onBack() {
    Navigator.pop(context);
  }

  Future<void> onSubmit() async {
    await EasyLoading.show(status: 'loading...');
    try {
      // get access token
      final result = await Amplify.Auth.fetchAuthSession(
        options: CognitoSessionOptions(getAWSCredentials: true),
      ) as CognitoAuthSession;
      final accessToken = result.userPoolTokens?.accessToken;

      // update profile via oboard api
      final url = Uri.parse('${apiEndPoint}api/v1/onboard/done');
      safePrint('onSubmit - url $url');
      final response = await http.post(url, body: jsonEncode({}), headers: {
        'Authorization': accessToken.toString(),
      });
      safePrint('onSubmit - status code = ${response.statusCode}');

      // non 200 response code
      if (response.statusCode != 200) {
        throw Exception('Received non-200 status code: ${response.statusCode}');
      }

      // all done
      Get.toNamed(Routes.matchesIndex);
    } catch (err) {
      safePrint('onSubmit - error $err');
      setState(() {
        error = err.toString();
      });
    }
    await EasyLoading.dismiss();
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
                  value: 5 / 5,
                ),
              ],
              mt: gapTop,
            ),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Div(
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
                ],
              ),
            ),
            Div(
              [
                Div(
                  [
                    Button(
                      'start',
                      onPress: onSubmit,
                    ),
                  ],
                )
              ],
              ph: gap,
              pb: gapTop,
            )
          ],
        ),
      ),
    );
  }
}
