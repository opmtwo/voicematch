import 'package:flutter/material.dart';
import 'package:voicematch/utils/color_utils.dart';

String iconVideo({
  Color? code = const Color(0xFFCAF0F8),
  double? opacity = 1,
}) {
  return ("""
<svg viewBox="0 0 24 24"
    xmlns="http://www.w3.org/2000/svg">
    <g data-name="44. Video" id="_44._Video">
        <path d="M23.458,5.11a1,1,0,0,0-1.039.077L17,9.057V6a2,2,0,0,0-2-2H2A2,2,0,0,0,0,6V18a2,2,0,0,0,2,2H15a2,2,0,0,0,2-2V14.943l5.419,3.87A.988.988,0,0,0,23,19a1.019,1.019,0,0,0,.458-.11A1,1,0,0,0,24,18V6A1,1,0,0,0,23.458,5.11ZM2,18V6H15V18Zm20-1.943-5-3.572v-.97l5-3.572Z"/>
    </g>
</svg>
""");
}
