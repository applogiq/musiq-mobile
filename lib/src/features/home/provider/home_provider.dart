// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:musiq/src/core/constants/local_storage_constants.dart';
import 'package:musiq/src/features/home/screens/artist_view_all/preferable_artist.dart';
import 'package:musiq/src/features/payment/provider/payment_provider.dart';
import 'package:provider/provider.dart';

import '../../../core/enums/enums.dart';
import '../../../core/routing/route_name.dart';
import '../../../core/utils/navigation.dart';
import '../../artist/domain/models/artist_model.dart';
import '../../search/screens/search_screen.dart';
import '../domain/model/album_model.dart';
import '../domain/model/aura_model.dart';
import '../domain/model/new_release_model.dart';
import '../domain/model/recent_song_model.dart';
import '../domain/model/song_list_model.dart';
import '../domain/model/trending_hits_model.dart';
import '../domain/repository/home_repo.dart';
import 'package:http/http.dart' as http;

FlutterSecureStorage secureStorage = const FlutterSecureStorage();

class HomeProvider extends ChangeNotifier {
  String premiumStatus = "free";
  FlutterSecureStorage storage = const FlutterSecureStorage();
  bool isRecentlyPlayedLoad = false;
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
  Preferableartistmodel preferableartistmodel = Preferableartistmodel(
      success: false, message: "No records", records: [], totalRecords: 0);
  NewReleaseModel newReleaseModel = NewReleaseModel(
    success: false,
    message: "No Records",
    records: [],
    totalrecords: 0,
  );
  HomeRepository homeRepository = HomeRepository();
  getSongData() async {
    try {
      premiumStatus = await storage.read(key: "premier_status") ?? "free";

      await changeLoadState(true);
      await recentSongList();
      await artistList();
      await preferableArtistList();
      await trendingHitsSongList();
      await newRelease();
      await auraSongList();
      await albumList();
      print("ALBUM");
      print(albumListModel.records);
      changeLoadState(false);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  refreshPremiumStatus() async {
    premiumStatus = await storage.read(key: "premier_status") ?? "free";
  }

  albumList() async {
    try {
      var res = await homeRepository.getAlbum();

      albumListModel.records.clear();

      print("eeeeeeeeeeeeeeeeeeeeeee----------------------eeeeeeeeee");
      if (res.statusCode == 200) {
        print(
            "eeeeeeeeeeeeeeeeeeeeeee--<<<<<<<<<<<<<<<<<<<<<<<<<<<--------------------eeeeeeeeee");

        var data = jsonDecode(res.body);
        print(
            "eeeeeeeeeeeeeeeeeeeeeee---->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>------------------eeeeeeeeee");

        albumListModel = Album.fromMap(data);
        print(
            "eeeeeeeeeeeeeeeeeeeeeee-------999999999999999999999---------------eeeeeeeeee");
      }
    } catch (e) {
      print("eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee");
      print("eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee");
      debugPrint(e.toString());
    }
  }

  preferableArtistList() async {
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
      }

      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  artistList() async {
    var res = await homeRepository.getArtist(limit: 10);
    log(res.body);
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

    notifyListeners();
    if (res.statusCode == 200) {
      var data = jsonDecode(res.body);
      log("message");
      recentlyPlayed = RecentlyPlayed.fromMap(data);
      for (int i = 0; i < recentlyPlayed.records.length; i++) {
        recentSongListModel.add(SongListModel(
            id: recentlyPlayed.records[i][0].id,
            albumId: recentlyPlayed.records[i][0].albumId,
            songName: recentlyPlayed.records[i][0].songName,
            albumName: recentlyPlayed.records[i][0].albumName,
            musicDirectorName:
                recentlyPlayed.records[i][0].musicDirectorName[0].toString(),
            premiumStatus: recentlyPlayed.records[i][0].premiumStatus));
      }

      notifyListeners();
    } else {
      recentlyPlayed = RecentlyPlayed(
          success: false,
          message: "No recent songs",
          records: [],
          totalrecords: 0);
    }
    isRecentlyPlayedLoad = false;
    notifyListeners();
  }

  trendingHitsSongList() async {
    try {
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
                  trendingHitsModel.records[i].musicDirectorName.isEmpty
                      ? ""
                      : trendingHitsModel.records[i].musicDirectorName[0]
                          .toString(),
              premiumStatus: "free"));
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
    } catch (e) {
      print("ERRROR");
      print(e.toString());
    }
  }

  auraSongList() async {
    try {
      var res = await homeRepository.getAura();

      auraListModel.records.clear();
      if (res.statusCode == 200) {
        var data = jsonDecode(res.body);
        auraListModel = AuraModel.fromMap(data);
      }
      // ignore: empty_catches
    } catch (e) {}
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
                newReleaseModel.records[i].musicDirectorName[0].toString(),
            premiumStatus: newReleaseModel.records[i].premiumStatus));
      }
      log(newReleaseListModel.toString());
    }
  }

  SubscriptionPlan getPremierStatus() {
    // premiumStatus = await storage.read(key: "premier_status") ?? "free";
    if (premiumStatus == "free") {
      return SubscriptionPlan.free;
    } else if (premiumStatus == "L1") {
      return SubscriptionPlan.threeMonths;
    } else {
      return SubscriptionPlan.sixMonths;
    }
  }

  goToHome(BuildContext context) async {
    await storage.write(key: LocalStorageConstant.isOnboardFree, value: "true");
    context.read<PaymentProvider>().continueWithFreePlanSubscription(context);
    // Navigator.pop(context);
  }

  void clearRecentSongList() {
    recentlyPlayed.records.clear();
    recentSongListModel.clear();
    isRecentlyPlayedLoad = true;
    notifyListeners();
  }
}
