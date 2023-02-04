import 'package:flutter/material.dart';

import '../color.dart';

BoxDecoration playListNoImageDecoration() {
  return BoxDecoration(
    color: CustomColor.defaultCard,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: CustomColor.defaultCardBorder, width: 2.0),
  );
}

BoxDecoration upNextExpandableDecoration() {
  return const BoxDecoration(
    color: Color.fromRGBO(33, 33, 44, 1),
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(30),
      topRight: Radius.circular(30),
    ),
  );
}

BoxDecoration playerUpImageDecoration() {
  return const BoxDecoration(
      gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          //     stops: [
          //   0.4,
          //   0.01,
          // ],
          colors: [
        Color.fromRGBO(22, 21, 28, 0.3),
        Color.fromRGBO(22, 21, 28, 0),
      ]));
}

BoxDecoration playerDownImageDecoration() {
  return const BoxDecoration(
      gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [
        0.6,
        0.99
      ],
          colors: [
        Color.fromRGBO(22, 21, 28, 0),
        Color.fromRGBO(22, 21, 28, 1),
      ]));
}

BoxDecoration topLeftRightDecoration() {
  return const BoxDecoration(
      color: Color.fromRGBO(33, 33, 44, 1),
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30), topRight: Radius.circular(30)));
}

BoxDecoration dialogBoxDecoration() {
  return BoxDecoration(
    shape: BoxShape.rectangle,
    color: CustomColor.appBarColor,
    borderRadius: BorderRadius.circular(12),
    boxShadow: const [
      BoxShadow(color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
    ],
  );
}
