import 'package:flutter/material.dart';

class PlayButtonWidget extends StatelessWidget {
   PlayButtonWidget({
    Key? key,
    this.bgColor=const Color.fromRGBO(255, 255, 255, 0.8),
    this.iconColor=const Color.fromRGBO(254, 86, 49, 1),
    this.size=20.0,this.padding=6.0,this.icon=Icons.play_arrow
  }) : super(key: key);
var bgColor;
var iconColor;
var size;
var padding;
var icon;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.all(padding),
      decoration:
          BoxDecoration(color: bgColor, shape: BoxShape.circle),
      child: Icon(
        icon,
        size: size,
        color: iconColor,
      ),
    );
  }
}
