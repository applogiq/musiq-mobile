import 'dart:convert';

import 'package:flutter/widgets.dart';

import '../../artist/domain/models/artist_model.dart';
import '../domain/repository/home_repo.dart';

class ArtistViewAllProvider extends ChangeNotifier {
  bool isLoad = true;
  bool isViewAllSongLoad = true;

  ArtistModel artistModel = ArtistModel(
      success: false, message: "No records", records: [], totalRecords: 0);
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

    if (res.statusCode == 200) {
      var data = jsonDecode(res.body);
      print(data);
      // artistModel = ArtistModel.fromMap(data);
    }

    isLoad = false;
    notifyListeners();
  }
}
