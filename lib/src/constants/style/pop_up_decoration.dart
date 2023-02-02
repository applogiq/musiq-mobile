import 'package:flutter/material.dart';

RoundedRectangleBorder popUpDecorationContainer() {
  return const RoundedRectangleBorder(
    borderRadius: BorderRadius.only(
      bottomLeft: Radius.circular(8.0),
      bottomRight: Radius.circular(8.0),
      topLeft: Radius.circular(8.0),
      topRight: Radius.circular(8.0),
    ),
  );
}
