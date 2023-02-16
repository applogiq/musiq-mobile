import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:musiq/src/features/common/screen/offline_screen.dart';
import 'package:musiq/src/features/home/widgets/bottom_navigation_bar_widget.dart';
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
    return
        //  CupertinoTabScaffold(
        //     // ignore: prefer_const_literals_to_create_immutables
        //     tabBar: CupertinoTabBar(items: <BottomNavigationBarItem>[
        //       const  BottomNavigationBarItem(
        //         icon: Icon(Icons.home),
        //       ),
        //       const BottomNavigationBarItem(
        //         icon: Icon(Icons.home),
        //       ),
        //       const BottomNavigationBarItem(
        //         icon: Icon(Icons.home),
        //       ),
        //     ]),
        //     tabBuilder: (context, index) {
        //       switch (index) {
        //         case 0:
        //           return CupertinoTabView(
        //             builder: (context) {
        //               return const CupertinoPageScaffold(
        //                   child: Material(child: HomeScreen()));
        //             },
        //           );

        //         case 1:
        //           return CupertinoTabView(
        //             builder: (context) {
        //               return const CupertinoPageScaffold(child: LibraryScreen());
        //             },
        //           );

        //         case 2:
        //           return CupertinoTabView(
        //             builder: (context) {
        //               return const CupertinoPageScaffold(child: ProfileScreen());
        //             },
        //           );
        //       }
        //       return Container();
        //     });

        SafeArea(
      child: Scaffold(
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Provider.of<InternetConnectionStatus>(context) ==
                    InternetConnectionStatus.disconnected
                ? const OfflineScreen()
                : Column(
                    children: [
                      Expanded(
                        child: Consumer<BottomNavigationBarProvider>(
                          builder: (context, provider, _) {
                            return provider.pages[provider.selectedBottomIndex];
                          },
                        ),
                      ),
                    ],
                  ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBarWithMiniPlayer(
          width: width,
        ),
      ),
    );
  }
}
