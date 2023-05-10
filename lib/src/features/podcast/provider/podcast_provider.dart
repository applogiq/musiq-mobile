import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:musiq/src/features/podcast/domain/model/get_all_podcasts_model.dart';
import 'package:musiq/src/features/podcast/domain/repo/podcast_repo.dart';
// import 'package:musiq/src/features/podcast/podcast_all_screen.dart';
import 'package:musiq/src/features/podcast/screens/podcast_all_screen.dart';

class PodcastProvider extends ChangeNotifier {
  int selecteddindex = 0;
  final categoriesList = [
    "All",
    "News",
    "Comedy",
    "Technology",
    "TV&flim",
    "All",
    "News",
    "Comedy",
    "Technology",
    "TV&flim",
  ];

  List pages = [
    const PodCastAllScreen(),
    const Center(child: Text("News")),
    const Center(child: Text("Comedy")),
    const Center(child: Text("Technology")),
    const Center(child: Text("TV&flim")),
    const Center(child: Text("All")),
    const Center(child: Text("News")),
    const Center(child: Text("Comedy")),
    const Center(child: Text("Technology")),
    const Center(child: Text("TV&flim")),
  ];

  PodcastReposiory podcastRepo = PodcastReposiory();
  GetAllPodcasts getAllpodcasts = GetAllPodcasts(
      success: false, message: "No records ", records: [], totalrecords: 0);
  bool getPodcastsLoad = false;
  final storage = const FlutterSecureStorage();

  categoriesOnTapped(int index) {
    selecteddindex = index;
    notifyListeners();
  }

  getAllPodcastList() async {
    getPodcastsLoad = true;
    notifyListeners();
    try {
      var res = await podcastRepo.viewAllPodcast(100);
      if (res.statusCode == 200) {
        getAllpodcasts =
            GetAllPodcasts.fromJson(jsonDecode(res.body.toString()));
        print(res.statusCode.toString());
        log(res.body.toString());
        for (int i = 0; i < getAllpodcasts.records.length; i++) {
          await storage.write(
              key: 'intKey', value: getAllpodcasts.records[i].id.toString());
          // getAllpodcasts.records[i].id.toString();
        }
      } else {
        log(res.statusCode.toString());
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    getPodcastsLoad = false;
    notifyListeners();
  }

  // podcastId() async {
  //   for (int i = 0; i < getAllpodcasts.records.length; i++) {
  //     return await storage.write(
  //         key: 'intKey', value: getAllpodcasts.records[i].id.toString());
  //     // getAllpodcasts.records[i].id.toString();
  //   }
  //   notifyListeners();
  // }
  // podcastDetails() async {

  //   var res = await podcastRepo.viewPodcastList(100, );
  //   if (res.statusCode == 200) {
  //     print(res.statusCode.toString());
  //     log(res.body.toString());
  //   } else {}
  // }
}
