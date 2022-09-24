import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musiq/src/view/pages/home/home_screen.dart';
import 'package:musiq/src/view/pages/library/library.dart';
import 'package:musiq/src/view/pages/profile/profile.dart';
import 'package:musiq/src_main/constants/color.dart';
import 'package:musiq/src_main/screen/home_screen/home_screen.dart';
import 'package:musiq/src_main/screen/library_screen/library_screen.dart';
import 'package:musiq/src_main/screen/podcast_screen/podcast_screen.dart';
import 'package:musiq/src_main/screen/profile_screen/profile_screen.dart';

import '../widgets/model/bottom_nav_model.dart';

class BottomNavigationBarProvider extends ChangeNotifier {
  List<BottomNavBarModel> bottomItems = [
    BottomNavBarModel(iconData: Icons.home_rounded, labelData: "Home"),
    BottomNavBarModel(iconData: Icons.music_note_rounded, labelData: "Library"),
    BottomNavBarModel(iconData: Icons.podcasts_rounded, labelData: "Podcast"),
    BottomNavBarModel(iconData: Icons.person_rounded, labelData: "Profile"),
  ];
  List pages = [
    HomeScreen(),
    LibraryScreen(),
    PodcastScreen(),
    ProfileScreen()
  ];
  var selectedBottomIndex = 0;

  changeIndex(int index) {
    selectedBottomIndex = index;

    notifyListeners();
  }

  textColor(index) {
    return selectedBottomIndex == index
        ? CustomColor.activeColor
        : CustomColor.inActiveColor;
  }

  iconColor(index) {
    return selectedBottomIndex == index
        ? CustomColor.activeColor
        : CustomColor.inActiveColor;
  }

  activeIconColor(index) {
    return selectedBottomIndex == index
        ? CustomColor.activeIconBgColor
        : Colors.transparent;
  }
}
