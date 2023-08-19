import 'package:flutter/material.dart';
import 'package:voicevibe/components/icon_box.dart';
import 'package:voicevibe/constants/colors.dart';
import 'package:voicevibe/constants/theme.dart';
import 'package:voicevibe/elements/div.dart';
import 'package:voicevibe/form/progress_bar.dart';

class ProgressBarAlt extends StatefulWidget {
  final double total;
  final double value;
  final int? gutter;
  final Color? trackBg;
  final Color? trackFg;
  final Color? thumbBg = colorSeondary050;
  final Color? thumbFg = colorSeondary500;

  const ProgressBarAlt({
    Key? key,
    required this.value,
    required this.total,
    this.gutter,
    this.trackBg,
    this.trackFg,
  }) : super(key: key);

  @override
  State<ProgressBarAlt> createState() => _ProgressBarAltState();
}

class _ProgressBarAltState extends State<ProgressBarAlt>
    with SingleTickerProviderStateMixin {
  late final AnimationController _circleAnimationController;

  @override
  void initState() {
    super.initState();
    _circleAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 150,
      ), // Adjust the duration as needed
    );
    _circleAnimationController.forward();
  }

  @override
  void dispose() {
    _circleAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: const [
            Div(
              [],
              h: 40,
            ),
          ],
        ),
        Div([
          ProgressBar(
            value: widget.value / widget.total,
            h: 4,
            gutter: widget.gutter ?? (gap * 2).toInt(),
            bg: widget.trackBg,
            fg: widget.trackFg,
            br: radius,
          ),
        ], pt: 18),
        TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0, end: widget.value),
          duration: const Duration(milliseconds: 250),
          builder: (context, value, child) {
            double leftPosition = value /
                widget.total *
                (MediaQuery.of(context).size.width -
                    (widget.gutter ?? (gap * 2)) -
                    40);
            return Positioned(
              top: 0,
              left: leftPosition,
              child: IconBox(
                const Div([]),
                w: 40,
                h: 40,
                bg: widget.thumbBg,
              ),
            );
          },
        ),
        TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0, end: widget.value),
          duration: const Duration(milliseconds: 250),
          builder: (context, value, child) {
            double leftPosition = value /
                    widget.total *
                    (MediaQuery.of(context).size.width -
                        (widget.gutter ?? (gap * 2)) - // gap on both sides
                        40) + // circle width
                10; // shift center circle to center of parent circle
            return Positioned(
              top: 10,
              left: leftPosition,
              child: IconBox(
                const Div([]),
                w: 20,
                h: 20,
                bg: widget.thumbFg,
              ),
            );
          },
        ),
      ],
    );
  }
}
