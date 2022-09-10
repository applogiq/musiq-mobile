import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:musiq/src/constants/api.dart';
import 'package:musiq/src/helpers/utils/navigation.dart';
import 'package:musiq/src/logic/services/api_call.dart';
import 'package:musiq/src/model/api_model/user_model.dart';
import 'package:musiq/src/view/pages/artist_preference/artist_preference.dart';

class SplashProvider extends ChangeNotifier {
  SplashProvider() {
    checkLogged();
  }
  String status = "splash";
  bool isLoading = true;
  bool isLogged = false;

  bool isArtistPreference = false;

  final storage = const FlutterSecureStorage();
  APICall apiCall = APICall();
  checkLogged() async {
    Map<String, String> localData = await storage.readAll();
    if (localData["access_token"] != null) {
      if (localData["is_preference"] == "true") {
        isArtistPreference = true;
      }

      isLogged = true;
    } else {
      isLogged = false;
    }
    await Future.delayed(Duration(seconds: 3), () {
      isLoading = false;
    });
    notifyListeners();
  }

  // checkLogged() async {
  //   Map<String, String> allValues = await storage.readAll();

  //   if (allValues["access_token"] != null) {
  //     Map<String, dynamic> params = {
  //       "email": allValues["email"],
  //       "password": allValues["password_cred"]
  //     };
  //     var url = Uri.parse(
  //         APIConstants.BASE_URL.toString() + APIConstants.LOGIN.toString());

  //     var res = await apiCall.postRequestWithoutAuth(url, params);

  //     var data = jsonDecode(res.body.toString());
  //     User user = User.fromMap(data);
  //     await storage.deleteAll();

  //     var userData = user.records.toMap();
  //     for (final name in userData.keys) {
  //       final value = userData[name];
  //       debugPrint('$name,$value');
  //       await storage.write(
  //         key: name,
  //         value: value.toString(),
  //       );
  //     }
  //     await storage.write(
  //         key: "artist_list",
  //         value: jsonEncode(user.records.preference.artist));
  //     await storage.write(key: "password_cred", value: params["password"]);
  //     var list1 = await storage.read(key: "artist_list");
  //     isLogged=true;
  //     // if (user.records.isPreference == false) {
  //     //   // Navigator.of(context).pushReplacement(MaterialPageRoute(
  //     //   //     builder: (context) => ArtistPreferenceMain(
  //     //   //           artist_list: user.records.preference.artist,
  //     //   //         )));
  //     // } else {
  //     //   // Navigation.navigateReplaceToScreen(context, "bottom/");
  //     // }
  //   } else {
  //     isLogged=false;
  //     // Navigation.navigateReplaceToScreen(context, 'onboarding/');
  //   }
  //   notifyListeners();
  // }

}
