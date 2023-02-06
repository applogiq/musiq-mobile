import 'package:flutter/material.dart';

import '../../../../core/constants/constant.dart';
import '../../widget/up_next/up_next_widgets.dart';

class UpNextExpandable extends StatelessWidget {
  const UpNextExpandable({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height - 40,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      margin: const EdgeInsets.fromLTRB(0, 4, 0, 0),
      decoration: upNextExpandableDecoration(),
      child: Column(
        children: const [
          UpNextExpandableDropDownTile(),
          Expanded(
            child: SongReorderListViewWidget(),
          )
        ],
      ),
    );
  }
}

class UpNext extends StatelessWidget {
  const UpNext({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      ConstantText.upNext,
      style: fontWeight500(size: 16.0),
    );
  }
}
