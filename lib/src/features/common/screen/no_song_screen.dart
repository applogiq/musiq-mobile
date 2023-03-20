import 'package:flutter/cupertino.dart';

import '../../../core/constants/color.dart';
import '../../../core/constants/images.dart';
import '../../../core/constants/style.dart';

class NoSongScreen extends StatelessWidget {
  const NoSongScreen({
    Key? key,
    this.isFav = false,
    required this.mainTitle,
    required this.subTitle,
  }) : super(key: key);
  final bool isFav;
  final String mainTitle;
  final String subTitle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              Images.noFav,
              width: 200,
            ),
            Text(
              mainTitle,
              style: fontWeight500(size: 16.0),
            ),
            Text(
              subTitle,
              style: fontWeight400(color: CustomColor.subTitle),
            ),
          ],
        ),
      ),
    );
  }
}
