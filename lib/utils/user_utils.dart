import 'dart:io';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:email_validator/email_validator.dart';
import 'package:get/get.dart';
import 'package:voicematch/router.dart';
import 'package:voicematch/utils/date_utils.dart';
import 'package:uuid/uuid.dart';

bool isPasswordValid(String value) {
  RegExp regex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[\S]{8,}$');
  if (!regex.hasMatch(value)) {
    return false;
  }
  return true;
}

bool isEmailValid(String value) {
  return EmailValidator.validate(value);
}

Future<void> redirectUser() async {
  List<AuthUserAttribute> attributes = await Amplify.Auth.fetchUserAttributes();
  String isSetupDone = attributes
          .firstWhereOrNull((element) =>
              element.userAttributeKey ==
              const CognitoUserAttributeKey.custom('custom:is_setup_done'))
          ?.value ??
      '';
  if (isSetupDone == 'true') {
    Get.offNamedUntil(
      Routes.matchesIndex,
      (route) => false,
    );
  } else {
    Get.offNamedUntil(
      Routes.setupIntro,
      (route) => false,
    );
  }
}

Future<String> uploadRecordingFile(String path) async {
  final user = await Amplify.Auth.getCurrentUser();
  final uuid = const Uuid().v4().toString();
  final today = getNow(format: 'yyyy-MM-dd');
  final key = '${user.username}/recordings/$today/$uuid';
  final localFile = File.fromUri(Uri.parse(path));
  safePrint('uploadRecordingFile - key = $key');
  try {
    final UploadFileResult result = await Amplify.Storage.uploadFile(
      local: localFile,
      key: key,
      onProgress: (progress) {
        // safePrint(
        //     'Fraction completed: ${progress.getFractionCompleted()}');
      },
      options: UploadFileOptions(
        contentType: 'audio/mp4',
      ),
    );
    final s3Key = 'public/${result.key}';
    safePrint('uploadRecordingFile - success - $s3Key');
    return s3Key;
  } on StorageException catch (err) {
    safePrint('uploadRecordingFile - error - $err');
    rethrow;
  }
}
