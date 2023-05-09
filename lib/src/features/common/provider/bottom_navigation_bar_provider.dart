import 'package:flutter/material.dart';
import 'package:musiq/src/features/podcast/screens/podcast_screen.dart';

import '../../../common_widgets/model/bottom_nav_model.dart';
import '../../../core/constants/color.dart';
import '../../home/screens/home_screen.dart';
import '../../library/screens/library.dart';
import '../../profile/screens/profile_screen.dart';

class BottomNavigationBarProvider extends ChangeNotifier {
  final homeNavigatorKey = GlobalKey<NavigatorState>();
  final libraryNavigatorKey = GlobalKey<NavigatorState>();
  final profileNavigatorKey2 = GlobalKey<NavigatorState>();

  List<BottomNavBarModel> bottomItems = [
    BottomNavBarModel(iconData: Icons.home_rounded, labelData: "Home"),
    BottomNavBarModel(iconData: Icons.music_note_rounded, labelData: "Library"),
    BottomNavBarModel(iconData: Icons.podcasts, labelData: "Podcasts"),
    BottomNavBarModel(iconData: Icons.person_rounded, labelData: "Profile"),
  ];
  List pages = [
    const HomeScreen(),
    const LibraryScreen(),
    const PodCastScreen(),
    const ProfileScreen()
  ];
  var selectedBottomIndex = 0;
  int index = 0;
  // var initialIndex = 0;
  indexes() {
    selectedBottomIndex = 0;
    notifyListeners();
  }

  changeIndex(int index) {
    selectedBottomIndex = index;
    if (index == selectedBottomIndex) {
    } else {
      if (index == 0) {}
    }
    //     if (index == _selectedTab) {
    //       widget.items[index].navigatorkey?.currentState
    //           ?.popUntil((route) => route.isFirst);
    //     } else {
    //       setState(() {
    //         _selectedTab = index;
    //       });
    //     }
    //   },
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
