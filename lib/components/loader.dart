import 'dart:async';

import 'package:flutter/material.dart';
import 'package:voicevibe/components/slider_dots.dart';
import 'package:voicevibe/elements/div.dart';

class Loader extends StatefulWidget {
  const Loader({super.key});

  @override
  State<Loader> createState() => _LoaderState();
}

/// AnimationControllers can be created with `vsync: this` because of TickerProviderStateMixin.
class _LoaderState extends State<Loader> with TickerProviderStateMixin {
  _LoaderState();

  // timer to control loading dots
  late Timer timer;

  int index = 0;

  @override
  initState() {
    super.initState();
    timer = Timer.periodic(const Duration(milliseconds: 500), (timer) async {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        index = (index + 1) % 3;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Div(
      [
        Image.asset(
          'assets/images/logo.png',
          width: 64,
        ),
        Div(
          [
            SliderDots(
              total: 3,
              index: index,
              w: 8,
              h: 8,
            ),
          ],
        ),
      ],
    );
  }
}
