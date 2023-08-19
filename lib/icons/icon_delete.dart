import 'package:flutter/material.dart';
import 'package:voicevibe/utils/color_utils.dart';

String iconDelete({Color? code = const Color(0xFF000000)}) {
  return ("""
<svg viewBox="0 0 25 24" fill="none" xmlns="http://www.w3.org/2000/svg">
	<path
		d="M17.5 4V2H7.5V4H2.5V6H4.5V21C4.5 21.2652 4.60536 21.5196 4.79289 21.7071C4.98043 21.8946 5.23478 22 5.5 22H19.5C19.7652 22 20.0196 21.8946 20.2071 21.7071C20.3946 21.5196 20.5 21.2652 20.5 21V6H22.5V4H17.5ZM18.5 6V20H6.5V6H18.5ZM15.5 9H13.5V17H15.5V9ZM11.5 9H9.5V17H11.5V9Z"
		fill="${colorToHex(code)}"
	/>
</svg>
""");
}
