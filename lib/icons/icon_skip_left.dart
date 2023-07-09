import 'package:flutter/material.dart';
import 'package:voicematch/utils/color_utils.dart';

String iconSkipLeft({Color? code = const Color(0xFF90E0EF)}) {
  return ("""
<svg viewBox="0 0 43 28" fill="none" xmlns="http://www.w3.org/2000/svg">
  <g clip-path="url(#clip0_801_1502)">
    <path d="M19.5 16.5981C17.5 15.4434 17.5 12.5566 19.5 11.4019L31.5 4.47372C33.5 3.31902 36 4.7624 36 7.0718V20.9282C36 23.2376 33.5 24.681 31.5 23.5263L19.5 16.5981Z" fill="${colorToHex(code)}"/>
    <path d="M4.5 16.5981C2.5 15.4434 2.5 12.5566 4.5 11.4019L16.5 4.47372C18.5 3.31902 21 4.7624 21 7.0718V20.9282C21 23.2376 18.5 24.681 16.5 23.5263L4.5 16.5981Z" fill="${colorToHex(code)}"/>
  </g>
  <defs>
    <clipPath id="clip0_801_1502">
      <rect width="43" height="28" fill="white" transform="matrix(-1 0 0 1 43 0)"/>
    </clipPath>
  </defs>
</svg>
""");
}
