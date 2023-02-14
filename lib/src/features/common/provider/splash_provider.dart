import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SplashProvider extends ChangeNotifier {
  SplashProvider() {
    checkLogged();
  }
  String status = "splash";
  bool isLoading = true;
  bool isLogged = false;

  bool isArtistPreference = false;

  final storage = const FlutterSecureStorage();
  // APICall apiCall = APICall();
  checkLogged() async {
    Map<String, String> localData = await storage.readAll();
    print("SSS");
    if (localData["access_token"] != null) {
      if (localData["is_preference"] == "true") {
        isArtistPreference = true;
      }
      print("IS image");
      print(localData["is_image"]);
      print(localData["register_id"]);
      isLogged = true;
    } else {
      isLogged = false;
    }
    await Future.delayed(const Duration(seconds: 3), () {
      isLoading = false;
    });
    notifyListeners();
  }
}
