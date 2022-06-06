import 'package:flutter/material.dart';

import '../../../../../helpers/constants/color.dart';

class PlayButtonWidget extends StatelessWidget {
   PlayButtonWidget({
    Key? key,
    this.bgColor=const Color.fromRGBO(255, 255, 255, 0.8),
    this.iconColor=const Color.fromRGBO(254, 86, 49, 1),
    this.size=20.0,this.padding=6.0
  }) : super(key: key);
var bgColor;
var iconColor;
var size;
var padding;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.all(padding),
      decoration:
          BoxDecoration(color: bgColor, shape: BoxShape.circle),
      child: Icon(
        Icons.play_arrow_rounded,
        size: size,
        color: iconColor,
      ),
    );
  }
}
