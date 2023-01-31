import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:musiq/src/features/library/domain/library_repo.dart';
import 'package:musiq/src/features/library/domain/models/play_list_model.dart';

class PlayListProvider extends ChangeNotifier {
  PlayListView playListModel = PlayListView(
      success: false, message: "No records", records: [], totalRecords: 0);
  FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  String playListName = "";
  int noOfSongs = 1;
  bool isLoad = true;
  bool isNoSong = true;

  getPlayListDetails(String songID) async {
    isLoad = true;
    notifyListeners();
    try {
      var res = await LibraryRepository().getPlayList(songID);
      isNoSong = false;
      notifyListeners();
      if (res.statusCode == 200) {
        isNoSong = false;
        playListModel = PlayListView.fromJson(jsonDecode(res.body.toString()));

        playListName = playListModel.records[0].playlistName.toString();
        noOfSongs = playListModel.records[0].noOfSongs!;

        isLoad = false;
        notifyListeners();
      } else if (res.statusCode == 404) {
        isNoSong = true;
        isLoad = false;
        notifyListeners();
      } else {
        isNoSong = false;
        notifyListeners();
        ;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  songSearch() async {
    try {
      // ignore: unused_local_variable
      var response = await LibraryRepository().searchMusic("1");
      print(response.statusCode.toString());
    } catch (e) {
      print(e.toString());
    }
  }
}
