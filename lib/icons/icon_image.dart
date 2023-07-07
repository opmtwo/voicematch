import 'package:flutter/material.dart';

String iconImage({Color? code = const Color(0xFF000000)}) {
  return ("""
<svg viewBox="0 0 25 24" fill="none" xmlns="http://www.w3.org/2000/svg">
	<path
		d="M22.5 6C22.5 4.93913 22.0786 3.92172 21.3284 3.17157C20.5783 2.42143 19.5609 2 18.5 2H6.5C5.43913 2 4.42172 2.42143 3.67157 3.17157C2.92143 3.92172 2.5 4.93913 2.5 6V18C2.5 19.0609 2.92143 20.0783 3.67157 20.8284C4.42172 21.5786 5.43913 22 6.5 22H18.5C19.5609 22 20.5783 21.5786 21.3284 20.8284C22.0786 20.0783 22.5 19.0609 22.5 18V6Z"
		stroke="${code.toString()}"
		stroke-opacity="0.38"
		stroke-width="2"
		stroke-linecap="round"
		stroke-linejoin="round"
	/>
	<path
		d="M16 11C14.6193 11 13.5 9.88071 13.5 8.5C13.5 7.11929 14.6193 6 16 6C17.3807 6 18.5 7.11929 18.5 8.5C18.5 9.88071 17.3807 11 16 11Z"
		stroke="${code.toString()}"
		stroke-opacity="0.38"
		stroke-width="2"
		stroke-linecap="round"
		stroke-linejoin="round"
	/>
	<path
		d="M9.974 12.6213L18.5 22.0003H6.367C5.34141 22.0003 4.35782 21.5929 3.63262 20.8677C2.90741 20.1425 2.5 19.1589 2.5 18.1333V18.0003C2.5 17.5343 2.675 17.3553 2.99 17.0103L7.02 12.6153C7.20782 12.4104 7.43629 12.2469 7.69083 12.1353C7.94536 12.0236 8.22038 11.9662 8.49832 11.9668C8.77627 11.9674 9.05105 12.0259 9.30513 12.1385C9.55921 12.2512 9.78701 12.4157 9.974 12.6213V12.6213Z"
		stroke="${code.toString()}"
		stroke-opacity="0.38"
		stroke-width="2"
		stroke-linecap="round"
		stroke-linejoin="round"
	/>
</svg>
""");
}
