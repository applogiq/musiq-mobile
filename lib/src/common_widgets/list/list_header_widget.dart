import 'package:flutter/material.dart';

import '../../core/constants/constant.dart';

class ListHeaderWidget extends StatelessWidget {
  const ListHeaderWidget(
      {Key? key,
      required this.title,
      required this.actionTitle,
      required this.dataList,
      required this.callback})
      : super(key: key);

  final String actionTitle;
  final Function callback;
  final List dataList;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const Spacer(),
        InkWell(
          onTap: () {
            callback();
          },
          child: Text(
            actionTitle,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: CustomColor.secondaryColor),
          ),
        )
      ],
    );
  }
}
