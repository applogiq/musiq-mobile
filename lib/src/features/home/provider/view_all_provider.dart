import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:musiq/src/features/home/domain/model/trending_hits_model.dart';
import 'package:musiq/src/features/home/domain/repository/home_repo.dart';
import 'package:musiq/src/features/home/view_all_status.dart';

class ViewAllProvider extends ChangeNotifier {
  bool isLoad = true;
  HomeRepository homeRepository = HomeRepository();
  TrendingHitsModel trendingHitsModel = TrendingHitsModel(
      success: false, message: "No records", records: [], totalrecords: 0);

  void getViewAll(ViewAllStatus status) async {
    isLoad = true;
    notifyListeners();
    if (status == ViewAllStatus.trendingHits) {
      var res = await homeRepository.getTrendingSongList(100);
      if (res.statusCode == 200) {
        var data = jsonDecode(res.body);
        print(data);

        trendingHitsModel = TrendingHitsModel.fromMap(data);
      }
    }
    isLoad = false;
    notifyListeners();
  }
}
