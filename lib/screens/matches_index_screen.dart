import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/route_manager.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:voicevibe/components/connection_pic.dart';
import 'package:voicevibe/components/logo.dart';
import 'package:voicevibe/components/navbar.dart';
import 'package:voicevibe/constants/colors.dart';
import 'package:voicevibe/constants/env.dart';
import 'package:voicevibe/constants/theme.dart';
import 'package:voicevibe/constants/types.dart';
import 'package:voicevibe/elements/div.dart';
import 'package:voicevibe/elements/p.dart';
import 'package:voicevibe/form/button.dart';
import 'package:voicevibe/form/fab_button.dart';
import 'package:voicevibe/form/input.dart';
import 'package:voicevibe/icons/icon_minus.dart';
import 'package:voicevibe/icons/icon_plus.dart';
import 'package:voicevibe/icons/icon_search.dart';
import 'package:voicevibe/layouts/app_layout.dart';
import 'package:voicevibe/router.dart';
import 'package:voicevibe/utils/connection_utils.dart';

class MatchesIndexScreen extends StatefulWidget {
  const MatchesIndexScreen({Key? key}) : super(key: key);

  @override
  State<MatchesIndexScreen> createState() => MatchesIndexScreenState();
}

class MatchesIndexScreenState extends State<MatchesIndexScreen> {
  // error and busy
  String? error;
  bool? isBusy;

  // limit pull down to refresh
  bool? _isRefreshing;

  // list of matched connections
  List<ConnectionModel> connections = [];

  // list of pinned connections
  List<ConnectionModel> pinnedConnections = [];

  // filtered connections
  List<ConnectionModel> filteredConnections = [];

  final TextEditingController searchController = TextEditingController();
  String? searchError;

  @override
  void initState() {
    super.initState();
    getConnections();
  }

  Future<void> getConnections() async {
    await EasyLoading.show(status: 'loading...');
    try {
      // get access token
      final result = await Amplify.Auth.fetchAuthSession(
        options: CognitoSessionOptions(getAWSCredentials: true),
      ) as CognitoAuthSession;
      final accessToken = result.userPoolTokens?.accessToken;

      // update profile via oboard api
      final url = Uri.parse('${apiEndPoint}api/v1/connections');
      safePrint('onSubmit - url $url');
      final response = await http.get(url, headers: {
        'Authorization': accessToken.toString(),
      });
      safePrint('onSubmit - status code = ${response.statusCode}');

      // non 200 response code
      if (response.statusCode != 200) {
        throw Exception('Received non-200 status code: ${response.statusCode}');
      }

      // decode response
      final json = await jsonDecode(response.body);
      // log('getConnections - json - ${response.body}');

      // parse records
      List<ConnectionModel> newConnections = [];
      for (int i = 0; i < json.length; i++) {
        newConnections.add(ConnectionModel.fromJson(json[i]));
      }
      log('Found ${newConnections.length} connections');

      // update state
      setState(() {
        connections = newConnections;
        pinnedConnections = newConnections
            .where((element) => element.isPinned == true)
            .toList();
      });

      // search and set filtered connections
      onSearch(searchController.text);
    } catch (err) {
      safePrint('getConnections- error - $err');
    }
    await EasyLoading.dismiss();
  }

  void onBack() {
    Navigator.pop(context);
  }

  Future<void> onDelete(String id) async {
    EasyLoading.show(status: 'loading...');
    try {
      // get access token
      final result = await Amplify.Auth.fetchAuthSession(
        options: CognitoSessionOptions(getAWSCredentials: true),
      ) as CognitoAuthSession;
      final accessToken = result.userPoolTokens?.accessToken;

      // update profile via oboard api
      final url = Uri.parse('${apiEndPoint}api/v1/connections/$id');
      safePrint('onDelete - url $url');
      final response = await http.delete(url, headers: {
        'Authorization': accessToken.toString(),
      });
      safePrint('onDelete - status code = ${response.statusCode}');

      // non 200 response code
      if (response.statusCode != 200) {
        throw Exception('onDelete - non 200 code - ${response.statusCode}');
      }

      // update state
      setState(() {
        connections = connections.where((value) => value.id != id).toList();
      });
    } on AuthException catch (e) {
      safePrint('onDelete - error ${e.message}');
      setState(() {
        error = e.message;
      });
    }
    EasyLoading.dismiss();
  }

