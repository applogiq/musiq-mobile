import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:musiq/src/features/auth/provider/login_provider.dart';
import 'package:provider/provider.dart';

class SplashProvider extends ChangeNotifier {
  String status = "splash";
  bool isLoading = true;
  bool isLogged = false;

  bool isArtistPreference = false;

  final storage = const FlutterSecureStorage();
  // APICall apiCall = APICall();
  checkLogged(BuildContext context) async {
    Map<String, String> localData = await storage.readAll();

    print(localData["email"]);
    print(localData["password_cred"]);
    context.read<LoginProvider>().emailAddress = localData["email"] ?? "";
    context.read<LoginProvider>().password = localData["password_cred"] ?? "";
    if (localData["email"] != null) {
      context.read<LoginProvider>().login(context);
    }

    notifyListeners();
  }
}
