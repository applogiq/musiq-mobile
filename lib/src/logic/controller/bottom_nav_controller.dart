import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musiq/src/view/pages/home/home_screen.dart';
import 'package:musiq/src/view/pages/library/library.dart';
import 'package:musiq/src/view/pages/profile/profile.dart';

import '../../helpers/constants/color.dart';
import '../../model/ui_model/bottom_nav_model.dart';

class BottomNavigationBarController extends GetxController {
  List<BottomNavBarModel> bottomItems = [
    BottomNavBarModel(iconData: Icons.home_rounded, labelData: "Home"),
    BottomNavBarModel(iconData: Icons.music_note_rounded, labelData: "Library"),
    BottomNavBarModel(iconData: Icons.podcasts_rounded, labelData: "Podcast"),
    BottomNavBarModel(iconData: Icons.person_rounded, labelData: "Profile"),
  ];
  List pages = [HomePage(), Library(), Library(), ProfilePage()];
  var selectedBottomIndex = 0.obs;

  changeIndex(int index) {
    selectedBottomIndex.value = index;
  }

  textColor(index) {
    return selectedBottomIndex.value == index
        ? CustomColor.activeColor
        : CustomColor.inActiveColor;
  }

  iconColor(index) {
    return selectedBottomIndex.value == index
        ? CustomColor.activeColor
        : CustomColor.inActiveColor;
  }

  activeIconColor(index) {
    return selectedBottomIndex.value == index
        ? CustomColor.activeIconBgColor
        : Colors.transparent;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    selectedBottomIndex.value = 0;
  }
  
}
