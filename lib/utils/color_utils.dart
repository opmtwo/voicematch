import 'package:flutter/material.dart';

String? colorToHex(Color? color) {
  if (color == null) {
    return null;
  }
  return '#${color.value.toRadixString(16).padLeft(8, '0').toUpperCase()}';
}
