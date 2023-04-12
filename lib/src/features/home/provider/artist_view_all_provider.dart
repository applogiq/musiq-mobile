import 'dart:convert';
import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:musiq/src/features/home/screens/artist_view_all/preferable_artist.dart';
import '../domain/model/collection_view_all_model.dart';

import '../../artist/domain/models/artist_model.dart';
import '../domain/repository/home_repo.dart';
import 'package:http/http.dart' as http;

class ArtistViewAllProvider extends ChangeNotifier {
  bool isLoad = true;
  bool ispreferableartist = true;
  bool isViewAllSongLoad = true;
  bool isUpNextShow = false;

  ArtistModel artistModel = ArtistModel(
      success: false, message: "No records", records: [], totalRecords: 0);
  CollectionViewAllModel collectionViewAllModel = CollectionViewAllModel(
      success: false, message: "No records", records: [], totalrecords: 0);
  HomeRepository homeRepository = HomeRepository();
  Preferableartistmodel preferableartistmodel = Preferableartistmodel(
      success: false, message: "No records", records: [], totalRecords: 0);
  FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  preferableArtistList() async {
    ispreferableartist = true;
    var accessToken = await secureStorage.read(
      key: "access_token",
    );
    try {
      var response = await http.get(Uri.parse(
              // "https://api-musiq.applogiq.org/api/v1/artist/homepage/{artist_id}"),
              "http://192.168.29.94:6060/api/v1/artist/homepage/{artist_id}"),
          headers: {
            'Content-type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $accessToken'
          });

      log("111111111111111111111111111111");
      log(response.body);
      log(response.statusCode.toString());
      preferableartistmodel.records.clear();

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        preferableartistmodel = Preferableartistmodel.fromJson(data);
      } else {}
      ispreferableartist = false;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  artistList() async {
    isLoad = true;
    notifyListeners();
    var res = await homeRepository.getArtist();

    artistModel.records.clear();
    print("object");
    print(res.body.toString());
    if (res.statusCode == 200) {
      var data = jsonDecode(res.body);

      artistModel = ArtistModel.fromMap(data);
    }

    isLoad = false;
    notifyListeners();
  }

  getSpecificArtistSongList(String artistId) async {
    isLoad = true;
    notifyListeners();
    var res = await homeRepository.getSpecifArtistSong(artistId);
    collectionViewAllModel = CollectionViewAllModel(
        success: false, message: "No records", records: [], totalrecords: 0);
    if (res.statusCode == 200) {
      var data = jsonDecode(res.body);

      collectionViewAllModel = CollectionViewAllModel.fromMap(data);
      // artistModel = ArtistModel.fromMap(data);
    }

    isLoad = false;
    notifyListeners();
  }

  void toggleUpNext() {
    isUpNextShow = !isUpNextShow;
    notifyListeners();
  }
}
