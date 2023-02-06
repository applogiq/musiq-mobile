import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Auth {
  var storage = const FlutterSecureStorage();

  logOut() async {
    try {
      await storage.deleteAll();
      return true;
    } catch (e) {
      return false;
    }
  }
}
