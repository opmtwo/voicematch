import 'dart:async';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/route_manager.dart';
import 'package:get/get.dart';
import 'package:voicematch/components/header.dart';
import 'package:voicematch/components/image_masked.dart';
import 'package:voicematch/components/message.dart';
import 'package:voicematch/constants/colors.dart';
import 'package:voicematch/constants/theme.dart';
import 'package:voicematch/elements/div.dart';
import 'package:voicematch/elements/p.dart';
import 'package:voicematch/form/fab_button.dart';
import 'package:voicematch/icons/icon_mic.dart';
import 'package:voicematch/layouts/app_layout.dart';
import 'package:voicematch/router.dart';

class MatchesChatScreen extends StatefulWidget {
  const MatchesChatScreen({Key? key}) : super(key: key);

  @override
  State<MatchesChatScreen> createState() => MatchesChatScreenState();
}

class MatchesChatScreenState extends State<MatchesChatScreen> {
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

  List<String> interests = ['Hiking Trips', 'Writing'];

  @override
  void initState() {
    super.initState();
    getUser();
  }

  Future<void> getUser() async {
    EasyLoading.show(status: 'loading...');
    try {
      setState(() {
        //
      });
    } on AuthException catch (e) {
      safePrint('getUser- error - ${e.message}');
    }
    EasyLoading.dismiss();
  }

  void onBack() {
    Navigator.pop(context);
  }

  void onNext() {
    //
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppLayout(
        Div(
          [
            Div(
              [
                Header(
                  children: [
                    Row(
                      children: [
                        Div(
                          [
                            ImageMasked(
                              url: 'assets/images/avatar.png',
                              width: 48,
                            ),
                          ],
                          mr: gap / 2,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            P(
                              'Mario',
                              isH5: true,
                              fg: colorBlack,
                            ),
                            P(
                              'Last seen today at 10:07 PM',
                              isBody2: true,
                            )
                          ],
                        ),
                      ],
                    )
                  ],
                  hasPrev: true,
                  onPrev: onBack,
                  hasNext: true,
                  onNext: onNext,
                  nextIcon: const P(
                    'Image Reveal',
                    isBody2: true,
                    fw: FontWeight.w700,
                    ta: TextAlign.center,
                  ),
                ),
              ],
              mt: gapTop,
            ),
            Expanded(
              flex: 1,
              child: ListView(
                children: [
                  Div(
                    List.generate(
                      20,
                      (index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Div(
                              [
                                Message(
                                  isSender: index % 2 == 0,
                                  recordingDuration: index + 99,
                                ),
                              ],
                              mb: gap,
                            ),
                          ],
                        );
                      },
                    ),
                    mh: gap,
                  ),
                ],
              ),
            ),
            Div(
              [
                Div(
                  [
                    FabButton(
                      SvgPicture.string(
                        iconMic(opacity: 0),
                        height: 64,
                      ),
                      onPress: () {
                        //
                      },
                      w: 64,
                      h: 64,
                      bg: isRecording ? colorSeondary : colorSeondary200,
                    ),
                  ],
                ),
              ],
              pt: gap,
              pb: gapBottom,
            )
          ],
        ),
      ),
    );
  }
}
