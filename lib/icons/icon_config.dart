import 'package:flutter/material.dart';

String iconConfig({Color? code = const Color(0xFF000000)}) {
  return ("""
<svg viewBox="0 0 6 24" fill="none"
    xmlns="http://www.w3.org/2000/svg">
    <path d="M2.25 5H-0.75" stroke="${code.toString()}" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
    <path d="M3.25 12H-7.75" stroke="${code.toString()}" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
    <path d="M2.25 19H-0.75" stroke="${code.toString()}" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
</svg>
""");
}
