import 'package:flutter/material.dart';

import 'list_header_widget.dart';

class HorizonalListViewWidget extends StatelessWidget {
  const HorizonalListViewWidget({
    Key? key,
    required this.title,
    required this.actionTitle,
    required this.listWidget,
  }) : super(key: key);

  final String actionTitle;
  final Widget listWidget;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 0.0),
          child: ListHeaderWidget(
            title: title,
            actionTitle: actionTitle,
            dataList: const [],
            callback: () {},
          ),
        ),
        listWidget
      ],
    );
  }
}
