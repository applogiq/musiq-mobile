import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:musiq/src/features/artist/domain/models/artist_model.dart';
import 'package:musiq/src/features/home/domain/repository/search_repo.dart';
import 'package:musiq/src/features/search/search_status.dart';
import 'package:musiq/src/local/model/search_model.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../objectbox.g.dart';
import '../domain/model/song_search_model.dart';

class SearchProvider extends ChangeNotifier {
  late TextEditingController searchEditingController;
  SearchRepository searchRepository = SearchRepository();
  List<String> searchArtistList = [];
  List<String> searchSongList = [];
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
    isRecentSearch = true;
    notifyListeners();
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

  getSearch(String data, SearchStatus status) async {
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
      if (status == SearchStatus.artist) {
        var res = await searchRepository.getArtistSearch(data.trim());
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
        print(res.body);
        if (res.statusCode == 200) {
          searchSongModel =
              SearchSongModel.fromMap(jsonDecode(res.body.toString()));
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

  void searchArtistStore() async {
    await getApplicationDocumentsDirectory().then((Directory dir) async {
      store = Store(getObjectBoxModel(), directory: '${dir.path}/musiq/db/');
      final box = store.box<SearchArtistLocalModel>();
      var res = box.getAll();
      if (res.isEmpty) {
        box.put(SearchArtistLocalModel(searchName: searchQuery.trim()));
        store.close();
        print("Added");
      } else {
        for (var element in res) {
          if (element.searchName == searchQuery.trim()) {
            box.remove(element.id);
          }
        }
        box.put(SearchArtistLocalModel(searchName: searchQuery.trim()));
      }
      store.close();
    });
    getSongSearchHistory();
  }

  void searchSongStore() async {
    await getApplicationDocumentsDirectory().then((Directory dir) async {
      store = Store(getObjectBoxModel(), directory: '${dir.path}/musiq/db/');
      final box = store.box<SearchSongLocalModel>();
      var res = box.getAll();
      if (res.isEmpty) {
        box.put(SearchSongLocalModel(searchName: searchQuery.trim()));
        store.close();
        print("Added");
      } else {
        for (var element in res) {
          if (element.searchName == searchQuery.trim()) {
            box.remove(element.id);
          }
        }
        box.put(SearchSongLocalModel(searchName: searchQuery.trim()));
      }
      store.close();
      getSongSearchHistory();
    });
  }

  getArtistSearchHistory() async {
    await getApplicationDocumentsDirectory().then((Directory dir) async {
      store = Store(getObjectBoxModel(), directory: '${dir.path}/musiq/db/');
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

  getSongSearchHistory() async {
    await getApplicationDocumentsDirectory().then((Directory dir) async {
      store = Store(getObjectBoxModel(), directory: '${dir.path}/musiq/db/');
      final box = store.box<SearchSongLocalModel>();
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
    await getApplicationDocumentsDirectory().then((Directory dir) async {
      store = Store(getObjectBoxModel(), directory: '${dir.path}/musiq/db/');
      final box = store.box<SearchSongLocalModel>();
      box.removeAll();
      store.close();
      getSongSearchHistory();
    });
  }
}
