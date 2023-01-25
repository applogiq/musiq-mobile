import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:musiq/src/features/artist/domain/repository/artist_repo.dart';
import 'package:musiq/src/features/common/provider/bottom_navigation_bar_provider.dart';
import 'package:musiq/src/utils/navigation.dart';
import 'package:provider/provider.dart';

import '../../auth/domain/models/user_model.dart';
import '../../auth/domain/repository/auth_repo.dart';
import '../../common/screen/main_screen.dart';
import '../domain/models/artist_model.dart';

class ArtistPreferenceProvider extends ChangeNotifier {
  var isLoaded = false;
  var userFollowedArtist = [];
  ArtistModel? artistModel;

  FlutterSecureStorage storage = const FlutterSecureStorage();

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
    isLoaded = false;
    notifyListeners();
    userFollowedArtist = datas;
    if (datas.isEmpty) {
      await getUserFollowDatas();
    }
    print(userFollowedArtist);

    var response = await AuthRepository().getArtists();
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());
      artistModel = ArtistModel.fromMap(data);
      print(artistModel!.records.length);
      isLoaded = true;
    }
    notifyListeners();
  }

  void followAndUnfollow(Map params) async {
    var res = await ArtistRepo().followAndUnfollow(params);
    print(res.statusCode);
    print(res.body);
  }

  void checkFollow(Record record, int index) async {
    print(record.artistId);
    var userId = await storage.read(key: "register_id");
    if (userFollowedArtist.contains(record.artistId)) {
      artistModel!.records[index].followers = (record.followers! - 1);

      userFollowedArtist.remove(record.artistId);
      notifyListeners();

      Map<String, dynamic> params = {
        "artist_id": record.artistId,
        "follow": false,
        "user_id": userId
      };
      followAndUnfollow(params);
    } else {
      if (artistModel!.records[index].followers == null) {
        artistModel!.records[index].followers = 1;
      } else {
        artistModel!.records[index].followers = (record.followers! + 1);
      }

      userFollowedArtist.add(record.artistId);
      Map<String, dynamic> params = {
        "artist_id": record.artistId,
        "follow": true,
        "user_id": userId
      };
      followAndUnfollow(params);
      notifyListeners();
    }
  }

  navigateToHome(BuildContext context) {
    storage.write(key: "is_preference", value: "true");
    context.read<BottomNavigationBarProvider>().selectedBottomIndex = 0;
    Navigation.removeAllScreenFromStack(context, const MainScreen());
  }
}
