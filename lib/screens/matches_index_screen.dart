import 'dart:async';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/route_manager.dart';
import 'package:get/get.dart';
import 'package:voicematch/components/icon_box.dart';
import 'package:voicematch/components/logo.dart';
import 'package:voicematch/constants/colors.dart';
import 'package:voicematch/constants/theme.dart';
import 'package:voicematch/elements/div.dart';
import 'package:voicematch/elements/p.dart';
import 'package:voicematch/form/button.dart';
import 'package:voicematch/form/fab_button.dart';
import 'package:voicematch/form/progress_bar.dart';
import 'package:voicematch/layouts/app_layout.dart';
import 'package:voicematch/router.dart';

class MatchesIndexScreen extends StatefulWidget {
  const MatchesIndexScreen({Key? key}) : super(key: key);

  @override
  State<MatchesIndexScreen> createState() => MatchesIndexScreenState();
}

class MatchesIndexScreenState extends State<MatchesIndexScreen> {
  // error and busy
  String? error;
  bool? isBusy;

  @override
  void initState() {
    super.initState();
    getMatches();
  }

  Future<void> getMatches() async {
    EasyLoading.show(status: 'loading...');
    try {
      //
      setState(() {
        //
      });
    } on AuthException catch (e) {
      safePrint('getMatches- error - ${e.message}');
    }
    EasyLoading.dismiss();
  }

  void onBack() {
    Navigator.pop(context);
  }

  Future<void> onDelete() async {
    EasyLoading.show(status: 'loading...');
    try {
      //
    } on AuthException catch (e) {
      safePrint('onDelete - error ${e.message}');
      setState(() {
        error = e.message;
      });
    }
    EasyLoading.dismiss();
  }

  Future<void> onUnmatch() async {
    showCupertinoDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text("Unmatch selection"),
        content: const Text(
            "Are you sure you want unmatch this selection. This action can't be undone!"),
        actions: <Widget>[
          CupertinoDialogAction(
            isDefaultAction: true,
            child: const Text("Yes"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          CupertinoDialogAction(
            child: const Text("No"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
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
              pt: gapTop,
            ),
            Expanded(
              flex: 1,
              child: MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: ListView(
                  children: [
                    Div(
                      [
                        const Div(
                          [
                            Logo(),
                          ],
                          mv: gap,
                        ),
                        const Div(
                          [
                            P(
                              'Here are your matches',
                              isH5: true,
                              fw: FontWeight.w600,
                            ),
                          ],
                          mb: gapBottom,
                        ),
                        Div(
                          [
                            Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              runAlignment: WrapAlignment.spaceBetween,
                              runSpacing: gap,
                              children: List.generate(
                                10,
                                (index) {
                                  return SizedBox(
                                    width: MediaQuery.of(context).size.width /
                                        5, // Divide the width equally to accommodate four items per row
                                    child: Column(
                                      children: [
                                        Div(
                                          [
                                            FabButton(
                                              const IconBox(
                                                // Image.asset('assets/images/avatar.png'),
                                                Div(
                                                  [],
                                                  w: 48,
                                                  h: 48,
                                                  bg: colorPrimary050,
                                                  br: 48,
                                                ),
                                                w: 48,
                                                h: 48,
                                              ),
                                              w: 48,
                                              h: 48,
                                              onPress: () {
                                                Get.toNamed(
                                                  Routes.matchesPreview,
                                                  arguments: {
                                                    'id': index,
                                                  },
                                                );
                                              },
                                            ),
                                          ],
                                          mb: gap / 2,
                                        ),
                                        Div(
                                          [
                                            P(
                                              'Andrew Andrew Andrew Andrew',
                                              lines: 1,
                                              ta: TextAlign.center,
                                              ov: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        const Div(
                          [
                            Align(
                              alignment: Alignment.topLeft,
                              child: P(
                                'Conversations',
                                isH5: true,
                                fw: FontWeight.w600,
                              ),
                            ),
                          ],
                          mt: gapTop,
                          mb: gap,
                        ),
                        Div(
                          [
                            Column(
                              children: List.generate(
                                10,
                                (index) {
                                  return Div(
                                    [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Div(
                                            [
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Div(
                                                    [
                                                      // Image.asset('assets/images/avatar.png'),
                                                      FabButton(
                                                        const IconBox(
                                                          Div([]),
                                                          w: 64,
                                                          h: 64,
                                                          bg: colorPrimary050,
                                                          br: 64,
                                                        ),
                                                        w: 64,
                                                        h: 64,
                                                        onPress: () {
                                                          Get.toNamed(
                                                            Routes
                                                                .matchesPreview,
                                                            arguments: {
                                                              'id': index
                                                            },
                                                          );
                                                        },
                                                      ),
                                                    ],
                                                    mr: gap,
                                                  ),
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: const [
                                                      Div(
                                                        [
                                                          P(
                                                            'People Lover People LoverPeople Lover',
                                                            isH6: true,
                                                            lines: 1,
                                                            ov: TextOverflow
                                                                .ellipsis,
                                                          ),
                                                        ],
                                                        w: 150,
                                                      ),
                                                      Div(
                                                        [
                                                          P(
                                                            '25',
                                                            isCaption: true,
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                          Div(
                                            [
                                              SizedBox(
                                                width: 100,
                                                child: Button(
                                                  'Unmatch'.toUpperCase(),
                                                  height: 40,
                                                  // bg: colorOnSurfaceMediumEmphasis,
                                                  bg: colorBlack,
                                                  onPress: onUnmatch,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )
                                    ],
                                    mb: gap,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                      ph: gap,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
