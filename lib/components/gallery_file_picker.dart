import 'dart:convert';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:voicevibe/constants/colors.dart';
import 'package:voicevibe/constants/env.dart';
import 'package:voicevibe/constants/types.dart';
import 'package:voicevibe/form/fab_button.dart';
import 'package:voicevibe/icons/icon_gallery.dart';
import 'package:voicevibe/utils/date_utils.dart';
import 'package:voicevibe/utils/helper_utils.dart';

Future<UploadModel?> uploadFile(XFile image) async {
  final user = await Amplify.Auth.getCurrentUser();
  final tempDir = await getTemporaryDirectory();
  final uuid = const Uuid().v4().toString();
  final today = getNow(format: 'yyyy-MM-dd');

  final key = '${user.userId}/uploads/$today/$uuid';
  final path = tempDir.path + uuid;
  // final exampleFile = File(tempDir.path + '/uuid').createSync();
  await image.saveTo(path);
  final imageFile = File(path);

  try {
    final UploadFileResult result = await Amplify.Storage.uploadFile(
      local: imageFile,
      key: key,
      onProgress: (progress) {
        // safePrint(
        //     'Fraction completed: ${progress.getFractionCompleted()}');
      },
      options: UploadFileOptions(
          // accessLevel: StorageAccessLevel.guest,
          ),
    );

    // get access token
    final response = await Amplify.Auth.fetchAuthSession(
      options: CognitoSessionOptions(getAWSCredentials: true),
    ) as CognitoAuthSession;
    final accessToken = response.userPoolTokens?.accessToken;

    // update profile via oboard api
    // call onboard api - this will generate public urls for the new image
    final url = Uri.parse('${apiEndPoint}api/v1/uploads');
    safePrint('GalleryFilePicker - uploadFile - url $url');

    final fileSize = await image.length();
    final mimeType = await getImageMimeType(path);
    safePrint({'mimeType': mimeType, 'fileSize': fileSize});

    final res = await http.post(url,
        body: jsonEncode({
          'key': 'public/$key',
          'name': image.name.split('/').last,
          'mime': image.mimeType ?? mimeType ?? 'image/jpeg',
          'size': fileSize,
          'duration': 0,
        }),
        headers: {
          'Authorization': accessToken.toString(),
          'Content-Type': 'application/json',
        });

    // all done
    safePrint(
        'GalleryFilePicker - uploadFile - status code = ${res.statusCode}');
    safePrint('GalleryFilePicker - uploadFile - uuid: $uuid');

    // non 200 response code
    if (res.statusCode != 200) {
      throw Exception('Received non-200 status code: ${res.statusCode}');
    }

    // decode response
    final json = await jsonDecode(res.body);

    // parse model from response json
    final model = UploadModel.fromJson(json);

    // all done
    return model;
  } on StorageException catch (err) {
    safePrint('GalleryFilePicker - uploadFile - error: $err');
  }
  return null;
}

class GalleryFilePicker extends StatefulWidget {
  final Future<void> Function(UploadModel upload) onSubmit;

  const GalleryFilePicker({
    Key? key,
    required this.onSubmit,
  }) : super(key: key);

  @override
  State<GalleryFilePicker> createState() => _GalleryFilePickerState();
}

class _GalleryFilePickerState extends State<GalleryFilePicker> {
  _GalleryFilePickerState();

  // error and busy
  String? error;
  bool? isBusy;

  final ImagePicker _picker = ImagePicker();

  Future pickImage() async {
    EasyLoading.show(status: 'loading...');
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        // maxWidth: 4000,
        // maxHeight: 4000,
      );
      if (image != null) {
        final upload = await uploadFile(image);
        if (upload != null) {
          await widget.onSubmit(upload);
        }
      }
    } catch (err) {
      safePrint('GalleryFilePicker- error $err');
    }
    EasyLoading.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    return FabButton(
      SvgPicture.string(
        iconGallery(),
      ),
      bg: colorTransparent,
      onPress: pickImage,
    );
  }
}
