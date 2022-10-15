import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:musiq/src/features/library/domain/models/favourite_model.dart';
import 'package:musiq/src/features/library/domain/repository/library_repo.dart';

import '../../../constants/string.dart';
import '../../../utils/image_url_generate.dart';
import '../domain/models/playlist_model.dart';
import '../domain/models/view_all_song_list_model.dart';

class LibraryProvider extends ChangeNotifier {
  var isLoaded = false;
  var isLoadedPlayList = false;
  var playListError = "";
  var playListName = "";
  List playListNameExist = [];
  List<ViewAllSongList> view_all_songs_list = [];
  late PlayListModel view_all_play_list;
  var isCreatePlayListError = false;
  // APIRoute apiRoute = APIRoute();
  loadFavouriteData() async {
    var res = await LibraryRepo().getFavourite();
    print(res.statusCode);
    print(res.body);
    // Favourite favourite = await apiRoute.getFavourites();
    // if (favourite.success == true) {
    //   //  List<ViewAllSongList> viewAllSongList=[];
    //   view_all_songs_list.clear();
    //   for (int i = 0; i < favourite.totalRecords; i++) {
    //     view_all_songs_list.add(ViewAllSongList(
    //         favourite.records[i].id.toString(),
    //         generateSongImageUrl(favourite.records[i].albumName.toString(),
    //             favourite.records[i].albumId.toString()),
    //         favourite.records[i].songName,
    //         favourite.records[i].musicDirectorName[0],
    //         favourite.records[i].albumName,
    //         favourite.records[i].albumName));
    //   }
    // } else {}
    // Future.delayed(Duration(seconds: 3),(){
    isLoaded = true;
    // });

    notifyListeners();
  }

  // loadPlayListData() async {
  //   isLoadedPlayList = false;
  //   notifyListeners();
  //   view_all_play_list = await apiRoute.getPlaylists();
  //   playListNameExist.clear();
  //   if (view_all_play_list.success == true) {
  //     for (int i = 0; i < view_all_play_list.totalRecords; i++) {
  //       playListNameExist.add(view_all_play_list.records[i].playlistName);
  //     }
  //   } else {
  //     view_all_play_list = PlayListModel(
  //         success: false, message: "", records: [], totalRecords: 0);
  //   }

  //   isLoadedPlayList = true;
  //   notifyListeners();
  // }

  // checkPlayListName(String name) {
  //   print(name);
  //   print(playListNameExist);
  //   if (name.trim() == "") {
  //     isCreatePlayListError = true;
  //     playListError = ConstantText.fieldRequired;
  //   } else if (playListNameExist.contains(name.trim())) {
  //     isCreatePlayListError = true;
  //     playListError = ConstantText.playListNameExist;
  //   } else {
  //     isCreatePlayListError = false;
  //   }
  //   playListName = name;
  // }

  // createPlaylist(context) async {
  //   if (playListName == "") {
  //   } else if (isCreatePlayListError == true) {
  //   } else {
  //     var res = await apiRoute.createPlayList(playListName);
  //     print(res.body);
  //     var data = jsonDecode(res.body);
  //     print(data);
  //     if (res.statusCode == 200) {
  //       playListNameExist.add(playListName);
  //     }
  //     view_all_play_list = PlayListModel.fromMap(jsonDecode(res.body));
  //     notifyListeners();
  //     Navigator.of(context).pop();
  //   }
  // }

  // deletePlaylist(int id) async {
  //   var res = await apiRoute.deletePlaylist(id);
  //   // if (res.statusCode == 200) {
  //   loadPlayListData();
  //   // }
  //   print(res.body);
  //   var data = jsonDecode(res.body);
  //   print(data);
  //   // view_all_play_list = PlayListModel.fromMap(jsonDecode(res.body));
  //   notifyListeners();
  // }

  // renamePlaylistUrl(int playListId, context) async {
  //   print(playListId);
  //   print(playListName);
  //   var res = await apiRoute.renamePlaylist(playListId, playListName);
  //   if (res.statusCode == 200) {
  //     loadPlayListData();
  //   }
  //   Navigator.of(context).pop();
  //   Navigator.of(context).pop();
  // }

}
