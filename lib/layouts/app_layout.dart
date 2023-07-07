import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:voicematch/constants/colors.dart';
import 'package:voicematch/elements/div.dart';

class AppLayout extends StatefulWidget {
  final Widget child;
  final Color? bg;
  final bool? isAuthOnly;
  final bool? isGuestOnly;

  const AppLayout(
    this.child, {
    Key? key,
    this.isAuthOnly,
    this.isGuestOnly,
    this.bg,
  }) : super(key: key);

  @override
  State<AppLayout> createState() => _AppLayoutState();
}

class _AppLayoutState extends State<AppLayout> {
  final isAuthBusy = true.obs;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Div(
      [
        Expanded(
          flex: 1,
          child: widget.child,
        )
      ],
      bg: widget.bg ?? colorWhite,
    );
  }
}
