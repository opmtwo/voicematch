import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:voicevibe/constants/colors.dart';
import 'package:voicevibe/constants/theme.dart';
import 'package:voicevibe/elements/div.dart';
import 'package:voicevibe/form/fab_button.dart';
import 'package:voicevibe/icons/icon_left.dart';

class Header extends StatelessWidget {
  final Color? bg;
  final Color? nextBg;
  final Color? prevBg;
  final List<Widget> children;

  final bool? hasPrev;
  final Widget? prevIcon;
  final VoidCallback? onPrev;

  final bool? hasNext;
  final Widget? nextIcon;
  final VoidCallback? onNext;

  const Header({
    Key? key,
    required this.children,
    this.bg,
    this.nextBg,
    this.prevBg,
    this.hasPrev,
    this.prevIcon,
    this.onPrev,
    this.hasNext,
    this.nextIcon,
    this.onNext,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Div(
      [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Div(
              [
                Visibility(
                  visible: hasPrev == true,
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: FabButton(
                      w: avatarSmall,
                      h: avatarSmall,
                      // alignment: Alignment.centerLeft,
                      prevIcon ??
                          SvgPicture.string(
                            iconLeft(),
                            width: 24,
                          ),
                      bg: prevBg ?? Colors.transparent,
                      onPress: onPrev,
                    ),
                  ),
                ),
              ],
              mr: gap / 2,
            ),
            Expanded(
              flex: 1,
              child: Column(
                children: children,
              ),
            ),
            Div(
              [
                Visibility(
                  visible: hasNext == true,
                  child: Align(
                    alignment: Alignment.topRight,
                    child: FabButton(
                      w: avatarSmall,
                      h: avatarSmall,
                      nextIcon ??
                          const Icon(
                            Icons.arrow_left_rounded,
                            color: colorWhite,
                          ),
                      bg: nextBg ?? Colors.transparent,
                      onPress: onNext,
                    ),
                  ),
                ),
              ],
              ml: gap / 2,
            ),
          ],
        ),
      ],
      bg: bg,
      pb: gap,
      ph: gap,
    );
  }
}
