import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:voicevibe/icons/icon_wave.dart';
import 'package:voicevibe/icons/icon_wave_alt.dart';
import 'package:voicevibe/utils/svg_utils.dart';

class Wave extends StatelessWidget {
  final double total;
  final double value;
  final double? w;
  final Color? bg;
  final Color? fg;
  final bool? alt;

  const Wave({
    Key? key,
    required this.total,
    required this.value,
    this.w,
    this.bg,
    this.fg,
    this.alt,
  }) : super(key: key);

  final double defaultWidth = 256;
  final Color defaultFg = const Color(0xFF132D84);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          child: SvgPicture.string(
            alt == true ? iconWaveAlt() : iconWave(),
            width: w ?? defaultWidth,
            color: bg,
          ),
        ),
        ClipPath(
          clipper: PercentageClipper(
            percent: 100 - (value / total * 100),
          ), // Set the desired percentage here
          child: SvgPicture.string(
            alt == true ? iconWaveAlt() : iconWave(),
            width: w ?? defaultWidth,
            color: fg ?? defaultFg,
          ),
        ),
      ],
    );
  }
}
