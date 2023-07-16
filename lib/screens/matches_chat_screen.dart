import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/route_manager.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:voicematch/components/audio_recorder.dart';
import 'package:voicematch/components/connection_header.dart';
import 'package:voicematch/components/header.dart';
import 'package:voicematch/components/chat_message.dart';
import 'package:voicematch/components/reveal/reveal.dart';
import 'package:voicematch/constants/colors.dart';
import 'package:voicematch/constants/env.dart';
import 'package:voicematch/constants/theme.dart';
import 'package:voicematch/constants/types.dart';
import 'package:voicematch/elements/div.dart';
import 'package:voicematch/elements/p.dart';
import 'package:voicematch/layouts/app_layout.dart';
import 'package:voicematch/router.dart';
import 'package:uuid/uuid.dart';
import 'package:voicematch/utils/user_utils.dart';

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
  bool? isMessagesLoading;

  @override
  void initState() {
    super.initState();
    setState(() {
      id = Get.arguments['id'] as String;
    });
    getConnection();
    getMessages();
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

  Future<void> getMessages() async {
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
      final url = Uri.parse('${apiEndPoint}api/v1/connections/$id/messages');
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
      log('getMessages - json - ${response.body}');

      // parse results
      List<MessageEventModel> newMessages = [];
      for (int i = 0; i < json['items'].length; i++) {
        newMessages.add(MessageEventModel.fromJson(json['items'][i]));
      }

      // update state
      setState(() {
        messages = newMessages;
      });
    } catch (err) {
      safePrint('getMessages- error - $err');
    }
    setState(() {
      isMessagesLoading = false;
    });
    await EasyLoading.dismiss();
  }

  void onBack() {
    Navigator.pop(context);
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
            final originalState = updateState;
            return Container(
              height: MediaQuery.of(context).size.height *
                  1, // Adjust the height as needed
              child: Reveal(
                duration: const Duration(seconds: 1500),
                isUserHalfRevealed: true,
                isUserFullRevealed: true,
                isMemberHalfRevealed: true,
                isMemberFullRevealed: true,
                header: [
                  if (activeItem != null) ConnectionHeader(item: activeItem),
                ],
                submitTitle: 'Continue',
                cancelTitle: 'cancel',
                yesTitle: 'Yes',
                noTitle: 'No',
                onPrev: onBack,
                onSubmit: onSubmit,
                onCancel: onCancel,
                onYes: onYes,
                onNo: onNo,
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
    var newRecording = await getRecordingModel(filepath, duration);
    MessageEventModel newMessageEvent = await getMessageEvent(
      type: 'audio',
      recording: newRecording,
    );
    final newMessages = messages + [newMessageEvent];
    setState(() {
      messages = newMessages;
    });
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

      // // create new messages
      // final newMessages = messages;
      // newMessages.add(recording);

      // // update state
      // setState(() {
      //   messages = newMessages;
      // });

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

      // // create new messages
      // final newMessages = messages;
      // newMessages.add(newMessageEvent);

      // // update state
      // setState(() {
      //   messages = newMessages;
      // });

      // all done
      return newMessageEvent;
    } catch (err) {
      safePrint('createMessage- error - ${err.toString()}');
      rethrow;
    }
  }

  Future<MessageEventModel?> onPublish(
    String id, {
    // MessageTypeEnum? type = 'text',
    // String? body = '',
    // String? filepath,
    // int? duration,
    bool isSilent = false,
  }) async {
    await EasyLoading.show(status: 'loading...');
    final MessageEventModel? localMessage =
        messages.firstWhereOrNull((element) => element.id == id);
    if (localMessage == null) {
      Get.snackbar('onPublish - error', 'Message not found');
      return null;
    }

    try {
      // upload recording file and save recording entry
      RecordingModel? recording;
      if (localMessage.recording?.url.startsWith('file://') == true &&
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
        log('onPublish - something went wrong trying to save the recording');
        return null;
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
      safePrint('onPublish - error - $err');
    }
    await EasyLoading.dismiss();
    return null;
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
                  hasPrev: true,
                  onPrev: onBack,
                  hasNext: true,
                  onNext: onNext,
                  nextIcon: const P(
                    'Image Reveal',
                    isBody2: true,
                    ff: 'Abel',
                    fw: FontWeight.w700,
                    ta: TextAlign.center,
                  ),
                  children: [
                    if (activeItem != null) ConnectionHeader(item: activeItem),
                  ],
                ),
              ],
              mt: gapTop,
            ),
            Expanded(
              flex: 1,
              child: ListView(
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
                                  onPublish: onPublish,
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
                AudioRecorder(
                  onSubmit: onRecord,
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
