import 'package:flutter/material.dart';
import 'package:voicevibe/utils/color_utils.dart';

String iconSearch({Color? code = const Color(0xFF000000)}) {
  return ("""
<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <path d="M11.0398 17.28C7.5838 17.28 4.7998 14.496 4.7998 11.04C4.7998 7.58405 7.5838 4.80005 11.0398 4.80005C14.4958 4.80005 17.2798 7.58405 17.2798 11.04C17.2798 14.496 14.4958 17.28 11.0398 17.28ZM11.0398 5.76005C8.1118 5.76005 5.7598 8.11205 5.7598 11.04C5.7598 13.968 8.1118 16.32 11.0398 16.32C13.9678 16.32 16.3198 13.968 16.3198 11.04C16.3198 8.11205 13.9678 5.76005 11.0398 5.76005Z" fill="${colorToHex(code)}"/>
  <path d="M15.687 15.0083L19.9974 19.3187L19.3187 19.9974L15.0083 15.687L15.687 15.0083Z" fill="${colorToHex(code)}"/>
</svg>
""");
}
