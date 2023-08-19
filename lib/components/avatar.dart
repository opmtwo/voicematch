import 'dart:convert';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:voicevibe/components/icon_box.dart';
import 'package:voicevibe/constants/colors.dart';
import 'package:voicevibe/constants/env.dart';
import 'package:voicevibe/constants/theme.dart';
import 'package:voicevibe/elements/div.dart';
import 'package:voicevibe/elements/p.dart';
import 'package:voicevibe/icons/icon_close.dart';
import 'package:voicevibe/utils/date_utils.dart';

enum Status { available, busy, offline }

final ImagePicker _picker = ImagePicker();

Future<String?> uploadFile(XFile image) async {
  final user = await Amplify.Auth.getCurrentUser();
  final tempDir = await getTemporaryDirectory();
  final uuid = const Uuid().v4().toString();
  final today = getNow(format: 'yyyy-MM-dd');
  final key = '${user.userId}/avatars/$today/$uuid';
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

    // update user attribute
    await Amplify.Auth.updateUserAttribute(
      userAttributeKey: CognitoUserAttributeKey.picture,
      value: 'public/$key',
    );

    // get access token
    final response = await Amplify.Auth.fetchAuthSession(
      options: CognitoSessionOptions(getAWSCredentials: true),
    ) as CognitoAuthSession;
    final accessToken = response.userPoolTokens?.accessToken;

    // update profile via oboard api
    // call onboard api - this will generate public urls for the new image
    final url = Uri.parse('${apiEndPoint}api/v1/onboard?avatar=true');
    safePrint('onSubmit - url $url');
    final res = await http.post(url, body: jsonEncode({}), headers: {
      'Authorization': accessToken.toString(),
    });

    // all done
    safePrint('uploadFile - status code = ${res.statusCode}');
    safePrint('uploadFile - updated profile pic in user profile: $uuid');
    return uuid;
  } on StorageException catch (e) {
    safePrint('Error uploading file: $e');
  }
  return null;
}

class Avatar extends StatefulWidget {
  final double? w;
  final double? h;

  const Avatar({
    Key? key,
    this.w,
    this.h,
  }) : super(key: key);

  @override
  State<Avatar> createState() => AvatarState();
}

class AvatarState extends State<Avatar> {
  // user profile pic
  String? profilePic;

  // observable key
  ValueNotifier<String> imageKey = ValueNotifier<String>('');

  @override
  initState() {
    super.initState();
    refreshAvatar();

    // listen to change events for avatar key and refresh avatar
    imageKey.addListener(() {
      safePrint('imageKey has changed to $imageKey');
    });
  }

  Future<void> refreshAvatar() async {
    try {
      final attributes = await Amplify.Auth.fetchUserAttributes();
      String? url = attributes
              .firstWhereOrNull((element) =>
                  element.userAttributeKey ==
                  const CognitoUserAttributeKey.custom('custom:picture_normal'))
              ?.value ??
          '';
      safePrint('refreshAvatar - profile picture url - $url');
      setState(() {
        profilePic = url;
      });
      safePrint('Fetched avatar url in avatar.dart');
    } catch (e) {
      safePrint('Error fetching user avatar $e');
    }
  }

  Future pickImage() async {
    EasyLoading.show(status: 'loading...');
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
      );
      safePrint(image);
      if (image != null) {
        // Get.back();
        final key = await uploadFile(image);
        if (key != null) {
          // await uploadFile(image);
          // return key;
          await refreshAvatar();
        }
      }
    } catch (e) {
      safePrint('Error in gallery picker $e');
    }
    EasyLoading.dismiss();
  }

  Future<void> onEditAvatar() async {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFFEEEEEE),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
      ),
      builder: (BuildContext context) {
        return SizedBox(
          height: 300,
          child: StatefulBuilder(
            builder: (BuildContext context,
                void Function(void Function()) setState) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Div(
                    [
                      Stack(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: const [
                              Div(
                                [
                                  P(
                                    'Change profile picture',
                                    isH4: true,
                                    fw: FontWeight.bold,
                                  ),
                                ],
                                pv: gap,
                              ),
                            ],
                          ),
                          Positioned(
                            top: 30,
                            right: 30,
                            child: GestureDetector(
                              onTap: () {
                                Get.back();
                              },
                              child: Div(
                                [
                                  SvgPicture.string(
                                    iconClose(),
                                    height: 20,
                                  ),
                                ],
                                bc: colorPrimary,
                                bw: 1,
                                br: 99,
                                ph: 5,
                                pv: 5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  final double defaultWidth = avatarLarge;
  final double defaultHeight = avatarLarge;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: profilePic != null && profilePic?.trim().isNotEmpty == true
              ? Image.network(
                  profilePic as String,
                  width: widget.w ?? defaultWidth,
                  height: widget.h ?? defaultHeight,
                  fit: BoxFit.cover,
                  isAntiAlias: true,
                  errorBuilder: (context, error, stackTrace) {
                    // Error occurred while fetching the image from the network
                    return IconBox(
                      const P(
                        'Error Loading Image',
                        isBody1: true,
                        lh: 1,
                        ta: TextAlign.center,
                      ),
                      w: widget.w ?? defaultWidth,
                      h: widget.h ?? defaultHeight,
                      bg: const Color(0xFFEEEEEE),
                    );
                  },
                )
              : IconBox(
                  const P(
                    'UPLOAD IMAGE',
                    isBody1: true,
                    ta: TextAlign.center,
                  ),
                  w: widget.w ?? defaultWidth,
                  h: widget.h ?? defaultHeight,
                  bg: const Color(0xFFEEEEEE),
                ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          left: 0,
          child: Div(
            [
              GestureDetector(
                onTap: pickImage,
                child: P(
                  'Edit'.toUpperCase(),
                  isBody1: true,
                  fw: FontWeight.w700,
                  fg: colorBlack,
                ),
              ),
            ],
            pv: gap / 2,
            bg: colorOnPrimaryDisabled,
          ),
        )
      ],
    );
  }
}
