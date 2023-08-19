import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:voicevibe/elements/div.dart';
import 'package:voicevibe/form/input.dart';

const double kItemExtent = 32.0;

class Select extends StatelessWidget {
  final TextEditingController controller;
  final List options;
  final String? idField = 'id';
  final String? nameField = 'name';
  final int? index;
  final String? error;

  final Function(int)? onChange;

  const Select(
    this.controller, {
    Key? key,
    required this.options,
    this.index,
    this.onChange,
    this.error,
  }) : super(key: key);

  // This shows a CupertinoModalPopup with a reasonable fixed height which hosts CupertinoPicker.
  void showDialog(Widget child, BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        // The Bottom margin is provided to align the popup above the system navigation bar.
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        // Provide a background color for the popup.
        color: CupertinoColors.systemBackground.resolveFrom(context),
        // Use a SafeArea widget to avoid system overlaps.
        child: SafeArea(
          top: false,
          child: child,
        ),
      ),
    );
  }

  onSelectedItemChanged(int selectedItem) {
    controller.text = options[selectedItem]?[nameField] ?? '';
    if (onChange != null) {
      onChange!(selectedItem);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Div(
      [
        Input(
          controller,
          isReadOnly: true,
          iconRight: Icons.arrow_downward_rounded,
          onPress: () {
            if (options.isEmpty) {
              return;
            }
            return showDialog(
              CupertinoPicker(
                scrollController: FixedExtentScrollController(
                  initialItem: index ?? 0,
                ),
                magnification: 1.22,
                squeeze: 1.2,
                useMagnifier: true,
                itemExtent: kItemExtent,
                // This is called when selected item is changed.
                onSelectedItemChanged: (int selectedItem) {
                  controller.text = options[selectedItem]?[nameField] ?? '';
                  if (onChange != null) {
                    onChange!(selectedItem);
                  }
                },
                children: List<Widget>.generate(
                  options.length,
                  (int index) {
                    return Text(
                      options[index][nameField ?? idField ?? 'id'],
                    );
                  },
                ),
              ),
              context,
            );
          },
          error: error,
        ),
      ],
    );
  }
}
