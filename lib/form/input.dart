import 'dart:math';

import 'package:flutter/material.dart';
import 'package:voicematch/constants/colors.dart';
import 'package:voicematch/constants/theme.dart';

class Input extends StatelessWidget {
  final TextEditingController controller;

  final VoidCallback? onPress;

  final TextInputType? kt;

  final bool? isDisabled;
  final bool? isReadOnly;
  final bool? isPassword;
  final bool? enableSuggestions;
  final bool? autocorrect;

  final String? label;
  final String? help;
  final String? placeholder;
  final Color? placeholderFg;
  final String? error;
  final Color? errorFg;

  final IconData? iconLeft;
  final IconData? iconRight;

  final double? height;

  final double? mt;
  final double? mr;
  final double? mb;
  final double? ml;
  final double? mv;
  final double? mh;

  final double? br;
  final double? brTr;
  final double? brBr;
  final double? brBl;
  final double? brTl;

  final Color? bg;
  final Color? fg;
  final Color? labelFg;

  final Color? iconBg;
  final Color? iconFg;

  final Color? bc;
  final double? bw;

  final int? minLines;
  final int? maxLines;

  final List<BoxShadow>? boxShadow;

  static const double defaultHeight = 40;
  static const double defaultRadius = radius;

  static const Color defaultBg = colorTransparent;
  static const Color defaultFg = colorWhite;

  static const Color defaultIconBg = Colors.transparent;
  static const Color defaultIconFg = colorWhite;

  static const defaultMb = 20;

  static double paddingHorizontal = 15;

  static Color defaultBorderColor = colorWhite;
  static double defaultBorderWidth = 1;

  static const Color defaultPlaceholderFg = Color(0xff666666);

  const Input(
    this.controller, {
    Key? key,
    this.kt,
    this.onPress,
    this.isDisabled,
    this.isReadOnly,
    this.isPassword,
    this.enableSuggestions,
    this.autocorrect,
    this.label,
    this.help,
    this.placeholder,
    this.placeholderFg,
    this.error,
    this.errorFg,
    this.iconLeft,
    this.iconRight,
    this.height,
    this.br,
    this.brTr,
    this.brBr,
    this.brBl,
    this.brTl,
    this.mt,
    this.mr,
    this.mb,
    this.ml,
    this.mv,
    this.mh,
    this.boxShadow,
    this.bg,
    this.fg,
    this.bc,
    this.bw,
    this.minLines,
    this.maxLines,
    this.labelFg,
    this.iconBg,
    this.iconFg,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: mt ?? mv ?? 0,
        right: mr ?? mh ?? 0,
        bottom: mb ?? mv ?? 0,
        left: ml ?? mh ?? 0,
      ),
      child: Center(
        child: TextFormField(
          controller: controller,
          obscureText: isPassword ?? false,
          keyboardType: kt,
          minLines: minLines ?? 1,
          maxLines: maxLines ?? max(minLines ?? 1, maxLines ?? 1),
          enabled: isDisabled != true,
          readOnly: isReadOnly == true,
          autocorrect: autocorrect == true,
          enableSuggestions: enableSuggestions == true,
          decoration: InputDecoration(
            fillColor: bg ?? defaultBg,
            filled: true,
            prefixIcon: iconLeft != null
                ? Icon(
                    iconLeft,
                    color: iconFg ?? defaultIconFg,
                  )
                : null,
            suffixIcon: iconRight != null
                ? Icon(
                    iconRight,
                    color: iconFg ?? defaultIconFg,
                  )
                : null,
            labelText: label,
            hintStyle: TextStyle(
              color: placeholderFg ?? defaultPlaceholderFg,
            ),
            hintText: placeholder,
            helperText: help,
            errorText: error,
            errorStyle: TextStyle(
              color: errorFg ?? colorPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              height: 1,
            ),
            errorMaxLines: 3,
            contentPadding: EdgeInsets.only(
              top: (height ?? defaultHeight) - 28,
              right: gap,
              bottom: (height ?? defaultHeight) - 28,
              left: gap,
            ),
            focusedBorder: OutlineInputBorder(
              // width: 0.0 produces a thin "hairline" border
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(
                  brTr ?? br ?? defaultRadius,
                ),
                bottomRight: Radius.circular(
                  brBr ?? br ?? defaultRadius,
                ),
                bottomLeft: Radius.circular(
                  brBl ?? br ?? defaultRadius,
                ),
                topLeft: Radius.circular(
                  brTl ?? br ?? defaultRadius,
                ),
              ),
              borderSide: BorderSide(
                color: bc ?? defaultBorderColor,
                width: bw ?? defaultBorderWidth,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              // width: 0.0 produces a thin "hairline" border
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(
                  brTr ?? br ?? defaultRadius,
                ),
                bottomRight: Radius.circular(
                  brBr ?? br ?? defaultRadius,
                ),
                bottomLeft: Radius.circular(
                  brBl ?? br ?? defaultRadius,
                ),
                topLeft: Radius.circular(
                  brTl ?? br ?? defaultRadius,
                ),
              ),
              borderSide: BorderSide(
                color: bc ?? defaultBorderColor,
                width: bw ?? defaultBorderWidth,
              ),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.red,
                width: bw ?? defaultBorderWidth,
              ),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(
                  brTr ?? br ?? defaultRadius,
                ),
                bottomRight: Radius.circular(
                  brBr ?? br ?? defaultRadius,
                ),
                bottomLeft: Radius.circular(
                  brBl ?? br ?? defaultRadius,
                ),
                topLeft: Radius.circular(
                  brTl ?? br ?? defaultRadius,
                ),
              ),
            ),
            labelStyle: TextStyle(
              color: labelFg,
            ),
          ),
          onTap: onPress,
          style: TextStyle(
            color: fg ?? defaultFg,
            height: 1,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
