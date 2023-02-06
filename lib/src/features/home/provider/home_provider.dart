import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import '../../search/screens/search_screen.dart';

import '../../../core/routing/route_name.dart';
import '../../../core/utils/navigation.dart';
import '../../artist/domain/models/artist_model.dart';
import '../../../core/enums/search_status.dart';
import '../domain/model/album_model.dart';
import '../domain/model/aura_model.dart';
import '../domain/model/new_release_model.dart';
import '../domain/model/recent_song_model.dart';
import '../domain/model/song_list_model.dart';
import '../domain/model/trending_hits_model.dart';
import '../domain/repository/home_repo.dart';

class HomeProvider extends ChangeNotifier {
  bool isLoad = true;
  RecentlyPlayed recentlyPlayed = RecentlyPlayed(
      success: false, message: "No records", records: [], totalrecords: 0);
  TrendingHitsModel trendingHitsModel = TrendingHitsModel(
      success: false, message: "No records", records: [], totalrecords: 0);
  List<SongListModel> recentSongListModel = [];
  List<SongListModel> trendingSongListModel = [];
  List<SongListModel> newReleaseListModel = [];
  ArtistModel artistModel = ArtistModel(
      success: false, message: "No records", records: [], totalRecords: 0);
  AuraModel auraListModel = AuraModel(
      success: false, message: "no records", records: [], totalRecords: 0);
  Album albumListModel = Album(
      success: false, message: "No Records", records: [], totalrecords: 0);
  NewReleaseModel newReleaseModel = NewReleaseModel(
    success: false,
    message: "No Records",
    records: [],
    totalrecords: 0,
  );
  HomeRepository homeRepository = HomeRepository();
  getSongData() async {
    changeLoadState(true);
    await recentSongList();
    await artistList();
    await trendingHitsSongList();
    await newRelease();
    await auraSongList();
    await albumList();
    changeLoadState(false);
  }

  albumList() async {
    var res = await homeRepository.getAlbum();

    albumListModel.records.clear();

    if (res.statusCode == 200) {
      var data = jsonDecode(res.body);
      albumListModel = Album.fromMap(data);
    }
  }

  artistList() async {
    var res = await homeRepository.getArtist(limit: 10);

    artistModel.records.clear();
    if (res.statusCode == 200) {
      var data = jsonDecode(res.body);
      artistModel = ArtistModel.fromMap(data);
    }
  }

  recentSongList() async {
    var res = await homeRepository.getRecentPlayedList(10);
    recentlyPlayed.records.clear();
    recentSongListModel.clear();
    if (res.statusCode == 200) {
      var data = jsonDecode(res.body);
      recentlyPlayed = RecentlyPlayed.fromMap(data);
      for (int i = 0; i < recentlyPlayed.records.length; i++) {
        recentSongListModel.add(SongListModel(
            id: recentlyPlayed.records[i][0].id,
            albumId: recentlyPlayed.records[i][0].albumId,
            songName: recentlyPlayed.records[i][0].songName,
            albumName: recentlyPlayed.records[i][0].albumName,
            musicDirectorName:
                recentlyPlayed.records[i][0].musicDirectorName[0].toString()));
      }
    } else {
      recentlyPlayed = RecentlyPlayed(
          success: false,
          message: "No recent songs",
          records: [],
          totalrecords: 0);
    }
    notifyListeners();
  }

  trendingHitsSongList() async {
    var res = await homeRepository.getTrendingSongList(10);

    trendingSongListModel.clear();

    if (res.statusCode == 200) {
      var data = jsonDecode(res.body);

      trendingHitsModel = TrendingHitsModel.fromMap(data);

      for (int i = 0; i < trendingHitsModel.records.length; i++) {
        trendingSongListModel.add(SongListModel(
            id: trendingHitsModel.records[i].id,
            albumId: trendingHitsModel.records[i].albumId,
            songName: trendingHitsModel.records[i].songName,
            albumName: trendingHitsModel.records[i].albumName,
            musicDirectorName:
                trendingHitsModel.records[i].musicDirectorName[0].toString()));
      }
    } else {
      trendingSongListModel.clear();
      trendingHitsModel = TrendingHitsModel(
          success: false,
          message: "No recent songs",
          records: [],
          totalrecords: 0);
    }
    notifyListeners();
  }

  auraSongList() async {
    var res = await homeRepository.getAura();

    auraListModel.records.clear();
    if (res.statusCode == 200) {
      var data = jsonDecode(res.body);
      auraListModel = AuraModel.fromMap(data);
    }
  }

  changeLoadState(bool status) {
    isLoad = status;
    notifyListeners();
  }

  goToSearch(context) {
    Navigation.navigateToScreen(context, RouteName.search,
        args: SearchRequestModel(searchStatus: SearchStatus.song));
  }

  newRelease() async {
    var res = await homeRepository.getNewRelease();

    newReleaseModel.records.clear();
    newReleaseListModel.clear();
    if (res.statusCode == 200) {
      var data = jsonDecode(res.body);
      newReleaseModel = NewReleaseModel.fromMap(data);
      for (int i = 0; i < newReleaseModel.records.length; i++) {
        newReleaseListModel.add(SongListModel(
            id: newReleaseModel.records[i].id,
            albumId: newReleaseModel.records[i].albumId,
            songName: newReleaseModel.records[i].songName,
            albumName: newReleaseModel.records[i].albumName,
            musicDirectorName:
                newReleaseModel.records[i].musicDirectorName[0].toString()));
      }
      log(newReleaseListModel.toString());
    }
  }
}
