import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:musiq/src/features/library/domain/library_repo.dart';
import 'package:musiq/src/features/library/domain/models/favourite_model.dart';
import 'package:musiq/src/features/library/domain/models/playlist_model.dart';
import 'package:musiq/src/features/player/provider/player_provider.dart';
import 'package:provider/provider.dart';

import '../../../constants/string.dart';

class LibraryProvider extends ChangeNotifier {
  bool isFavouriteLoad = true;
  bool isPlayListLoad = true;
  bool isPlayListError = false;
  List playListNameExistList = [];

  String playListError = "";
  String playListName = "";

  FavouriteModel favouriteModel = FavouriteModel(
      success: false, message: "No records", records: [], totalRecords: 0);
  PlayListModel playListModel = PlayListModel(
      success: false, message: "No records", records: [], totalRecords: 0);
  FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  createPlayList(BuildContext context, {bool isAddPlaylist = false}) async {
    var id = await secureStorage.read(key: "id");
    Map params = {"user_id": id, "playlist_name": playListName};
    var response = await LibraryRepository().createPlaylist(params);
    if (response.statusCode == 200) {
      playListNameExistList.add(playListName);
      if (isAddPlaylist) {
        context.read<PlayerProvider>().getPlayListsList();
      }
      playListModel = PlayListModel.fromMap(jsonDecode(response.body));
      // update();
      notifyListeners();
      Navigator.of(context).pop();
    }
  }

  getFavouritesList() async {
    isFavouriteLoad = true;
    notifyListeners();

    try {
      var id = await secureStorage.read(key: "id");

      var response = await LibraryRepository().getFavouritesList(id!);

      if (response.statusCode == 200) {
        favouriteModel =
            FavouriteModel.fromMap(jsonDecode(response.body.toString()));
      } else {
        favouriteModel = FavouriteModel(
            success: false,
            message: "No records",
            records: [],
            totalRecords: 0);
      }
    } catch (e) {
      favouriteModel = FavouriteModel(
          success: false, message: "No records", records: [], totalRecords: 0);
    }
    isFavouriteLoad = false;

    notifyListeners();
  }

  getPlayListsList() async {
    isPlayListLoad = true;
    notifyListeners();

    try {
      var id = await secureStorage.read(key: "id");

      var response = await LibraryRepository().getPlayListdata(id!);

      if (response.statusCode == 200) {
        log(response.body);
        playListModel =
            PlayListModel.fromMap(jsonDecode(response.body.toString()));
        playListNameExistList.clear();
        if (playListModel.success == true) {
          for (int i = 0; i < playListModel.totalRecords; i++) {
            playListNameExistList.add(playListModel.records[i].playlistName);
          }
        }
      } else {
        playListModel = PlayListModel(
            success: false,
            message: "No records",
            records: [],
            totalRecords: 0);
      }
    } catch (e) {
      playListModel = PlayListModel(
          success: false, message: "No records", records: [], totalRecords: 0);
    }
    isPlayListLoad = false;

    notifyListeners();
  }

  checkPlayListName(String name) {
    print(name);
    print(playListNameExistList);
    if (name.trim() == "") {
      isPlayListError = true;
      playListError = ConstantText.fieldRequired;
      notifyListeners();
    } else if (playListNameExistList.contains(name.trim())) {
      isPlayListError = true;
      playListError = ConstantText.playListNameExist;
      notifyListeners();
    } else {
      isPlayListError = false;
    }
    playListName = name;
    notifyListeners();
  }
}
