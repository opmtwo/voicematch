import 'package:flutter/material.dart';
import 'package:voicematch/elements/p.dart';

class CurrentTime extends StatelessWidget {
  final Duration duration;
  final TextStyle? style;

  const CurrentTime({
    Key? key,
    required this.duration,
    this.style,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return P(
      '${duration.inMinutes.toString().padLeft(2, '0')}:${(((duration.inMilliseconds) / 1000).round() % 60).toString().padLeft(2, '0')}',
      isBody1: true,
      ff: 'Abel',
      style: style,
    );
  }
}
