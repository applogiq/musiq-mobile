import 'package:flutter/material.dart';

import '../../../common_widgets/model/bottom_nav_model.dart';
import '../../../constants/color.dart';
import '../../home/screens/home_screen.dart';
import '../../library/screens/library_screen.dart';
import '../../podcast/screens/podcast_screen.dart';
import '../../profile/screens/profile_screen.dart';

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
