import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:musiq/src/features/library/domain/library_repo.dart';
import 'package:musiq/src/features/library/domain/models/playlist_model.dart';

class PlayListProvider extends ChangeNotifier {
  FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  String playListName = "";
  int noOfSongs = 1;
  bool isLoad = true;
  getPlayListDetails() async {
    isLoad = true;
    try {
      var id = await secureStorage.read(key: "id");
      var res = await LibraryRepository().getPlayList(id!);
      log(res.statusCode.toString());
      log(res.body.toString());
      if (res.statusCode == 200) {
        print("1");
        PlayListModel playListModel =
            PlayListModel.fromMap(jsonDecode(res.body.toString()));
        playListName = playListModel.records[0].playlistName.toString();
        noOfSongs = playListModel.records[0].noOfSongs!;

        isLoad = false;
        notifyListeners();
      } else {}
      // log(playListModel.records[0].playlistName.toString());
    } catch (e) {
      print(e.toString());
    }
  }

  notifyListeners();
}
