import 'package:flutter/material.dart';
import 'package:voicematch/components/connection_pic.dart';
import 'package:voicematch/constants/colors.dart';
import 'package:voicematch/constants/theme.dart';
import 'package:voicematch/constants/types.dart';
import 'package:voicematch/elements/div.dart';
import 'package:voicematch/elements/p.dart';
import 'package:voicematch/utils/date_utils.dart';

class ConnectionHeader extends StatelessWidget {
  final ConnectionModel? item;

  const ConnectionHeader({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (item != null)
          Div(
            [
              ConnectionPic(item: item as ConnectionModel),
            ],
            mr: gap / 2,
          ),
        if (item != null)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              P(
                item?.member.givenName,
                isH5: true,
                fg: colorBlack,
              ),
              if (item?.onlinePresence?.id != null)
                P(
                  'Last seen ${gethumanTimeDiff(item?.onlinePresence?.lastSeenAt as String).toLowerCase()}',
                  isBody2: true,
                ),
            ],
          ),
      ],
    );
  }
}
