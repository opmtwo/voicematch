import 'package:flutter/material.dart';
import 'package:voicevibe/utils/color_utils.dart';

String iconHeart({Color? code = const Color(0xFFF82641)}) {
  return ("""
<svg viewBox="0 0 25 24" fill="none" xmlns="http://www.w3.org/2000/svg">
	<path
		d="M2.86719 6.64689C3.18134 5.91948 3.63433 5.2603 4.20078 4.70627C4.76766 4.15058 5.43603 3.70898 6.16953 3.40549C6.93013 3.08953 7.74592 2.92781 8.56953 2.9297C9.725 2.9297 10.8523 3.24611 11.832 3.84377C12.0664 3.98674 12.2891 4.14377 12.5 4.31486C12.7109 4.14377 12.9336 3.98674 13.168 3.84377C14.1477 3.24611 15.275 2.9297 16.4305 2.9297C17.2625 2.9297 18.0688 3.08908 18.8305 3.40549C19.5664 3.71017 20.2297 4.14845 20.7992 4.70627C21.3664 5.25968 21.8195 5.91901 22.1328 6.64689C22.4586 7.40392 22.625 8.20783 22.625 9.03517C22.625 9.81564 22.4656 10.6289 22.1492 11.4563C21.8844 12.1477 21.5047 12.8649 21.0195 13.5891C20.2508 14.7352 19.1938 15.9305 17.8813 17.1422C15.7063 19.1508 13.5523 20.5383 13.4609 20.5945L12.9055 20.9508C12.6594 21.1078 12.343 21.1078 12.0969 20.9508L11.5414 20.5945C11.45 20.536 9.29844 19.1508 7.12109 17.1422C5.80859 15.9305 4.75156 14.7352 3.98281 13.5891C3.49766 12.8649 3.11563 12.1477 2.85313 11.4563C2.53672 10.6289 2.37734 9.81564 2.37734 9.03517C2.375 8.20783 2.54141 7.40392 2.86719 6.64689Z"
		fill="${colorToHex(code)}"
	/>
</svg>
""");
}
