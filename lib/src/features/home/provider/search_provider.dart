import 'dart:convert';
import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:musiq/src/features/artist/domain/models/artist_model.dart';
import 'package:musiq/src/features/home/domain/repository/search_repo.dart';

class SearchProvider extends ChangeNotifier {
  SearchRepository searchRepository = SearchRepository();
  ArtistModel artistModel = ArtistModel(
      success: false,
      message: "Search not started",
      records: [],
      totalRecords: 0);
  bool isRecentSearch = true;
  searchFieldTap() {
    isRecentSearch = false;
    notifyListeners();
  }

  resetState() {
    artistModel = ArtistModel(
        success: false,
        message: "Search not started",
        records: [],
        totalRecords: 0);
    isRecentSearch = true;
    notifyListeners();
  }

  artistSearch(String data) async {
    artistModel.records.clear();
    var res = await searchRepository.getArtistSearch(data.trim());
    if (res.statusCode == 200) {
      artistModel = ArtistModel.fromMap(jsonDecode(res.body.toString()));
    } else {
      artistModel = ArtistModel(
          success: false, message: "No records", records: [], totalRecords: 0);
    }
    notifyListeners();

    log(res.body.toString());
  }
}
