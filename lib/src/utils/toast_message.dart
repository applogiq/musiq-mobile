import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../constants/color.dart';

toastMessage(String messageContent, Color backgroundColor, Color textColor) {
  Fluttertoast.showToast(
      msg: messageContent,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 5,
      backgroundColor: backgroundColor,
      textColor: textColor,
      fontSize: 16.0);
}

errorToastMessage(
  String messageContent,
) {
  Fluttertoast.showToast(
      msg: messageContent,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 5,
      backgroundColor: CustomColor.errorStatusColor,
      textColor: Colors.white,
      fontSize: 16.0);
}

successToastMessage(
  String messageContent,
) {
  Fluttertoast.showToast(
      msg: messageContent,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 5,
      backgroundColor: CustomColor.successStatusColor,
      textColor: Colors.white,
      fontSize: 16.0);
}

normalToastMessage(
  String messageContent,
) {
  Fluttertoast.showToast(
      msg: messageContent,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 5,
      backgroundColor: Colors.grey,
      textColor: Colors.black,
      fontSize: 16.0);
}
