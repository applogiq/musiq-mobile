// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:musiq/src/core/utils/url_generate.dart';
import 'package:musiq/src/features/library/domain/library_repo.dart';
import 'package:musiq/src/features/library/domain/models/favourite_model.dart';
import 'package:musiq/src/features/library/domain/models/playlist_model.dart';
import 'package:musiq/src/features/library/domain/models/playlist_song_list_model.dart';
import 'package:musiq/src/features/player/domain/model/player_song_list_model.dart';
import 'package:musiq/src/features/player/provider/player_provider.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/string.dart';
import '../../../core/routing/route_name.dart';
import '../../../core/utils/navigation.dart';

class LibraryProvider extends ChangeNotifier {
  bool isFavouriteLoad = true;
  bool isPlayListError = false;
  bool isPlayListLoad = true;
  bool isPlayListSongLoad = true;
  String playListError = "";
  String playListName = "";
  List playListNameExistList = [];
  FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  FavouriteModel favouriteModel = FavouriteModel(
      success: false, message: "No records", records: [], totalRecords: 0);
  PlayListModel playListModel = PlayListModel(
      success: false, message: "No records", records: [], totalRecords: 0);

  PlaylistSongListModel playlistSongListModel = PlaylistSongListModel(
      success: false, message: "No records", records: [], totalRecords: 0);

  createPlayList(BuildContext context, {bool isAddPlaylist = false}) async {
    if (playListName.isEmpty) {
      isPlayListError = true;
      playListError = ConstantText.fieldRequired;
      notifyListeners();
    } else {
      var id = await secureStorage.read(key: "id");
      Map params = {"user_id": id, "playlist_name": playListName};
      var response = await LibraryRepository().createPlaylist(params);
      if (response.statusCode == 200) {
        playListNameExistList.add(playListName);

        // if (isAddPlaylist) {
        context.read<PlayerProvider>().getPlayListsList();
        // }
        playListModel = PlayListModel.fromMap(jsonDecode(response.body));

        notifyListeners();
        Navigator.of(context).pop();
      }
    }
  }

  updatePlayListName(BuildContext context, int playlistId,
      {bool isAddPlaylist = false}) async {
    // var id = await secureStorage.read(key: "id");
    Map params = {"name": playListName};
    var response =
        await LibraryRepository().updatePlaylistName(params, playlistId);
    if (response.statusCode == 200) {
      playListNameExistList.add(playListName);

      if (isAddPlaylist) {
        context.read<PlayerProvider>().getPlayListsList();
      }
      Navigator.of(context).pop();

      Navigation.navigateReplaceToScreen(context, RouteName.mainScreen);

      notifyListeners();
    }
  }

  getFavouritesList() async {
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
    // isFavouriteLoad = false;

    // notifyListeners();
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

  deletePlayList(int playlistId) async {
    var response =
        await LibraryRepository().deletePlaylist(playlistId.toString());

    if (response.statusCode == 200) {
      getPlayListsList();
    }
  }

  void addToQueue(int id, BuildContext context) async {
    var response =
        await LibraryRepository().getPlayListSongListdata(id.toString());

    if (response.statusCode == 200) {
      List<PlayerSongListModel> playSongListModel = [];
      PlaylistSongListModel playlistSongListModel =
          PlaylistSongListModel.fromMap(jsonDecode(response.body));
      for (var element in playlistSongListModel.records) {
        playSongListModel.add(PlayerSongListModel(
            id: element.playlistSongs.songId,
            albumName: element.albumName,
            title: element.songName,
            imageUrl: generateSongImageUrl(element.albumName, element.albumId),
            musicDirectorName: element.musicDirectorName[0],
            duration: element.duration,
            premium: element.premiumStatus,
            isImage: element.isImage));
      }
      context
          .read<PlayerProvider>()
          .addSongToQueueSongList(playSongListModel, context);
    }
  }

  getPlayListSongList(int id) async {
    isPlayListSongLoad = true;
    notifyListeners();
    playlistSongListModel.records.clear();
    var response =
        await LibraryRepository().getPlayListSongListdata(id.toString());

    if (response.statusCode == 200) {
      playlistSongListModel =
          PlaylistSongListModel.fromMap(jsonDecode(response.body));
    }
    isPlayListSongLoad = false;
    notifyListeners();
  }

  void play(int id, BuildContext context, {int index = 0}) async {
    var response =
        await LibraryRepository().getPlayListSongListdata(id.toString());

    if (response.statusCode == 200) {
      List<PlayerSongListModel> playSongListModel = [];
      PlaylistSongListModel playlistSongListModel =
          PlaylistSongListModel.fromMap(jsonDecode(response.body));
      for (var element in playlistSongListModel.records) {
        playSongListModel.add(PlayerSongListModel(
            id: element.playlistSongs.songId,
            albumName: element.albumName,
            title: element.songName,
            imageUrl: generateSongImageUrl(element.albumName, element.albumId),
            musicDirectorName: element.musicDirectorName[0],
            duration: element.duration,
            premium: element.premiumStatus,
            isImage: false));
      }
      context
          .read<PlayerProvider>()
          .goToPlayer(context, playSongListModel, index);
    }
  }

  void playFavourite(BuildContext context, {int index = 0}) async {
    List<PlayerSongListModel> playSongListModel = [];

    for (var element in favouriteModel.records) {
      playSongListModel.add(
        PlayerSongListModel(
            id: element.id,
            albumName: element.albumName,
            title: element.songName,
            imageUrl: generateSongImageUrl(element.albumName, element.albumId),
            musicDirectorName: element.musicDirectorName[0],
            duration: element.duration,
            premium: element.premiumStatus,
            isImage: false),
      );
    }

    context
        .read<PlayerProvider>()
        .goToPlayer(context, playSongListModel, index);
  }

  void navigateToPlayerScreen(BuildContext context, int id, {int index = 0}) {
    play(id, context, index: index);
  }

  void removeSongFromPlayLlist(int playlistSongId, playlistId) async {
    var response =
        await LibraryRepository().removeSongFromPlaylist(playlistSongId);

    if (response.statusCode == 200) {
      getPlayListSongList(playlistId);
    }
  }

  void reset() {
    playListError = "";
    isPlayListError = false;
    notifyListeners();
  }
}
