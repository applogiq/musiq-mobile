// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:musiq/main.dart';
import 'package:musiq/src/features/profile/domain/api_models/profile_update_api_model.dart';
import 'package:musiq/src/features/profile/domain/repository/profile_repo.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../../../../objectbox.g.dart';
import '../../../core/enums/enums.dart';
import '../../../core/local/model/search_model.dart';
import '../../artist/domain/models/artist_model.dart';
import '../../home/domain/model/song_search_model.dart';
import '../../home/domain/repository/search_repo.dart';
import '../../library/domain/library_repo.dart';
import '../../library/domain/models/playlist_song_list_model.dart';
import '../../library/provider/library_provider.dart';
import '../../player/domain/repo/player_repo.dart';

class SearchProvider extends ChangeNotifier {
  late TextEditingController searchEditingController;
  SearchRepository searchRepository = SearchRepository();
  List<String> searchArtistList = [];
  List<String> searchSongList = [];
  List<int> playlistSongId = [];
  var userFollowedArtist = [];

  String searchQuery = "";
  late Store store;
  init() {
    searchEditingController = TextEditingController();
  }

  destroy() {
    searchEditingController.removeListener(() {});
    searchEditingController.dispose();
  }

  // historyTapped(String historySearch) {
  //   searchEditingController.clear();
  // searchEditingController.text = historySearch;
  // searchEditingController.selection = TextSelection.fromPosition(
  //     TextPosition(offset: searchEditingController.text.length));
  // }

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
  // searchFieldTap() {
  //   isRecentSearch = false;
  //   notifyListeners();
  // }

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

  getUserFollowedList() async {
    var res = await ProfileRepository().getProfile();
    if (res.statusCode == 200) {
      var jsonData = jsonDecode(res.body);
      log(jsonData.toString());
      ProfileAPIModel profileAPIModel = ProfileAPIModel.fromJson(jsonData);

      userFollowedArtist.addAll(profileAPIModel.records!.preference!.artist);
      notifyListeners();
    }
  }

  // artistSearch(String data) async {
  //   searchQuery = data;
  //   var res = await searchRepository.getArtistSearch(data.trim());
  //   if (res.statusCode == 200) {
  //     artistModel = ArtistModel.fromMap(jsonDecode(res.body.toString()));
  //   } else {
  //     artistModel = ArtistModel(
  //         success: false, message: "No records", records: [], totalRecords: 0);
  //   }
  //   notifyListeners();

  //   log(res.body.toString());
  // }

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
        var res = await searchRepository.getArtistSearch(data.trim());
        // log(res.body.toString());
        if (res.statusCode == 200) {
          artistModel = ArtistModel.fromMap(jsonDecode(res.body.toString()));
        } else {
          artistModel = ArtistModel(
              success: false,
              message: "No records",
              records: [],
              totalRecords: 0);
        }
        notifyListeners();

        log(res.body.toString());
      } else {
        var res = await searchRepository.getSongSearch(data.trim());
        log(res.body.toString());

        if (res.statusCode == 200) {
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
        notifyListeners();
      }
    } else {
      isRecentSearch = true;
      notifyListeners();
    }
  }

  addSongToPlaylist(int songId, int playlistId) async {
    Map params = {"playlist_id": playlistId, "song_id": songId};
    var res = await PlayerRepo().addToPlaylist(params);
    if (res.statusCode == 200) {
      getPlaylistSongList(playlistId);
    }
  }

  deleteSongToPlaylist(int playlistSongId, int playlistId) async {
    var res =
        await LibraryRepository().deletePlaylistSong(playlistSongId.toString());
    if (res.statusCode == 200) {
      getPlaylistSongList(playlistId);
    }
  }

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

  void searchArtistStore() async {
    await objectbox.removeArtistSearch(searchQuery.trim());
    await objectbox.addArtistSearch(searchQuery);
    // await getApplicationDocumentsDirectory().then((Directory dir) async {
    //   store = Store(getObjectBoxModel(), directory: '\${dir.path}/musiq/db/1');
    //   final box = store.box<SearchArtistLocalModel>();
    //   var res = box.getAll();
    //   if (res.isEmpty) {
    //     box.put(SearchArtistLocalModel(searchName: searchQuery.trim()));
    //     store.close();
    //   } else {
    //     for (var element in res) {
    //       if (element.searchName == searchQuery.trim()) {
    //         box.remove(element.id);
    //       }
    //     }
    //     box.put(SearchArtistLocalModel(searchName: searchQuery.trim()));
    //   }
    //   store.close();
    // });
    // getSongSearchHistory();
  }

  void searchSongStore() async {
    await objectbox.removeSongSearch(searchQuery.trim());
    await objectbox.addSongSearch(searchQuery);
    // await getApplicationDocumentsDirectory().then((Directory dir) async {
    //   store = Store(getObjectBoxModel(), directory: '\${dir.path}/musiq/db/1');
    //   final box = store.box<SearchSongLocalModel>();
    //   var res = box.getAll();
    //   if (res.isEmpty) {
    //     box.put(SearchSongLocalModel(searchName: searchQuery.trim()));
    //     store.close();
    //   } else {
    //     for (var element in res) {
    //       if (element.searchName == searchQuery.trim()) {
    //         box.remove(element.id);
    //       }
    //     }
    //     box.put(SearchSongLocalModel(searchName: searchQuery.trim()));
    //   }
    //   store.close();
    //   getSongSearchHistory();
    // });
  }

  getArtistSearchHistory() async {
    await getApplicationDocumentsDirectory().then((Directory dir) async {
      store = Store(getObjectBoxModel(), directory: '\${dir.path}/musiq/db/1');
      final box = store.box<SearchArtistLocalModel>();
      var res = box.getAll();
      if (res.isEmpty) {
        searchSongList.clear();
      } else {
        searchSongList.clear();
        for (var element in res) {
          searchSongList.add(element.searchName);
        }
        searchSongList.reversed.toList();
      }
      store.close();
    });
    notifyListeners();
  }

  void clearSongHistoryList() async {
    objectbox.removeAllSongSearch();
  }

  void searchArtistPreference() {}

  void getSongSearchHistory() {}
}
