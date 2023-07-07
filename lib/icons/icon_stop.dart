import 'package:flutter/material.dart';
import 'package:voicematch/utils/color_utils.dart';

String iconStop(
    {Color? code = const Color(0xFF000000), double? opacity = 0.87}) {
  return ("""
<svg viewBox="0 0 25 24" fill="none" xmlns="http://www.w3.org/2000/svg">
	<mask id="mask0_700_4875" style="mask-type:luminance" maskUnits="userSpaceOnUse" x="3" y="3" width="19" height="18">
		<path
			fill-rule="evenodd"
			clip-rule="evenodd"
			d="M5.5 3H19.5C20.6 3 21.5 3.9 21.5 5V19C21.5 20.1 20.6 21 19.5 21H5.5C4.4 21 3.5 20.1 3.5 19V5C3.5 3.9 4.4 3 5.5 3ZM19.5 19V5H5.5V19H19.5Z"
			fill="white"
		/>
	</mask>
	<g mask="url(#mask0_700_4875)">
		<rect x="0.5" width="24" height="24" fill="${colorToHex(code)}" fill-opacity="$opacity" />
	</g>
</svg>
""");
}
