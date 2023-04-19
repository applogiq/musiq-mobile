// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:musiq/main.dart';
import 'package:musiq/src/core/utils/loader_dialog.dart';
import 'package:provider/provider.dart';

import '../../../../objectbox.g.dart';
import '../../../core/enums/enums.dart';
import '../../artist/domain/models/artist_model.dart';
import '../../home/domain/model/song_search_model.dart';
import '../../home/domain/repository/search_repo.dart';
import '../../library/domain/library_repo.dart';
import '../../library/domain/models/playlist_song_list_model.dart';
import '../../library/provider/library_provider.dart';
import '../../player/domain/repo/player_repo.dart';

class SearchProvider extends ChangeNotifier {
  late TextEditingController searchEditingController;
  // SearchRepository instance
  SearchRepository searchRepository = SearchRepository();

  List<String> searchArtistList = [];
  List<String> searchSongList = [];
  List<int> playlistSongId = [];
  var userFollowedArtist = [];
  bool isSearch = true;
  bool isArtistSearch = true;

  String searchQuery = "";
  late Store store;
  init() {
    searchEditingController = TextEditingController();
  }

  destroy() {
    searchEditingController.removeListener(() {});
    searchEditingController.dispose();
  }

  ArtistModel artistModel = ArtistModel(
      success: false,
      message: "Search not started",
      records: [],
      totalRecords: 0);
  SearchSongModel searchSongModel = SearchSongModel(
      success: false,
      message: "Search not started",
      records: [],
      totalrecords: 0);
  bool isRecentSearch = true;
  // Search screen state reset
  resetState() {
    artistModel = ArtistModel(
        success: false,
        message: "Search not started",
        records: [],
        totalRecords: 0);
    searchSongModel = SearchSongModel(
        success: false,
        message: "Search not started",
        records: [],
        totalrecords: 0);
    isRecentSearch = true;
    notifyListeners();
  }

  // getUserFollowedList() async {
  //   var res = await ProfileRepository().getProfile();
  //   if (res.statusCode == 200) {
  //     var jsonData = jsonDecode(res.body);
  //     log(jsonData.toString());
  //     ProfileAPIModel profileAPIModel = ProfileAPIModel.fromJson(jsonData);

  //     userFollowedArtist.addAll(profileAPIModel.records!.preference!.artist);
  //     notifyListeners();
  //   }
  // }
// Search song and artist API call
  getSearch(String data, SearchStatus status, int? playlistId,
      BuildContext context) async {
    playlistSongId.clear();
    searchSongList.clear();
    artistModel = ArtistModel(
        success: false,
        message: "Search not started",
        records: [],
        totalRecords: 0);

    searchSongModel.records.clear();
    searchQuery = data;
    if (data.trim() != "") {
      isRecentSearch = false;
      notifyListeners();
      if (status == SearchStatus.artist ||
          status == SearchStatus.artistPreference) {
        isArtistSearch = true;
        notifyListeners();
        var res = await searchRepository.getArtistSearch(data.trim());
        if (res.statusCode == 200) {
          log(res.body.toString());

          artistModel = ArtistModel.fromMap(jsonDecode(res.body.toString()));
        } else {
          artistModel = ArtistModel(
              success: false,
              message: "No records",
              records: [],
              totalRecords: 0);
        }
        isArtistSearch = false;

        notifyListeners();

        log(res.body.toString());
      } else {
        isSearch = true;

        var res = await searchRepository.getSongSearch(data.trim());

        if (res.statusCode == 200) {
          print(res.body.toString());
          log(res.body.toString());
          searchSongModel =
              SearchSongModel.fromMap(jsonDecode(res.body.toString()));

          if (playlistId != null) {
            getPlaylistSongList(playlistId);
            context.read<LibraryProvider>().getPlayListSongList(playlistId);
          }
        } else {
          searchSongModel = SearchSongModel(
              success: false,
              message: "No records",
              records: [],
              totalrecords: 0);
        }
        isSearch = false;
        notifyListeners();
      }
    } else {
      isRecentSearch = true;
      notifyListeners();
    }
  }

// Add searched song to playlist
  addSongToPlaylist(int songId, int playlistId, BuildContext context) async {
    showLoadingDialog(context);
    Map params = {"playlist_id": playlistId, "song_id": songId};
    var res = await PlayerRepo().addToPlaylist(params);
    print(res.statusCode);
    print(params);
    print(res.body);
    print("Stop");
    if (res.statusCode == 200) {
      await getPlaylistSongList(playlistId);
    }
    FocusScope.of(context).unfocus();
    Navigator.pop(context);
  }
//  Get specific playlist song id list

  getPlaylistSongList(int id) async {
    var response =
        await LibraryRepository().getPlayListSongListdata(id.toString());

    if (response.statusCode == 200) {
      PlaylistSongListModel playlistSongListModel =
          PlaylistSongListModel.fromMap(jsonDecode(response.body));
      playlistSongId.clear();
      for (var element in playlistSongListModel.records) {
        playlistSongId.add(element.playlistSongs.songId);
      }
      notifyListeners();
    }
  }

// Artist search history store
  void searchArtistStore() async {
    await objectbox.removeArtistSearch(searchQuery.trim());
    await objectbox.addArtistSearch(searchQuery);
  }

// Song search history store
  void searchSongStore() async {
    await objectbox.removeSongSearch(searchQuery.trim());
    await objectbox.addSongSearch(searchQuery);
  }

  // getArtistSearchHistory() async {
  //   await getApplicationDocumentsDirectory().then((Directory dir) async {
  //     store = Store(getObjectBoxModel(), directory: '\${dir.path}/musiq/db/1');
  //     final box = store.box<SearchArtistLocalModel>();
  //     var res = box.getAll();
  //     if (res.isEmpty) {
  //       searchSongList.clear();
  //     } else {
  //       searchSongList.clear();
  //       for (var element in res) {
  //         searchSongList.add(element.searchName);
  //       }
  //       searchSongList.reversed.toList();
  //     }
  //     store.close();
  //   });
  //   notifyListeners();
  // }

// Clear song search history
  void clearSongHistoryList() async {
    objectbox.removeAllSongSearch();
  }

  void searchArtistPreference() {}

  void getSongSearchHistory() {}
}