  Future<void> onUnpin(String id) async {
    EasyLoading.show(status: 'loading...');
    try {
      // get access token
      final result = await Amplify.Auth.fetchAuthSession(
        options: CognitoSessionOptions(getAWSCredentials: true),
      ) as CognitoAuthSession;
      final accessToken = result.userPoolTokens?.accessToken;

      // update profile via oboard api
      final url = Uri.parse('${apiEndPoint}api/v1/connections/$id/unpin');
      safePrint('onUnpin - url $url');
      final response = await http.post(url, headers: {
        'Authorization': accessToken.toString(),
      });
      safePrint('onUnpin - status code = ${response.statusCode}');

      // non 200 response code
      if (response.statusCode != 200) {
        throw Exception('onUnpin - non 200 code - ${response.statusCode}');
      }

      // update state
      getConnections();
    } on AuthException catch (e) {
      safePrint('onUnpin - error ${e.message}');
      setState(() {
        error = e.message;
      });
    }
    EasyLoading.dismiss();
  }

  Future<void> onUnmatch(String id) async {
    // showCupertinoDialog(
    //   barrierDismissible: true,
    //   context: context,
    //   builder: (context) => CupertinoAlertDialog(
    //     title: const Text("Unmatch selection"),
    //     content: const Text(
    //         "Are you sure you want unmatch this selection. This action can't be undone!"),
    //     actions: <Widget>[
    //       CupertinoDialogAction(
    //         isDefaultAction: true,
    //         child: const Text("Yes"),
    //         onPressed: () {
    //           Navigator.pop(context);
    //           onDelete(id);
    //         },
    //       ),
    //       CupertinoDialogAction(
    //         child: const Text("No"),
    //         onPressed: () {
    //           Navigator.pop(context);
    //         },
    //       ),
    //     ],
    //   ),
    // );
    onUnpin(id);
  }

  Future<void> onSearch(String value) async {
    // search query is empty
    if (value.trim().isEmpty) {
      setState(() {
        filteredConnections = connections;
      });
      return;
    }
    // search
    final items = searchConnections(connections, value);
    setState(() {
      filteredConnections = items;
    });
  }

