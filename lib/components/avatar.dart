import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:voicematch/components/icon_box.dart';
import 'package:voicematch/constants/colors.dart';
import 'package:voicematch/constants/theme.dart';
import 'package:voicematch/elements/div.dart';
import 'package:voicematch/elements/p.dart';
import 'package:voicematch/icons/icon_close.dart';

enum Status { available, busy, offline }

final ImagePicker _picker = ImagePicker();

Future<String?> uploadFile(XFile image) async {
  final tempDir = await getTemporaryDirectory();
  final uuid = const Uuid().v4().toString();
  final path = tempDir.path + uuid;
  // final exampleFile = File(tempDir.path + '/uuid').createSync();
  await image.saveTo(path);
  final imageFile = File(path);
  try {
    final UploadFileResult result = await Amplify.Storage.uploadFile(
      local: imageFile,
      key: uuid,
      onProgress: (progress) {
        // safePrint(
        //     'Fraction completed: ${progress.getFractionCompleted()}');
      },
    );
    safePrint('Successfully uploaded file: ${result.key}');
    await Amplify.Auth.updateUserAttribute(
      userAttributeKey: CognitoUserAttributeKey.picture,
      value: uuid,
    );
    safePrint('Successfully updated profile pic in user profile: $uuid');
    return uuid;
  } on StorageException catch (e) {
    safePrint('Error uploading file: $e');
  }
  return null;
}

class Avatar extends StatefulWidget {
  const Avatar({Key? key}) : super(key: key);

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
      String? picture = attributes
              .firstWhereOrNull((element) =>
                  element.userAttributeKey == CognitoUserAttributeKey.picture)
              ?.value ??
          '';
      safePrint('refreshAvatar - profile picture - $picture');
      if (picture.isEmpty) {
        return;
      }
      final result = await Amplify.Storage.getUrl(key: picture);
      safePrint('Fetched avatar url - ${result.url}');
      setState(() {
        profilePic = result.url;
      });
    } catch (e) {
      safePrint('Error fetching user avatar $e');
    }
  }

  Future pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
      );
      safePrint(image);
      if (image != null) {
        Get.back();
        final key = await uploadFile(image);
        if (key != null) {
          await uploadFile(image);
          return key;
        }
      }
    } catch (e) {
      safePrint('Error in gallery picker $e');
    }
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

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: profilePic != null
              ? Image.network(
                  profilePic!,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                )
              : const IconBox(
                  P(
                    'UPLOAD IMAGE',
                    isBody1: true,
                    ta: TextAlign.center,
                  ),
                  w: 160,
                  h: 160,
                  bg: Color(0xFFEEEEEE),
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
                  fw: FontWeight.w600,
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
