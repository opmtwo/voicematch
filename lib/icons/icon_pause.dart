import 'package:flutter/material.dart';
import 'package:voicematch/utils/color_utils.dart';

String iconPause({Color? code = const Color(0xFF000000)}) {
  return ("""
<svg viewBox="0 0 16 20" fill="none" xmlns="http://www.w3.org/2000/svg">
  <g clip-path="url(#clip0_801_1507)">
    <rect width="6" height="20" rx="2" fill="white"/>
    <rect x="9.99939" y="0.000976562" width="6" height="20" rx="2" fill="${colorToHex(code)}"/>
  </g>
  <defs>
    <clipPath id="clip0_801_1507">
      <rect width="15.9994" height="20.0008" fill="${colorToHex(code)}"/>
    </clipPath>
  </defs>
</svg>
""");
}
