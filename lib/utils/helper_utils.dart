import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

// Helper function to get the MIME type of an image based on its file name
Future<String?> getImageMimeType(String fileName) async {
  // Get the file extension from the given file name
  String fileExtension = fileName.split('.').last.toLowerCase();

  // Create a map of common image file extensions and their corresponding MIME types
  Map<String, String> imageMimeTypes = {
    'jpg': 'image/jpeg',
    'jpeg': 'image/jpeg',
    'png': 'image/png',
    'gif': 'image/gif',
    'bmp': 'image/bmp',
    // Add more extensions and MIME types as needed
  };

  // Check if the file extension exists in the map
  if (imageMimeTypes.containsKey(fileExtension)) {
    return imageMimeTypes[fileExtension];
  } else {
    // If the extension is not found in the map, use platform method to get MIME type
    try {
      final data = await rootBundle.load(fileName);
      final buffer = data.buffer.asUint8List();
      final magicBytes = buffer.length >= 4 ? buffer.sublist(0, 4) : [];

      if (magicBytes.length == 4) {
        // Compare the magic bytes to identify the MIME type
        if (magicBytes[0] == 0x89 &&
            magicBytes[1] == 0x50 &&
            magicBytes[2] == 0x4E &&
            magicBytes[3] == 0x47) {
          return 'image/png';
        } else if (magicBytes[0] == 0xFF && magicBytes[1] == 0xD8) {
          return 'image/jpeg';
        }
        // Add more checks for other magic bytes if needed
      }
    } catch (e) {
      print('Error loading file: $e');
    }
  }

  // Return a default MIME type if unable to identify
  return 'application/octet-stream';
}
