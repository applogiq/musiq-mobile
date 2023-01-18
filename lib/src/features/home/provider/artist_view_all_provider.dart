import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:musiq/src/features/home/domain/model/collection_view_all_model.dart';

import '../../artist/domain/models/artist_model.dart';
import '../domain/repository/home_repo.dart';

class ArtistViewAllProvider extends ChangeNotifier {
  bool isLoad = true;
  bool isViewAllSongLoad = true;
  bool isUpNextShow = false;

  ArtistModel artistModel = ArtistModel(
      success: false, message: "No records", records: [], totalRecords: 0);
  CollectionViewAllModel collectionViewAllModel = CollectionViewAllModel(
      success: false, message: "No records", records: [], totalrecords: 0);
  HomeRepository homeRepository = HomeRepository();
  artistList() async {
    isLoad = true;
    notifyListeners();
    var res = await homeRepository.getArtist();

    artistModel.records.clear();
    if (res.statusCode == 200) {
      var data = jsonDecode(res.body);
      print(data);
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
      print(data);
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
