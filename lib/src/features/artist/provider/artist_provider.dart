// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:musiq/src/features/search/provider/search_provider.dart';
import 'package:provider/provider.dart';

import '../../../core/utils/navigation.dart';
import '../../auth/domain/models/user_model.dart';
import '../../auth/domain/repository/auth_repo.dart';
import '../../common/provider/bottom_navigation_bar_provider.dart';
import '../../common/screen/main_screen.dart';
import '../domain/models/artist_model.dart';
import '../domain/repository/artist_repo.dart';

class ArtistPreferenceProvider extends ChangeNotifier {
  ArtistModel? artistModel;
  var isLoaded = false;
  FlutterSecureStorage storage = const FlutterSecureStorage();
  var userFollowedArtist = [];
  // Get the current user followed artist details
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
        //
        await storage.write(
          key: name,
          value: value.toString(),
        );
      }
      await storage.write(
          key: "artist_list",
          value: jsonEncode(user.records.preference.artist));
      await storage.write(key: "password_cred", value: params["password"]);

      userFollowedArtist = user.records.preference.artist;
    }
  }

  // Get the all artist details
  void loadData(List datas) async {
    isLoaded = false;
    notifyListeners();
    userFollowedArtist = datas;
    if (datas.isEmpty) {
      await getUserFollowDatas();
    }

    var response = await AuthRepository().getArtists();

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());
      artistModel = ArtistModel.fromMap(data);

      isLoaded = true;
    }
    notifyListeners();
  }

  // Method for follow and unfollow the artist API call
  void followAndUnfollow(Map params) async {
    await ArtistRepo().followAndUnfollow(params);
  }

  // Method for check user already followed or not and call the method followAndUnfollow method
  void checkFollow(Record record, int index, BuildContext context) async {
    var userId = await storage.read(key: "register_id");
    if (userFollowedArtist.contains(record.artistId)) {
      artistModel!.records[index].followers = (record.followers! - 1);

      userFollowedArtist.remove(record.artistId);
      context.read<SearchProvider>().userFollowedArtist.remove(record.artistId);
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
      context.read<SearchProvider>().userFollowedArtist.add(record.artistId);
      Map<String, dynamic> params = {
        "artist_id": record.artistId,
        "follow": true,
        "user_id": userId
      };
      followAndUnfollow(params);

      notifyListeners();
    }
  }

  // Method for navigate artist preference select screen to home screen
  navigateToHome(BuildContext context) {
    storage.write(key: "is_preference", value: "true");
    context.read<BottomNavigationBarProvider>().selectedBottomIndex = 0;
    Navigation.removeAllScreenFromStack(context, const MainScreen());
  }
}
