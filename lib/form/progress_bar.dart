import 'package:flutter/material.dart';
import 'package:voicematch/constants/colors.dart';
import 'package:voicematch/elements/div.dart';

class ProgressBar extends StatefulWidget {
  final double value;
  final String? title;

  final Color? bg;
  final Color? fg;

  final double? w;
  final double? h;

  final double? br;

  final int? gutter;

  const ProgressBar({
    Key? key,
    required this.value,
    this.title,
    this.bg,
    this.fg,
    this.w,
    this.h,
    this.br,
    this.gutter,
  }) : super(key: key);

  final double defaultHeight = 4;

  final Color defaultBg = colorSeondary100;
  final Color defaultFg = colorSeondary500;

  @override
  State<ProgressBar> createState() => _ProgressBarState();
}

class _ProgressBarState extends State<ProgressBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _progressAnimationController;

  @override
  void initState() {
    super.initState();
    _progressAnimationController = AnimationController(
      vsync: this,
      duration:
          const Duration(milliseconds: 150), // Adjust the duration as needed
    );
    _progressAnimationController.forward();
  }

  @override
  void dispose() {
    _progressAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Stack(
          children: [
            Div(
              const [],
              h: widget.h ?? widget.defaultHeight,
              br: widget.br,
            ),
            Positioned(
              top: 0,
              right: 0,
              bottom: 0,
              left: 0,
              child: Opacity(
                opacity: 0.4,
                child: Div(
                  const [],
                  bg: widget.bg ?? widget.defaultBg,
                  br: widget.br,
                ),
              ),
            ),
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: widget.value),
              duration: const Duration(milliseconds: 250),
              builder: (context, value, child) {
                return Positioned(
                  top: 0,
                  bottom: 0,
                  left: 0,
                  width: value *
                      (MediaQuery.of(context).size.width -
                          (widget.gutter ?? 0)),
                  child: Div(
                    const [],
                    h: widget.h ?? widget.defaultHeight,
                    bg: widget.fg ?? widget.defaultFg,
                    br: widget.br,
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
