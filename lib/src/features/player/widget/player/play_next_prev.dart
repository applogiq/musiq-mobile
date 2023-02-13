import 'package:flutter/material.dart';

class PlayNextPrev extends StatelessWidget {
  const PlayNextPrev({
    Key? key,
    required this.onTap,
    required this.iconData,
    required this.isEnable,
  }) : super(key: key);

  final IconData iconData;
  final Function onTap;
  final bool isEnable;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: isEnable
            ? () {
                onTap();
              }
            : () {},
        child: Icon(
          iconData,
          size: 34,
          color: isEnable ? Colors.white : Colors.white54,
        ));
  }
}
