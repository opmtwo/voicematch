import 'package:flutter/widgets.dart';

class MediaQueryUtils {
  // Family & Model	    Logical Width	  Logical Height	Physical Width	Physical Height	PPI	  Sc
  // iPhone 13	        390	            844	            1170	          2532	          460	  3
  // iPhone 13 mini	    375	            812	            1080	          2340	          476	  3
  // iPhone 13 Pro Max	428	            926	            1284	          2778	          458	  3

  static bool isMini(MediaQueryData query) {
    return query.size.width <= 375;
  }

  static bool isPro(MediaQueryData query) {
    return query.size.width > 375 && query.size.width <= 400;
  }

  static bool isMax(MediaQueryData query) {
    return query.size.width > 400;
  }
}
