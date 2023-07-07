import 'package:flutter/material.dart';

class Hr extends StatelessWidget {
  final double w;
  final double h;
  final Color bc;

  const Hr({
    Key? key,
    this.w = double.infinity,
    this.h = 1.0,
    this.bc = Colors.black26,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: h,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: bc,
            width: h,
          ),
        ),
      ),
    );
  }
}
