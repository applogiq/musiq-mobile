import 'package:flutter/material.dart';
import 'package:musiq/src/features/common/provider/pop_up_provider.dart';
import 'package:musiq/src/features/common/screen/persitent_bottom.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';

import '../../player/provider/player_provider.dart';
import '../provider/bottom_navigation_bar_provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // final _tab1navigatorKey = GlobalKey<NavigatorState>();
  // final _tab2navigatorKey = GlobalKey<NavigatorState>();
  // final _tab3navigatorKey = GlobalKey<NavigatorState>();

  int selectedIndex = 0;
  late final List<PersistentBottomNavBarItem>
      items; // NOTE: You CAN declare your own model here instead of `PersistentBottomNavBarItem`.
  late final ValueChanged<int> onItemSelected;
  @override
  void initState() {
    super.initState();
    load();
  }

  load() async {
    await context.read<PlayerProvider>().loadQueueSong();
    await context.read<PopUpProvider>().subscriptionCheck(context);
    // await context.read<PlayerAudioProvider>().loadQueueSong();
  }

  @override
  void dispose() {
    BottomNavigationBarProvider()
        .pages[BottomNavigationBarProvider().selectedBottomIndex];

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Consumer<BottomNavigationBarProvider>(
      builder: (context, pro, _) {
        return PersistentBottomBarScaffold(
          items: [
            PersistentTabItem(
              tab: pro.pages[0],
              icon: Icons.home,
              title: 'Home',
              navigatorkey: pro.homeNavigatorKey,
            ),
            PersistentTabItem(
              tab: pro.pages[1],
              icon: Icons.music_note_rounded,
              title: 'Library',
              navigatorkey: pro.libraryNavigatorKey,
            ),
            PersistentTabItem(
              tab: pro.pages[2],
              icon: Icons.person_rounded,
              title: 'Profile',
              navigatorkey: pro.profileNavigatorKey2,
            ),
          ],
        );
      },
    );
  }
}
