import 'package:flutter/material.dart';
import 'package:voicevibe/constants/colors.dart';

class CheckBox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;

  final Color? activeColor;
  final Color? checkColor;
  final Color? uncheckedBorderColor;

  final double? size;
  final double? borderWidth;

  final EdgeInsetsGeometry? margin;

  const CheckBox({
    Key? key,
    required this.value,
    this.onChanged,
    this.activeColor,
    this.checkColor,
    this.uncheckedBorderColor,
    this.size,
    this.borderWidth,
    this.margin,
  }) : super(key: key);

  static const Color defaultActiveColor = colorPrimary;
  static const Color defaultCheckColor = colorWhite;
  static const Color defaultUncheckedBorderColor = colorWhite;
  static const double defaultSize = 24.0;
  static const double defaultBorderWidth = 2.0;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(4.0);
    final border = Border.all(
      color: value
          ? (activeColor ?? defaultActiveColor)
          : (uncheckedBorderColor ?? defaultUncheckedBorderColor),
      width: borderWidth ?? defaultBorderWidth,
    );

    return Container(
      margin: margin,
      width: size ?? defaultSize,
      height: size ?? defaultSize,
      decoration: BoxDecoration(
        color: value ? (activeColor ?? defaultActiveColor) : colorTransparent,
        borderRadius: borderRadius,
        border: border,
      ),
      child: Material(
        color: colorTransparent,
        child: InkWell(
          onTap: () {
            if (onChanged != null) {
              onChanged!(!value);
            }
          },
          borderRadius: borderRadius,
          child: Center(
            child: Icon(
              Icons.check,
              size: size != null ? size! - 6.0 : defaultSize - 6.0,
              color:
                  value ? (checkColor ?? defaultCheckColor) : colorTransparent,
            ),
          ),
        ),
      ),
    );
  }
}
