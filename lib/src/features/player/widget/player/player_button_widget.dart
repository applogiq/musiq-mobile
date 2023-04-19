import 'package:flutter/material.dart';

class PlayButtonWidget extends StatelessWidget {
  const PlayButtonWidget(
      {Key? key,
      this.bgColor = const Color.fromRGBO(255, 255, 255, 0.9),
      this.iconColor = const Color.fromRGBO(254, 86, 49, 1),
      this.size = 20.0,
      this.padding = 6.0,
      this.icon = Icons.play_arrow})
      : super(key: key);

  final Color bgColor;
  final IconData icon;
  final Color iconColor;
  final double padding;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: const EdgeInsets.all(8),
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
      child: Icon(
        icon,
        size: size,
        color: iconColor,
      ),
    );
  }
}
