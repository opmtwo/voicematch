import 'package:flutter/material.dart';
import 'package:voicevibe/utils/color_utils.dart';

String iconSettings({Color? code = const Color(0xFF000000)}) {
  return ("""
<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <path d="M20.75 5H17.75" stroke="${colorToHex(code)}" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
  <path d="M13.75 3V7" stroke="${colorToHex(code)}" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
  <path d="M13.75 5H2.75" stroke="${colorToHex(code)}" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
  <path d="M6.75 12H2.75" stroke="${colorToHex(code)}" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
  <path d="M10.75 10V14" stroke="${colorToHex(code)}" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
  <path d="M21.75 12H10.75" stroke="${colorToHex(code)}" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
  <path d="M20.75 19H17.75" stroke="${colorToHex(code)}" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
  <path d="M13.75 17V21" stroke="${colorToHex(code)}" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
  <path d="M13.75 19H2.75" stroke="${colorToHex(code)}" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
</svg>
""");
}
