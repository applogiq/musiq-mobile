
import 'package:flutter/material.dart';

class Navigation{
  static Future<dynamic> navigateToScreen(
      BuildContext context, String screen) async {
    var value = await Navigator.pushNamed(
        context, screen);
    return value;
  }
    static navigateReplaceToScreen(BuildContext context, String screen) {
    Navigator.pushReplacementNamed(
        context, screen);
  }
}