  Future<void> onPinToggle(String id) async {
    final item = connections.firstWhereOrNull((element) => element.id == id);
    if (item == null) {
      return;
    }
    EasyLoading.show(status: 'loading...');
    try {
      // get access token
      final result = await Amplify.Auth.fetchAuthSession(
        options: CognitoSessionOptions(getAWSCredentials: true),
      ) as CognitoAuthSession;
      final accessToken = result.userPoolTokens?.accessToken;

      final bool shouldPin = item.isPinned == true ? false : true;

      // update profile via oboard api
      final url = Uri.parse(
          '${apiEndPoint}api/v1/connections/$id/${shouldPin ? "pin" : "unpin"}');
      safePrint('onPin - url $url');
      final response = await http.post(url, headers: {
        'Authorization': accessToken.toString(),
      });
      safePrint('onPin - status code = ${response.statusCode}');

      // non 200 response code
      if (response.statusCode != 200) {
        throw Exception('onPin - non 200 code - ${response.statusCode}');
      }

      // refresh connection
      await getConnections();
    } catch (err) {
      safePrint('onPin - error $err');
      setState(() {
        error = err.toString();
      });
    }
    EasyLoading.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: RefreshIndicator(
        onRefresh: () async {
          if (_isRefreshing == true) {
            return;
          }
          setState(() {
            _isRefreshing = true;
          });
          await getConnections();
          setState(() {
            _isRefreshing = false;
          });
        },
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: AppLayout(
            Div(
              [
                const Div(
                  [],
                  // pt: gapTop,
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
                            if (connections.isNotEmpty)
                              const Div(
                                [
                                  Logo(),
                                ],
                                mv: gap,
                              ),
                            if (connections.isNotEmpty)
                              Div(
                                [
                                  P(
                                    filteredConnections.isEmpty == true
                                        ? 'No matches found'
                                        : 'Here are your matches',
                                    isH5: true,
                                    fw: FontWeight.w600,
                                  ),
                                ],
                                mb: gapBottom,
                              ),
                            Div(
                              [
                                ConstrainedBox(
                                  constraints: BoxConstraints.loose(
                                      const Size.fromHeight(100)),
                                  child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    children: List.generate(
                                      filteredConnections.length,
                                      (index) {
                                        final item = connections[index];
                                        return SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              4.6, // Divide the width equally to accommodate four items per row
                                          child: Column(
                                            children: [
                                              Div(
                                                [
                                                  Stack(
                                                    children: [
                                                      Div(
                                                        [
                                                          FabButton(
                                                            ConnectionPic(
                                                              item: item,
                                                              w: avatarSmall,
                                                            ),
                                                            w: avatarSmall,
                                                            h: avatarSmall,
                                                            onPress: () {
                                                              Get.toNamed(
                                                                Routes
                                                                    .matchesPreview,
                                                                arguments: {
                                                                  'id': item.id,
                                                                },
                                                              );
                                                            },
                                                          ),
                                                        ],
                                                        ph: gap / 2,
                                                        pb: gap / 2,
                                                      ),
                                                      if (item.isPinned != true)
                                                        Positioned(
                                                          right: 0,
                                                          bottom: 0,
                                                          child: FabButton(
                                                            SvgPicture.string(
                                                              item.isPinned ==
                                                                      true
                                                                  ? iconMinus()
                                                                  : iconPlus(),
                                                              width: 16,
                                                            ),
                                                            w: 24,
                                                            h: 24,
                                                            bg: colorGrey200,
                                                            bw: 1,
                                                            bc: colorSeondary200,
                                                            onPress: () {
                                                              onPinToggle(
                                                                  item.id);
                                                            },
                                                          ),
                                                        )
                                                    ],
                                                  ),
                                                ],
                                                mb: gap / 2,
                                              ),
                                              Div(
                                                [
                                                  P(
                                                    item.member.givenName,
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
                                ),
                              ],
                            ),
                            if (connections.isNotEmpty)
                              Div(
                                [
                                  Stack(
                                    children: [
                                      Input(
                                        searchController,
                                        bc: colorGrey200,
                                        bg: colorWhite,
                                        bw: 1,
                                        br: 99,
                                        fg: colorBlack,
                                        placeholder: 'Search your Matches',
                                        placeholderFg: colorOnSurfaceDisabled,
                                        error: searchError,
                                        iconLeft: Icons.search,
                                        iconFg: colorTransparent,
                                        errorFg: colorPrimary100,
                                        onChange: onSearch,
                                      ),
                                      Positioned(
                                        top: 0,
                                        bottom: 0,
                                        left: gap / 2,
                                        child: SvgPicture.string(
                                          iconSearch(),
                                          width: 24,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                                mt: gapBottom,
                              ),
                            if (pinnedConnections.isNotEmpty)
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
                                    pinnedConnections.length,
                                    (index) {
                                      final item = pinnedConnections[index];
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
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Div(
                                                        [
                                                          FabButton(
                                                            ConnectionPic(
                                                              item: item,
                                                              w: avatarMedium,
                                                            ),
                                                            w: avatarMedium,
                                                            h: avatarMedium,
                                                            onPress: () {
                                                              Get.toNamed(
                                                                Routes
                                                                    .matchesChat,
                                                                arguments: {
                                                                  'id': item.id,
                                                                },
                                                              );
                                                            },
                                                          ),
                                                        ],
                                                        mr: gap,
                                                      ),
                                                      GestureDetector(
                                                        onTap: () {
                                                          Get.toNamed(
                                                            Routes.matchesChat,
                                                            arguments: {
                                                              'id': item.id,
                                                            },
                                                          );
                                                        },
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Div(
                                                              [
                                                                Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .topLeft,
                                                                  child: P(
                                                                    item.member
                                                                        .givenName,
                                                                    isH6: true,
                                                                    lines: 1,
                                                                    ov: TextOverflow
                                                                        .ellipsis,
                                                                  ),
                                                                ),
                                                              ],
                                                              w: 150,
                                                            ),
                                                            Div(
                                                              [
                                                                P(
                                                                  item.member
                                                                      .ageRange,
                                                                  isCaption:
                                                                      true,
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
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
                                                      bg: colorOnSurfaceMediumEmphasis,
                                                      onPress: () {
                                                        safePrint(
                                                            'item.id ${item.id}');
                                                        onUnmatch(item.id);
                                                      },
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
                const Navbar(
                  index: 0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
