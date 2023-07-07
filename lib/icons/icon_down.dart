import 'package:flutter/material.dart';
import 'package:voicematch/utils/color_utils.dart';

String iconDown({Color? code = const Color(0xFF000000)}) {
  return ("""
<svg viewBox="0 0 25 24" fill="none" xmlns="http://www.w3.org/2000/svg">
	<path d="M4.5 9L12.5 17L20.5 9" stroke="${colorToHex(code)}" stroke-opacity="0.38" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" />
</svg>
""");
}
