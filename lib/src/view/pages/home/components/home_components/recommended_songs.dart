import 'package:flutter/material.dart';

import '../../../../../helpers/constants/images.dart';
import '../widget/horizontal_list_view.dart';

class RecommendedSongs extends StatelessWidget {
  const RecommendedSongs({
    Key? key,
    required this.images,
  }) : super(key: key);

  final Images images;

  @override
  Widget build(BuildContext context) {
    return HorizonalListViewWidget(
        title: "Recommended songs",
        actionTitle: "",
        listWidget:
            CustomHorizontalListview(images: images.recommendedSong));
  }
}

