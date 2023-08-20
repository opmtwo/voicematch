import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/route_manager.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:voicevibe/components/audio_recorder.dart';
import 'package:voicevibe/components/chat_form.dart';
import 'package:voicevibe/components/connection_header.dart';
import 'package:voicevibe/components/header.dart';
import 'package:voicevibe/components/chat_message.dart';
import 'package:voicevibe/components/reveal/reveal.dart';
import 'package:voicevibe/constants/colors.dart';
import 'package:voicevibe/constants/env.dart';
import 'package:voicevibe/constants/theme.dart';
import 'package:voicevibe/constants/types.dart';
import 'package:voicevibe/elements/div.dart';
import 'package:voicevibe/elements/p.dart';
import 'package:voicevibe/form/button.dart';
import 'package:voicevibe/icons/icon_video.dart';
import 'package:voicevibe/layouts/app_layout.dart';
import 'package:voicevibe/router.dart';
import 'package:uuid/uuid.dart';
import 'package:voicevibe/utils/helper_utils.dart';
import 'package:voicevibe/utils/user_utils.dart';

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

  // match connection id
  late String id;

  // connection
  ConnectionModel? activeItem;

  // messages
  List<MessageEventModel> messages = [];

  // messages loading?
  bool? isMessagesLoading;

  // messages nextToken
  String? nextToken;

  // Create a ScrollController
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    setState(() {
      id = Get.arguments['id'] as String;
    });
    getConnection();
    getMessages();
  }

  void scrollIntoView() {
    if (_scrollController.position.pixels <
        _scrollController.position.maxScrollExtent) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 100,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    }
  }

  void showErrorAlert() {
    notifyError(
      'Error',
      'Message could not be send. Please try again.',
    );
  }

  Future<void> getConnection() async {
    // await EasyLoading.show(status: 'loading...');
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
      // log('getConnection - json - ${response.body}');

      // update state
      setState(() {
        activeItem = ConnectionModel.fromJson(json);
      });
    } catch (err) {
      safePrint('getConnection- error - $err');
    }
    // await EasyLoading.dismiss();
  }

  Future<void> getMessages({bool? isLoadMore = false}) async {
    await EasyLoading.show(status: 'loading...');
    setState(() {
      isMessagesLoading = true;
    });
    try {
      // get access token
      final result = await Amplify.Auth.fetchAuthSession(
        options: CognitoSessionOptions(getAWSCredentials: true),
      ) as CognitoAuthSession;
      final accessToken = result.userPoolTokens?.accessToken;

      // update profile via oboard api
      final url = Uri.parse(
        '${apiEndPoint}api/v1/connections/$id/messages?nextToken=${nextToken ?? ''}',
      );
      safePrint('getMessages - url $url');
      final response = await http.get(url, headers: {
        'Authorization': accessToken.toString(),
      });
      safePrint('getMessages - status code = ${response.statusCode}');

      // non 200 response code
      if (response.statusCode != 200) {
        throw Exception('getMessages - non-200 code: ${response.statusCode}');
      }

      // decode response
      final json = await jsonDecode(response.body);
      // log('getMessages - json - ${response.body}');

      // parse results
      List<MessageEventModel> newMessages = [];
      for (int i = 0; i < json['items'].length; i++) {
        newMessages.add(MessageEventModel.fromJson(json['items'][i]));
      }

      if (isLoadMore == true) {
        newMessages = newMessages + messages;
      } else {
        newMessages = newMessages;
      }

      newMessages.sort((a, b) =>
          DateTime.parse(a.createdAt).compareTo(DateTime.parse(b.createdAt)));

      // if load more then prepend to list else reset entire list
      setState(() {
        messages = newMessages;
        nextToken = json['nextToken'];
      });

      // Scroll to the bottom of the ListView
      if (isLoadMore != true) {
        Future.delayed(const Duration(milliseconds: 100), () {
          scrollIntoView();
        });
      }
    } catch (err) {
      safePrint('getMessages- error - $err');
    }
    setState(() {
      isMessagesLoading = false;
    });
    await EasyLoading.dismiss();
  }

  void onBack() {
    // Navigator.pop(context);
    Get.offNamedUntil(
      Routes.matchesIndex,
      (route) => false,
    );
  }

  void onSubmit() {
    //
  }

  void onCancel() {
    //
  }

  void onYes() {
    //
  }

  void onNo() {
    //
  }

  void onNext() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: colorTransparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, updateState) {
            // final originalState = updateState;
            return SizedBox(
              height: MediaQuery.of(context).size.height *
                  1, // Adjust the height as needed
              child: Reveal(
                id: id,
                header: [
                  if (activeItem != null) ConnectionHeader(item: activeItem),
                ],
                onPrev: () {
                  Navigator.pop(context);
                },
                isModal: true,
              ),
            );
          },
        );
      },
    );
  }

  Future<RecordingModel> getRecordingModel(
    String filepath,
    Duration duration,
  ) async {
    final user = await Amplify.Auth.getCurrentUser();
    final now = DateTime.now().toLocal().toIso8601String();
    final newRecording = RecordingModel(
      id: const Uuid().v4().toString(),
      owner: user.userId,
      userId: user.userId,
      key: filepath,
      url: filepath,
      duration: duration.inMilliseconds.toDouble(),
      createdAt: now,
      updatedAt: now,
    );
    return newRecording;
  }

  Future<MessageEventModel> getMessageEvent({
    String? type = 'text',
    String? body,
    RecordingModel? recording,
  }) async {
    final id = const Uuid().v4().toString();
    final user = await Amplify.Auth.getCurrentUser();
    final now = DateTime.now().toLocal().toIso8601String();
    final newMessageEventModel = MessageEventModel(
      id: '$id-${user.userId}',
      owner: user.userId,
      userId: user.userId,
      chatId: '${activeItem?.chatId}',
      chatUserId: '${activeItem?.userId}-${activeItem?.memberId}',
      messageId: id,
      type: type,
      body: body,
      recordingId: recording?.id,
      recording: recording,
      isSender: true,
      isReceiver: false,
      createdAt: now,
      updatedAt: now,
    );
    return newMessageEventModel;
  }

  Future<void> onRecord(String filepath, Duration duration) async {
    // create new local record model
    final newRecording = await getRecordingModel(filepath, duration);

    // create new local message event model
    final newMessageEvent = await getMessageEvent(
      type: 'audio',
      recording: newRecording,
    );

    // append the the end of existing messages
    final newMessages = messages + [newMessageEvent];
    setState(() {
      messages = newMessages;
    });

    // Scroll to the bottom of the ListView
    scrollIntoView();
  }

  /// @summary
  /// Save recording
  ///
  /// @param key - s3 recording file key
  /// @param duration - recording duration in ms
  Future<RecordingModel?> createRecording(String key, int duration) async {
    try {
      // get access token
      final result = await Amplify.Auth.fetchAuthSession(
        options: CognitoSessionOptions(getAWSCredentials: true),
      ) as CognitoAuthSession;
      final accessToken = result.userPoolTokens?.accessToken;

      // update profile via oboard api
      final url = Uri.parse('${apiEndPoint}api/v1/recordings');
      safePrint('createRecording - url $url');
      final response = await http.post(url,
          body: jsonEncode({
            'key': key,
            'duration': duration,
          }),
          headers: {
            'Authorization': accessToken.toString(),
            'Content-Type': 'application/json',
          });
      safePrint('createRecording - status code = ${response.statusCode}');

      // non 200 response code
      if (response.statusCode != 200) {
        throw Exception('onCreate - non-200 code: ${response.statusCode}');
      }

      // decode response
      final json = await jsonDecode(response.body);
      log('createRecording - json - ${response.body}');

      // parse data
      final recording = RecordingModel.fromJson(json);

      return recording;
    } catch (err) {
      safePrint('createRecording - error - $err');
      rethrow;
    }
  }

  /// @summary
  /// Save recording
  ///
  /// @param key - s3 recording file key
  /// @param duration - recording duration in ms
  Future<MessageEventModel?> createMessage({
    String? body,
    String? recordingId,
    String? type = 'text',
    bool isSilent = false,
  }) async {
    try {
      // get access token
      final result = await Amplify.Auth.fetchAuthSession(
        options: CognitoSessionOptions(getAWSCredentials: true),
      ) as CognitoAuthSession;
      final accessToken = result.userPoolTokens?.accessToken;

      // update profile via oboard api
      final url = Uri.parse('${apiEndPoint}api/v1/connections/$id/messages');
      safePrint('createMessage - url $url');
      final response = await http.post(url,
          body: jsonEncode({
            'body': body ?? '',
            'recordingId': recordingId,
            'type': type,
            'isSilent': isSilent,
          }),
          headers: {
            'Authorization': accessToken.toString(),
            'Content-Type': 'application/json',
          });
      safePrint('createMessage - status code = ${response.statusCode}');

      // non 200 response code
      if (response.statusCode != 200) {
        final errorData = await jsonDecode(response.body);
        throw Exception(
            'onCreate - non-200 code: ${response.statusCode} - $errorData');
      }

      // decode response
      final json = await jsonDecode(response.body);
      log('createMessage - json - ${response.body}');

      // parse data
      final newMessageEvent = MessageEventModel.fromJson(json);

      // all done
      return newMessageEvent;
    } catch (err) {
      safePrint('createMessage- error - ${err.toString()}');
      rethrow;
    }
  }

  Future<MessageEventModel?> onClipPublish(
    String id, {
    bool isSilent = false,
  }) async {
    // await EasyLoading.show(status: 'loading...');
    final MessageEventModel? localMessage =
        messages.firstWhereOrNull((element) => element.id == id);
    if (localMessage == null) {
      showErrorAlert();
      return null;
    }

    final index = messages.indexWhere((element) => element.id == id);
    final newMessages = messages;
    newMessages[index].isBusy = true;
    setState(() {
      messages = newMessages;
    });

    try {
      // upload recording file and save recording entry
      RecordingModel? recording;
      if (localMessage.recording?.url.startsWith('https://') == false &&
          localMessage.recording?.duration != null) {
        final recordingKey = await uploadRecordingFile(
          localMessage.recording?.url as String,
        );
        recording = await createRecording(
          recordingKey,
          localMessage.recording?.duration.round().toInt() as int,
        );
      }

      // save message entry
      MessageEventModel? message = await createMessage(
        type: localMessage.type,
        body: localMessage.body ?? '',
        recordingId: recording?.id,
        isSilent: isSilent,
      );

      if (message?.id == null) {
        throw ('');
      }

      // if we reached this far then we only can replace the model if we want
      // by replace the model I mean replace the dummy model with the real one
      // may not be needed as the user will already have a local model in place
      List<MessageEventModel> newMessages = messages;
      for (int i = 0; i < messages.length; i++) {
        if (messages[i].id != localMessage.id) {
          continue;
        }
        newMessages[i] = message as MessageEventModel;
      }
      setState(() {
        messages = newMessages;
      });
    } catch (err) {
      safePrint('onClipPublish - error - $err');
      final index = messages.indexWhere((element) => element.id == id);
      final newMessages = messages;
      newMessages[index].isBusy = false;
      setState(() {
        messages = newMessages;
      });
      showErrorAlert();
    }
    // await EasyLoading.dismiss();
    return null;
  }

  Future<MessageEventModel?> onTextPublish(
    String id, {
    bool isSilent = false,
  }) async {
    // await EasyLoading.show(status: 'loading...');
    final MessageEventModel? localMessage =
        messages.firstWhereOrNull((element) => element.id == id);
    if (localMessage == null) {
      showErrorAlert();
      return null;
    }

    final index = messages.indexWhere((element) => element.id == id);
    final newMessages = messages;
    newMessages[index].isBusy = true;
    setState(() {
      messages = newMessages;
    });

    try {
      // save message entry
      MessageEventModel? message = await createMessage(
        type: localMessage.type,
        body: localMessage.body ?? '',
        isSilent: isSilent,
      );

      if (message?.id == null) {
        throw ('');
      }

      // if we reached this far then we only can replace the model if we want
      // by replace the model I mean replace the dummy model with the real one
      // may not be needed as the user will already have a local model in place
      List<MessageEventModel> newMessages = messages;
      for (int i = 0; i < messages.length; i++) {
        if (messages[i].id != localMessage.id) {
          continue;
        }
        newMessages[i] = message as MessageEventModel;
      }
      setState(() {
        messages = newMessages;
      });
    } catch (err) {
      safePrint('onClipPublish - error - $err');
      final index = messages.indexWhere((element) => element.id == id);
      final newMessages = messages;
      newMessages[index].isBusy = false;
      setState(() {
        messages = newMessages;
      });
      showErrorAlert();
    }
    // await EasyLoading.dismiss();
    return null;
  }

  /// Used to remove local messages
  Future<MessageEventModel?> onClipDelete(String id) async {
    setState(() {
      messages = messages.takeWhile((value) => value.id != id).toList();
    });
    return null;
  }

  Future<void> onTextSubmit(String msg) async {
    // create new local message event model
    final newMessageEvent = await getMessageEvent(
      type: 'text',
      body: msg,
    );

    // append the the end of existing messages
    final newMessages = messages + [newMessageEvent];
    setState(() {
      messages = newMessages;
    });

    // Scroll to the bottom of the ListView
    scrollIntoView();
    onTextPublish(newMessageEvent.id);
  }

  Future<void> onFileSubmit(String fileKey, String fileType) async {
    //
  }

  Future<void> onClipSubmit(String filepath, Duration duration) async {
    await onRecord(filepath, duration);
  }

  @override
  Widget build(BuildContext context) {
    Widget? next;

    if (activeItem?.id != null &&
        (activeItem?.isUserRevealed != true ||
            activeItem?.isMemberRevealed != true)) {
      next = const P(
        'Image Reveal',
        isCaption: true,
        ff: 'Abel',
        fg: colorWhite,
        fw: FontWeight.w700,
        ta: TextAlign.center,
      );
    }

    if (activeItem?.isUserRevealed == true &&
        activeItem?.isMemberRevealed == true) {
      next = SvgPicture.string(
        iconVideo(),
        width: 20,
      );
    }

    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: AppLayout(
          Div(
            [
              Div(
                [
                  Header(
                    hasPrev: true,
                    onPrev: onBack,
                    hasNext: next != null,
                    onNext: onNext,
                    nextIcon: next,
                    nextBg: colorSeondary500,
                    children: [
                      if (activeItem != null)
                        ConnectionHeader(item: activeItem),
                    ],
                  ),
                ],
                mt: gap,
              ),
              Expanded(
                flex: 1,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    children: [
                      if (messages.isEmpty && isMessagesLoading == false)
                        const Div(
                          [
                            P(
                              'No messages found. Get started by sending the first message!',
                              isH6: true,
                              ta: TextAlign.center,
                            ),
                          ],
                          pv: gap,
                          ph: gap,
                        ),
                      if (nextToken != null)
                        Div(
                          [
                            Button(
                              'Load More',
                              height: gap * 2,
                              bg: colorSeondary200,
                              // fg: colorSeondary500,
                              onPress: () {
                                getMessages(isLoadMore: true);
                              },
                            ),
                          ],
                          w: 150,
                          mv: gap,
                        ),
                      Div(
                        List.generate(
                          messages.length,
                          (index) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Div(
                                  [
                                    ChatMessage(
                                      connection: activeItem as ConnectionModel,
                                      message: messages[index],
                                      onPublish: onClipPublish,
                                      onDelete: onClipDelete,
                                    ),
                                  ],
                                  mb: gap,
                                ),
                              ],
                            );
                          },
                        ),
                        mh: gap,
                        mv: gapTop,
                      ),
                    ],
                  ),
                ),
              ),
              Div(
                [
                  if (activeItem?.isUserRevealed != true &&
                      activeItem?.isMemberRevealed != true)
                    AudioRecorder(
                      onSubmit: onRecord,
                    ),
                  if (activeItem?.isUserRevealed == true ||
                      activeItem?.isMemberRevealed == true)
                    ChatForm(
                      onTextSubmit: onTextSubmit,
                      onFileSubmit: onFileSubmit,
                      onClipSubmit: onClipSubmit,
                    ),
                ],
                ph: gap,
                pt: gap,
                pb: gapBottom,
              )
            ],
          ),
        ),
      ),
    );
  }
}
