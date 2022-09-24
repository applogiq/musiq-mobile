import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:musiq/src/logic/controller/basic_controller.dart';
import 'package:musiq/src/model/api_model/artist_model.dart';
import 'package:musiq/src_main/api/model/user_model.dart';
import 'package:musiq/src_main/api/repo/auth/auth_repo.dart';

class ArtistPreferenceProvider extends ChangeNotifier {
  var isLoaded = false;
  var userFollowedArtist = [];
  ArtistModel? artistModel;
  FlutterSecureStorage storage = FlutterSecureStorage();

  getUserFollowDatas() async {
    Map<String, String> allValues = await storage.readAll();

    if (allValues["access_token"] != null) {
      Map<String, dynamic> params = {
        "email": allValues["email"],
        "password": allValues["password_cred"]
      };

      var res = await AuthRepository().login(params);

      var data = jsonDecode(res.body.toString());
      UserModel user = UserModel.fromMap(data);
      await storage.deleteAll();

      var userData = user.records.toMap();
      for (final name in userData.keys) {
        final value = userData[name];
        // debugPrint('$name,$value');
        await storage.write(
          key: name,
          value: value.toString(),
        );
      }
      await storage.write(
          key: "artist_list",
          value: jsonEncode(user.records.preference.artist));
      await storage.write(key: "password_cred", value: params["password"]);
      var list1 = await storage.read(key: "artist_list");
      userFollowedArtist = user.records.preference.artist;
    }
  }

  void loadData(List datas) async {
    userFollowedArtist = datas;
    if (datas.isEmpty) {
      await getUserFollowDatas();
    }
    print(userFollowedArtist);
    isLoaded = false;
    var response = await AuthRepository().getArtists();
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());
      artistModel = ArtistModel.fromMap(data);
      print(artistModel!.records.length);
      isLoaded = true;
    }
    notifyListeners();
  }

  // void followAndUnfollow(Map params) async {
  //   var res =
  //       await apiCall.putRequestWithAuth(APIConstants.ARTIST_FOLLOWING, params);
  //   print(res.statusCode);
  // }

  // void checkFollow(Record record, int index) {
  //   print(record.artistId);
  //   if (userFollowedArtist.contains(record.artistId)) {
  //     artistModel!.records[index].followers = (record.followers! - 1);

  //     userFollowedArtist.remove(record.artistId);
  //     update();
  //     Map<String, dynamic> params = {
  //       "artist_id": record.artistId,
  //       "follow": false
  //     };
  //     followAndUnfollow(params);
  //   } else {
  //     if (artistModel!.records[index].followers == null) {
  //       artistModel!.records[index].followers = 1;
  //     } else {
  //       artistModel!.records[index].followers = (record.followers! + 1);
  //     }

  //     userFollowedArtist.add(record.artistId);
  //     Map<String, dynamic> params = {
  //       "artist_id": record.artistId,
  //       "follow": true
  //     };
  //     followAndUnfollow(params);
  //     notifyListeners();
  //   }
  // }

}
