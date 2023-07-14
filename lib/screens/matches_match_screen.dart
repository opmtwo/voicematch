import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/route_manager.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:voicematch/components/connection_pic.dart';
import 'package:voicematch/components/connection_tags.dart';
import 'package:voicematch/components/logo.dart';
import 'package:voicematch/constants/colors.dart';
import 'package:voicematch/constants/env.dart';
import 'package:voicematch/constants/theme.dart';
import 'package:voicematch/constants/types.dart';
import 'package:voicematch/elements/div.dart';
import 'package:voicematch/elements/p.dart';
import 'package:voicematch/form/button.dart';
import 'package:voicematch/layouts/app_layout.dart';
import 'package:voicematch/router.dart';

class MatchesMatchScreen extends StatefulWidget {
  const MatchesMatchScreen({Key? key}) : super(key: key);

  @override
  State<MatchesMatchScreen> createState() => MatchesMatchScreenState();
}

class MatchesMatchScreenState extends State<MatchesMatchScreen> {
  // error and busy
  String? error;
  bool? isBusy;

  // match connection id
  late String id;

  // connection
  ConnectionModel? activeItem;

  @override
  void initState() {
    super.initState();
    setState(() {
      id = Get.arguments['id'] as String;
    });
    getConnection();
  }

  Future<void> getConnection() async {
    await EasyLoading.show(status: 'loading...');
    try {
      // get access token
      final result = await Amplify.Auth.fetchAuthSession(
        options: CognitoSessionOptions(getAWSCredentials: true),
      ) as CognitoAuthSession;
      final accessToken = result.userPoolTokens?.accessToken;

      // update profile via oboard api
      final url = Uri.parse('${apiEndPoint}api/v1/connections/$id');
      safePrint('getConnection - url $url');
      final response = await http.get(url, headers: {
        'Authorization': accessToken.toString(),
      });
      safePrint('getConnection - status code = ${response.statusCode}');

      // non 200 response code
      if (response.statusCode != 200) {
        throw Exception('getConnection - non-200 code: ${response.statusCode}');
      }

      // decode response
      final json = await jsonDecode(response.body);
      log('getConnection - json - ${response.body}');

      // update state
      setState(() {
        activeItem = ConnectionModel.fromJson(json);
      });
    } catch (err) {
      safePrint('getConnection- error - $err');
    }
    await EasyLoading.dismiss();
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
              [],
              mt: gapTop,
            ),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (activeItem?.id.isNotEmpty == true)
                    Div(
                      [
                        const Div(
                          [
                            Logo(),
                          ],
                          mb: gap,
                        ),
                        const Div(
                          [
                            P(
                              'Congratulations',
                              isH5: true,
                              fw: FontWeight.w600,
                            ),
                          ],
                          mb: gap / 2,
                        ),
                        const Div(
                          [
                            P(
                              'You have a match',
                              isBody1: true,
                              fw: FontWeight.w600,
                            ),
                          ],
                        ),
                        Div(
                          [
                            ConnectionPic(
                              item: activeItem as ConnectionModel,
                              w: avatarExtraLarge,
                            ),
                          ],
                          mv: gap,
                          br: 99,
                          shadow: [
                            BoxShadow(
                              color: colorBlack.withOpacity(0.1),
                              spreadRadius: 10,
                              blurRadius: 50,
                            )
                          ],
                        ),
                        Div(
                          [
                            P(
                              activeItem?.member.givenName,
                              isH5: true,
                              fg: colorBlack,
                            ),
                          ],
                        ),
                        Div(
                          [
                            ConnectionTags(
                              label: 'You’re both interested in - ',
                              item: activeItem as ConnectionModel,
                              isMatchOnly: true,
                            ),
                          ],
                        ),
                      ],
                    ),
                ],
                // ph: gap,
              ),
            ),
            Div(
              [
                Div(
                  [
                    Button(
                      'speak now',
                      onPress: () {
                        Get.toNamed(Routes.matchesChat, arguments: {
                          'id': 123,
                        });
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
