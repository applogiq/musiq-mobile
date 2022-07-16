import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:musiq/src/logic/controller/basic_controller.dart';
import 'package:musiq/src/model/api_model/artist_model.dart';

import '../../helpers/constants/api.dart';
import '../../model/api_model/user_model.dart';
import '../services/api_call.dart';
import '../services/api_route.dart';

class ArtistPreferenceController extends GetxController {
  BasicController basicController = BasicController();

  var isLoaded = false.obs;
  APIRoute apiRoute = APIRoute();
  APICall apiCall = APICall();
  var userFollowedArtist = [].obs;
  ArtistModel? artistModel;
  FlutterSecureStorage storage = FlutterSecureStorage();

  getUserFollowDatas() async {
    Map<String, String> allValues = await storage.readAll();

    if (allValues["access_token"] != null) {
      Map<String, dynamic> params = {
        "email": allValues["email"],
        "password": allValues["password_cred"]
      };
      var url = Uri.parse(
          APIConstants.BASE_URL.toString() + APIConstants.LOGIN.toString());

      var res = await apiCall.postRequestWithoutAuth(url, params);

      var data = jsonDecode(res.body.toString());
      User user = User.fromMap(data);
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
      userFollowedArtist.value = user.records.preference.artist;

// user.records.preference.artist
      //   if (user.records.isPreference == false) {
      //     Navigator.of(context).pushReplacement(MaterialPageRoute(
      //         builder: (context) => ArtistPreferenceMain(
      //               artist_list: user.records.preference.artist,
      //             )));
      //   }
      //   //  else {
      //   //   Navigation.navigateReplaceToScreen(context, "bottom/");
      //   // }
      // } else {
      //   Navigation.navigateReplaceToScreen(context, 'onboarding/');
    }
  }

  void loadData(List datas) async {
    userFollowedArtist.value = datas;
    if (datas.isEmpty) {
      await getUserFollowDatas();
    }
    print(userFollowedArtist.value);
    isLoaded.value = false;
    artistModel = await apiRoute.getArtist();

    print(artistModel!.records.length);
    isLoaded.value = true;
  }

  void followAndUnfollow(Map params) async {
    var res =
        await apiCall.putRequestWithAuth(APIConstants.ARTIST_FOLLOWING, params);
    print(res.statusCode);
  }

  void checkFollow(Record record, int index) {
    print(record.artistId);
    if (userFollowedArtist.contains(record.artistId)) {
      artistModel!.records[index].followers = (record.followers! - 1);

      userFollowedArtist.remove(record.artistId);
      update();
      Map<String, dynamic> params = {
        "artist_id": record.artistId,
        "follow": false
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
        "follow": true
      };
      followAndUnfollow(params);
      update();
    }
  }
}
