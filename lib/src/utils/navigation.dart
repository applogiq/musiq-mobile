import 'package:flutter/material.dart';

class Navigation {
  static Future<dynamic> navigateToScreen(BuildContext context, String screen,
      {Object? args}) async {
    if (args == null) {
      debugPrint("null");
      var value = await Navigator.pushNamed(context, screen);
      return value;
    } else {
      debugPrint("unnull");
      debugPrint(args.toString());
      var value = await Navigator.pushNamed(context, screen, arguments: args);
      return value;
    }
  }

  static navigateReplaceToScreen(BuildContext context, String screen) {
    Navigator.pushReplacementNamed(context, screen);
  }

  static removeAllScreenFromStack(BuildContext context, Widget screen) {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => screen),
        (Route route) => false);
  }
}

class OneTimeNavigation {
  oneTimeNavigation(BuildContext context, Widget screen) {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => screen),
        (Route route) => false);
  }
}
