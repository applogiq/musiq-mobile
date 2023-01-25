import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:musiq/src/features/home/domain/model/album_song_list_model.dart';
import 'package:musiq/src/features/home/domain/model/aura_song_list_model.dart';
import 'package:musiq/src/features/home/domain/model/new_release_model.dart';
import 'package:musiq/src/features/home/domain/model/recent_song_model.dart';
import 'package:musiq/src/features/home/domain/model/trending_hits_model.dart';
import 'package:musiq/src/features/home/domain/repository/home_repo.dart';
import 'package:musiq/src/features/home/view_all_status.dart';

class ViewAllProvider extends ChangeNotifier {
  bool isLoad = true;
  HomeRepository homeRepository = HomeRepository();
  TrendingHitsModel trendingHitsModel = TrendingHitsModel(
      success: false, message: "No records", records: [], totalrecords: 0);

  RecentlyPlayed recentlyPlayed = RecentlyPlayed(
      success: false, message: "No records", records: [], totalrecords: 0);

  NewReleaseModel newReleaseModel = NewReleaseModel(
      success: false, message: "No records", records: [], totalrecords: 0);
  AlbumSongListModel albumSongListModel = AlbumSongListModel(
      success: false, message: "No records", records: [], totalrecords: 0);

  AuraSongListModel auraSongListModel = AuraSongListModel(
      success: false, message: "No records", records: [], totalRecords: 0);

  void getViewAll(ViewAllStatus status, {int? id}) async {
    isLoad = true;
    notifyListeners();
    if (status == ViewAllStatus.trendingHits) {
      var res = await homeRepository.getTrendingSongList(100);
      if (res.statusCode == 200) {
        var data = jsonDecode(res.body);
        print(data);

        trendingHitsModel = TrendingHitsModel.fromMap(data);
      }
    } else if (status == ViewAllStatus.newRelease) {
      var res = await homeRepository.getNewRelease();
      if (res.statusCode == 200) {
        var data = jsonDecode(res.body);
        print(data);

        newReleaseModel = NewReleaseModel.fromMap(data);
      }
    } else if (status == ViewAllStatus.recentlyPlayed) {
      var res = await homeRepository.getRecentPlayedList(100);
      if (res.statusCode == 200) {
        var data = jsonDecode(res.body);
        print(data);

        recentlyPlayed = RecentlyPlayed.fromMap(data);
      }
    } else if (status == ViewAllStatus.album) {
      print(id);
      var res = await homeRepository.getSpecificAlbum(id!);
      print(res.statusCode);
      print(res.body);
      if (res.statusCode == 200) {
        var data = jsonDecode(res.body);
        print(data);

        albumSongListModel = AlbumSongListModel.fromMap(data);
        notifyListeners();
      }
    } else if (status == ViewAllStatus.aura) {
      var res = await homeRepository.getSpecificAura(id!);
      print(res.statusCode);
      print(res.body);
      if (res.statusCode == 200) {
        var data = jsonDecode(res.body);
        print(data);

        auraSongListModel = AuraSongListModel.fromMap(data);
        notifyListeners();
      }
    }
    isLoad = false;
    notifyListeners();
  }
}
