import 'package:flutter/material.dart';

class PlayNextPrev extends StatelessWidget {
  const PlayNextPrev({
    Key? key,
    required this.onTap,
    required this.iconData,
  }) : super(key: key);

  final IconData iconData;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          onTap();
        },
        child: Icon(
          iconData,
          size: 34,
        ));
  }
}
