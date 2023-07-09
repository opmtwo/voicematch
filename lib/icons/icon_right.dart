import 'package:flutter/material.dart';
import 'package:voicematch/utils/color_utils.dart';

String iconRight({Color? code = const Color(0xFF000000)}) {
  return ("""
<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
    <path d="M9 20L17 12L9 4" stroke="${colorToHex(code)}" stroke-opacity="0.38" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
</svg>
""");
}
