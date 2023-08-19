import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:voicevibe/constants/colors.dart';
import 'package:voicevibe/constants/theme.dart';

String slugify(String text) {
  final pattern = RegExp(r'[^a-zA-Z0-9]+');
  final slug = text.toLowerCase().replaceAll(pattern, '-');
  return slug;
}

String enumToString(Enum e) {
  return e.toString().split('.').last;
}

Future<void> notifyError(String title, String message) async {
  Get.snackbar(
    'Error',
    'Message could not be send. Please try again.',
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: colorPrimary.withOpacity(
      0.85,
    ),
    colorText: colorWhite,
    padding: const EdgeInsets.all(
      gap,
    ),
  );
}
