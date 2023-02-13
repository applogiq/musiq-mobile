import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';

import '../../home/widgets/bottom_navigation_bar_widget.dart';
import '../../player/provider/player_provider.dart';
import '../provider/bottom_navigation_bar_provider.dart';
import 'offline_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
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
    return SafeArea(
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
