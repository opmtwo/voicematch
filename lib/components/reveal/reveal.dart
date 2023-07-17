import 'dart:convert';
import 'dart:developer';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:http/http.dart' as http;
import 'package:voicematch/components/header.dart';
import 'package:voicematch/components/reveal/reveal_done.dart';
import 'package:voicematch/components/reveal/reveal_full.dart';
import 'package:voicematch/components/reveal/reveal_half.dart';
import 'package:voicematch/components/reveal/reveal_not_ready.dart';
import 'package:voicematch/components/reveal/reveal_ready.dart';
import 'package:voicematch/constants/colors.dart';
import 'package:voicematch/constants/env.dart';
import 'package:voicematch/constants/theme.dart';
import 'package:voicematch/constants/types.dart';
import 'package:voicematch/elements/div.dart';
import 'package:voicematch/utils/user_utils.dart';

class Reveal extends StatefulWidget {
  final String id;

  final List<Widget> header;

  final VoidCallback onPrev;

  const Reveal({
    Key? key,
    required this.id,
    required this.header,
    required this.onPrev,
  }) : super(key: key);

  @override
  State<Reveal> createState() => _RevealState();
}

class _RevealState extends State<Reveal> {
  _RevealState();

  // error and busy
  String? error;
  bool? isBusy;

  // connection loading?
  bool? isLoading = true;

  // the user connection
  ConnectionModel? connection;

  // duration
  Duration duration = const Duration(seconds: 0);

  @override
  void initState() {
    super.initState();
    getConnection();
  }

  Future<void> getConnection() async {
    setState(() {
      isBusy = true;
    });
    await EasyLoading.show(status: 'loading...');
    try {
      // get access token
      final result = await Amplify.Auth.fetchAuthSession(
        options: CognitoSessionOptions(getAWSCredentials: true),
      ) as CognitoAuthSession;
      final accessToken = result.userPoolTokens?.accessToken;

      // update profile via oboard api
      final url =
          Uri.parse('${apiEndPoint}api/v1/connections/${widget.id}/duration');
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
        connection = ConnectionModel.fromJson(json['connection']);
        duration = Duration(milliseconds: json['duration']);
      });
    } catch (err) {
      safePrint('getConnection- error - $err');
    }
    await EasyLoading.dismiss();
    setState(() {
      isBusy = false;
    });
  }

  Future<void> onReveal() async {
    await EasyLoading.show(status: 'loading...');
    try {
      final url =
          Uri.parse('${apiEndPoint}api/v1/connections/$widget.id/reveal');
      safePrint('onRevealSubmit - url $url');
      final response = await http.post(url, headers: await getHeaders());
      safePrint('onRevealSubmit - status code = ${response.statusCode}');

      // non 200 response code
      if (response.statusCode != 200) {
        throw Exception('onReveal - non-200 code: ${response.statusCode}');
      }

      // decode response
      final json = await jsonDecode(response.body);
      // log('onRevealSubmit - json - ${response.body}');

      // update state
      setState(() {
        // activeItem = ConnectionModel.fromJson(json);
      });
    } catch (err) {
      safePrint('onRevealSubmit- error - $err');
    }
    await EasyLoading.dismiss();
  }

  Future<void> onRevealNotReadySubmit() async {
    Navigator.pop(context);
  }

  Future<void> onRevealNotReadyCancel() async {
    Navigator.pop(context);
  }

  Future<void> onRevealReadySubmit() async {
    //
  }

  Future<void> onRevealReadyCancel() async {
    //
  }

  Future<void> onRevealHalfReadySubmit() async {
    //
  }

  Future<void> onRevealHalfReadyCancel() async {
    //
  }

  Future<void> onRevealFullReadySubmit() async {
    //
  }

  Future<void> onRevealFullReadyCancel() async {
    //
  }

  Future<void> onRevealedSubmit() async {
    //
  }

  Future<void> onRevealedCancel() async {
    //
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/splash.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 9,
          sigmaY: 9,
        ),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Div(
              [
                Header(
                  bg: colorWhite,
                  hasPrev: true,
                  onPrev: widget.onPrev,
                  children: widget.header,
                ),
              ],
              pt: gapTop,
              bg: colorWhite,
            ),
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // we want to show a loader while connection loads
                  if (connection?.id != null)
                    Div(
                      [
                        Div(
                          [
                            // not ready for reveal yet
                            if (duration.inMinutes < 10)
                              RevealNotReady(
                                connection: connection as ConnectionModel,
                                duration: duration,
                                submitTitle: 'Continue',
                                cancelTitle: 'Cancel',
                                onSubmit: onRevealNotReadySubmit,
                                onCancel: onRevealNotReadyCancel,
                              ),
                            // user ready to be revealed but not action taken yet
                            if (duration.inMinutes > 10 &&
                                connection?.isUserRevealed == null)
                              RevealReady(
                                duration: duration,
                                submitTitle: 'Yes',
                                cancelTitle: 'No',
                                onSubmit: onRevealReadySubmit,
                                onCancel: onRevealReadyCancel,
                              ),
                            // user has decided not to reveal
                            if (duration.inMinutes > 10 &&
                                duration.inMinutes < 20 &&
                                connection?.isUserRevealed == false)
                              RevealHalf(
                                duration: duration,
                                submitTitle: 'Yes',
                                cancelTitle: 'No',
                                onSubmit: onRevealHalfReadySubmit,
                                onCancel: onRevealHalfReadyCancel,
                              ),
                            // user needs to be revealed - but not revealed yet
                            if (duration.inMinutes > 20 &&
                                connection?.isUserRevealed == false)
                              RevealHalf(
                                duration: duration,
                                submitTitle: 'Yes',
                                cancelTitle: 'No',
                                onSubmit: onRevealFullReadySubmit,
                                onCancel: onRevealFullReadyCancel,
                              ),
                            // user revealed
                            if (connection?.isUserRevealed == true &&
                                connection?.isMemberRevealed != true)
                              RevealFull(
                                duration: duration,
                                submitTitle: 'Yes',
                                cancelTitle: 'No',
                                onSubmit: onRevealReadySubmit,
                                onCancel: onRevealReadyCancel,
                              ),
                            // user and member both revealed
                            if (connection?.isUserRevealed == true &&
                                connection?.isMemberRevealed == true)
                              RevealDone(
                                duration: duration,
                                submitTitle: 'Yes',
                                cancelTitle: 'No',
                                onSubmit: onRevealedSubmit,
                                onCancel: onRevealedCancel,
                              ),
                          ],
                          ph: gap,
                          pv: gapBottom,
                          bg: colorWhite,
                          br: radiusLarge,
                        ),
                      ],
                      pb: gap,
                      ph: gap / 2,
                      shadow: [
                        BoxShadow(
                          color: colorBlack.withOpacity(0.1),
                          blurRadius: 50,
                          spreadRadius: 25,
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
