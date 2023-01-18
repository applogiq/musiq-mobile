import 'package:flutter/material.dart';

class GradientCover extends StatelessWidget {
  const GradientCover({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            tileMode: TileMode.decal,
            begin: Alignment.topCenter,
            end: Alignment(0.0, 1),
            stops: [
              0.1,
              0.9,
            ],
            colors: [
              Color.fromRGBO(22, 21, 28, 0),
              Color.fromRGBO(22, 21, 28, 1),
            ]),
      ),
    );
  }
}
