import 'package:flutter/material.dart';
import 'package:musiq/src/constants/images.dart';

import '../widget/horizontal_list_view.dart';
import '../widget/vertical_list_view.dart';

class BasedOnYourInterest extends StatelessWidget {
  const BasedOnYourInterest({
    Key? key,
    required this.images,
  }) : super(key: key);

  final Images images;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Column(
        children: [
          ListHeaderWidget(
              title: "Based on your Interest", actionTitle: "",dataList: [],),
          Container(
              margin: EdgeInsets.only(top: 10),
              child: CustomSongVerticalList(
                  songList: images.basedOnYourInterestList, ))
        ],
      ),
    );
  }
}


