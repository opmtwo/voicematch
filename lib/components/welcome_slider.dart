import 'dart:async';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:voicevibe/components/icon_box.dart';
import 'package:voicevibe/components/logo.dart';
import 'dart:math' as math;
import 'package:voicevibe/components/slider_dots.dart';
import 'package:voicevibe/constants/colors.dart';
import 'package:voicevibe/constants/theme.dart';
import 'package:voicevibe/elements/div.dart';
import 'package:voicevibe/elements/p.dart';
import 'package:voicevibe/icons/icon_slide1.dart';
import 'package:voicevibe/icons/icon_slide2.dart';
import 'package:voicevibe/icons/icon_slide3.dart';

class WelcomeSlider extends StatefulWidget {
  const WelcomeSlider({
    super.key,
    required this.index,
    required this.length,
    required this.onContinue,
  });

  final int index;
  final int length;
  final Function(int) onContinue;

  @override
  State<WelcomeSlider> createState() => _WelcomeSliderState();
}

/// AnimationControllers can be created with `vsync: this` because of TickerProviderStateMixin.
class _WelcomeSliderState extends State<WelcomeSlider>
    with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 500),
    vsync: this,
  );
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.elasticOut,
  );

  Timer? timer;

  _WelcomeSliderState();

  static List<String> images = [
    iconSlide1(),
    iconSlide2(),
    iconSlide3(),
  ];

  static List<String> titles = [
    'VOICE ONLY',
    '10 MINUTES MINIMUM\nCONVERSATION',
    'MATCH ONLY IF YOU\nWANT',
  ];

  static List<String> texts = [
    'RULE 1: You match with your voice. Only that and your blurred image is visible. Maximum secure.',
    'RULE 2: No superficial swipe marathon. You have to talk for 10 Minutes minimum in order to reveal your full self to the other side.',
    'RULE 3: Once your revealed and you are still not convinced, you are able to cut it short and stop dating right there.',
  ];

  getRotation(int activeIndex, int index) =>
      (180 - (math.min(activeIndex, 2) * -90 + index * 90)) / 360;

  @override
  void initState() {
    super.initState();
    initTimer();
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }

  void initTimer() {
    timer?.cancel();
    if (!mounted) {
      return;
    }
    timer = Timer.periodic(
      const Duration(seconds: 6),
      (newTimer) {
        if (!mounted) {
          timer?.cancel();
          return;
        }
        widget.onContinue(
          (widget.index + 1) % widget.length,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Div(
        [
          // const Logo(),
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Div(
                  [
                    const Div(
                      [
                        Logo(),
                      ],
                      mb: gap,
                    ),
                    P(
                      texts[widget.index],
                      isBody1: true,
                      fg: colorWhite,
                      ta: TextAlign.center,
                    ),
                  ],
                  pv: 100,
                ),
              ],
            ),
          ),
          Div(
            [
              ConstrainedBox(
                constraints: const BoxConstraints.tightForFinite(
                  width: 280,
                  height: 280,
                ),
                child: GestureDetector(
                  onHorizontalDragEnd: (details) {
                    int sensitivity = 8;
                    safePrint(details.primaryVelocity);

                    // Swiping in right direction.
                    if (details.primaryVelocity! < sensitivity) {
                      widget.onContinue((widget.index + 1) % widget.length);
                      initTimer();
                    }

                    // Swiping in left direction.
                    if (details.primaryVelocity! > -sensitivity) {
                      widget.onContinue(
                          (widget.index - 1 + widget.length) % widget.length);
                      initTimer();
                    }
                  },
                  child: Stack(
                    children: List.generate(
                      images.length,
                      (i) {
                        return Stack(
                          children: [
                            Positioned(
                              top: 0,
                              right: 0,
                              left: 0,
                              child: AnimatedOpacity(
                                curve: Curves.easeInOut,
                                duration: const Duration(milliseconds: 250),
                                opacity: i == widget.index ? 1 : 0,
                                child: const Div(
                                  [
                                    IconBox(
                                      Div([]),
                                      w: 280,
                                      h: 280,
                                    ),
                                  ],
                                  bg: colorSeondary050,
                                  br: 140,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              left: 0,
                              child: AnimatedOpacity(
                                curve: Curves.easeInOut,
                                duration: const Duration(milliseconds: 250),
                                opacity: i == widget.index ? 1 : 0,
                                child: Div(
                                  [
                                    P(
                                      titles[i],
                                      fg: const Color(0xFF170F0F),
                                      fz: 15,
                                      fw: FontWeight.w700,
                                      ta: TextAlign.center,
                                    ),
                                    SvgPicture.string(
                                      images[i],
                                      // width: 500,
                                      height: 160,
                                    ),
                                  ],
                                  pt: 50,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
              Div(
                [
                  SliderDots(
                    total: images.length,
                    index: widget.index,
                  )
                ],
                mt: gap / 2,
                pb: gap,
              )
            ],
          ),
        ],
        ph: gap,
        pb: gap,
      ),
    );
  }
}
