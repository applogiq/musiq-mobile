import 'package:flutter/material.dart';
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

  categoriesOnTapped(int index) {
    selecteddindex = index;
    notifyListeners();
  }
}
