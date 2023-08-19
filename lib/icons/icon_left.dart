import 'package:flutter/material.dart';
import 'package:voicevibe/utils/color_utils.dart';

String iconLeft({Color? code = const Color(0xFF000000)}) {
  return ("""
<svg viewBox="0 0 25 24" fill="none"
    xmlns="http://www.w3.org/2000/svg">
    <g clip-path="url(#clip0_700_4835)">
        <path d="M20.5 11H8.33L13.92 5.41L12.5 4L4.5 12L12.5 20L13.91 18.59L8.33 13H20.5V11Z" fill="${colorToHex(code)}"/>
    </g>
    <defs>
        <clipPath id="clip0_700_4835">
            <rect width="24" height="24" fill="white" transform="translate(0.5)"/>
        </clipPath>
    </defs>
</svg>
""");
}
