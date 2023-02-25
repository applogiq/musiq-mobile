import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:musiq/main.dart';

class Auth {
  var storage = const FlutterSecureStorage();

  logOut(BuildContext context) async {
    try {
      objectbox.removeAllData();
      await storage.deleteAll();
      return true;
    } catch (e) {
      return false;
    }
  }
}
