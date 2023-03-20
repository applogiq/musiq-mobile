import 'package:flutter/material.dart';

import '../constants/images.dart';

showLoadingDialog(BuildContext context) {
  AlertDialog alert = AlertDialog(
    content: Image.asset(
      Images.loaderImage,
      height: 70,
    ),
  );
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
