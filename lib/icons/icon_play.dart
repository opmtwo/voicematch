import 'package:flutter/material.dart';
import 'package:voicematch/utils/color_utils.dart';

String iconPlay({Color? code = const Color(0xFF000000)}) {
  return ("""
<svg viewBox="0 0 33 32" fill="none" xmlns="http://www.w3.org/2000/svg">
	<path
		d="M23.692 17.3937L10.966 24.7777C9.886 25.4037 8.5 24.6457 8.5 23.3837V8.61572C8.5 7.35572 9.884 6.59572 10.966 7.22372L23.692 14.6077C23.9377 14.748 24.1419 14.9507 24.2839 15.1953C24.426 15.44 24.5008 15.7178 24.5008 16.0007C24.5008 16.2836 24.426 16.5615 24.2839 16.8061C24.1419 17.0507 23.9377 17.2535 23.692 17.3937Z"
		fill="${colorToHex(code)}"
	/>
</svg>
""");
}
