import 'package:flutter/material.dart';

import '../../../../../helpers/constants/color.dart';

class PlayButtonWidget extends StatelessWidget {
  const PlayButtonWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.all(6),
      decoration:
          BoxDecoration(color: CustomColor.playIconBg, shape: BoxShape.circle),
      child: Icon(
        Icons.play_arrow_rounded,
        size: 20,
        color: CustomColor.secondaryColor,
      ),
    );
  }
}
