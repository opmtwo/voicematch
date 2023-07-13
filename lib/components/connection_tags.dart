import 'package:flutter/material.dart';
import 'package:voicematch/constants/colors.dart';
import 'package:voicematch/constants/theme.dart';
import 'package:voicematch/constants/types.dart';
import 'package:voicematch/elements/div.dart';
import 'package:voicematch/elements/p.dart';

class ConnectionTags extends StatelessWidget {
  final String label;
  final ConnectionModel item;

  const ConnectionTags({
    Key? key,
    required this.label,
    required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> options = [];
    final member = item.member;

    if (member.interestCreativity != null) {
      options.add({
        'id': 'interestCreativity',
        'value': member.interestCreativity as String,
        'bg': colorSeondary,
        'fg': colorBlack,
      });
    }
    if (member.interestSports != null) {
      options.add({
        'id': 'interestSports',
        'value': member.interestSports as String,
        'bg': colorSeondary,
        'fg': colorBlack,
      });
    }
    if (member.interestVideo != null) {
      options.add({
        'id': 'interestVideo',
        'value': member.interestVideo as String,
        'bg': colorSeondary,
        'fg': colorBlack,
      });
    }
    if (member.interestMusic != null) {
      options.add({
        'id': 'interestMusic',
        'value': member.interestMusic as String,
        'bg': colorSeondary200,
        'fg': colorBlack,
      });
    }
    if (member.interestTravelling != null) {
      options.add({
        'id': 'interestTravelling',
        'value': member.interestTravelling as String,
        'bg': colorSeondary200,
        'fg': colorBlack,
      });
    }
    if (member.interestPet != null) {
      options.add({
        'id': 'interestPet',
        'value': member.interestPet as String,
        'bg': colorSeondary200,
        'fg': colorBlack,
      });
    }

    return Div(
      [
        Div(
          [
            P(
              label,
              fg: colorBlack,
            ),
          ],
          mb: gap / 2,
        ),
        Wrap(
          alignment: WrapAlignment.center,
          runSpacing: gap / 2,
          spacing: gap / 2,
          children: List.generate(
            options.length,
            (index) {
              final activeItem = options[index];
              return Div(
                [
                  P(
                    activeItem['value'],
                    isBody1: true,
                    fg: activeItem['fg'],
                  ),
                ],
                ph: gap / 2,
                pv: gap / 2,
                bg: activeItem['bg'],
                br: 99,
              );
            },
          ),
        ),
      ],
      mb: gap,
    );
  }
}
