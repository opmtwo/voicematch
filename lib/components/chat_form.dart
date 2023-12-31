import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:voicevibe/components/audio_recorder.dart';
import 'package:voicevibe/components/gallery_file_picker.dart';
import 'package:voicevibe/constants/colors.dart';
import 'package:voicevibe/constants/types.dart';
import 'package:voicevibe/elements/div.dart';
import 'package:voicevibe/form/fab_button.dart';
import 'package:voicevibe/form/input.dart';
import 'package:voicevibe/icons/icon_gallery.dart';

class ChatForm extends StatefulWidget {
  final Future<void> Function(String) onTextSubmit;
  final Future<void> Function(UploadModel upload) onFileSubmit;
  final Future<void> Function(String, Duration) onClipSubmit;

  const ChatForm({
    Key? key,
    required this.onTextSubmit,
    required this.onFileSubmit,
    required this.onClipSubmit,
  }) : super(key: key);

  @override
  State<ChatForm> createState() => ChatFormState();
}

class ChatFormState extends State<ChatForm> {
  // username
  final TextEditingController messageController = TextEditingController();
  String? messageError;

  @override
  initState() {
    super.initState();
  }

  Future<void> onTextInputSubmit(String value) async {
    safePrint('onTextInputSubmit - $value');
    widget.onTextSubmit(value);
    setState(() {
      messageController.text = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Div(
      [
        Stack(
          children: [
            Input(
              messageController,
              height: 48,
              placeholder: 'Send message',
              bc: colorGrey,
              bw: 0,
              br: 99,
              bg: colorWhite,
              fg: colorBlack,
              ta: TextAlign.center,
              error: messageError,
              errorFg: colorPrimary100,
              prT: ''.padRight(12, ' '),
              suT: ''.padRight(12, ' '),
              onSubmit: onTextInputSubmit,
            ),
            Positioned(
              top: 0,
              bottom: 0,
              left: 10,
              child: GalleryFilePicker(
                onSubmit: widget.onFileSubmit,
              ),
            ),
            Positioned(
              top: 6,
              right: 6,
              bottom: 0,
              child: AudioRecorder(
                onSubmit: widget.onClipSubmit,
                w: 48,
                h: 48,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
