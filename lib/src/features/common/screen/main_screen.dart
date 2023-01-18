import 'package:flutter/material.dart';
import 'package:musiq/src/features/player/screen/player_screen.dart';
import 'package:musiq/src/features/profile/screens/profile_screen.dart';
import 'package:provider/provider.dart';

import '../../../common_widgets/bottom_navigation_bar/bottom_navigation_bar.dart';
import '../../../core/package/miniplayer/miniplayer.dart';
import '../provider/bottom_navigation_bar_provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void dispose() {
    BottomNavigationBarProvider()
        .pages[BottomNavigationBarProvider().selectedBottomIndex];
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Consumer<BottomNavigationBarProvider>(
                builder: (context, provider, _) {
              return provider.pages[provider.selectedBottomIndex];
            }),
            Miniplayer(
                minHeight: 60.0,
                maxHeight: MediaQuery.of(context).size.height,
                builder: (h, p) => h > 140
                    ? const ProfileScreen()
                    : Row(
                        children: [
                          Container(
                            height: 60,
                            width: 60,
                            color: Colors.amber,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text("Song name"),
                                Text("Album name"),
                              ],
                            ),
                          ),
                          IconButton(
                            padding: const EdgeInsets.all(0),
                            onPressed: () {},
                            icon: const Icon(Icons.skip_previous_rounded),
                          ),
                          PlayButtonWidget(),
                          IconButton(
                            padding: const EdgeInsets.all(0),
                            onPressed: () {},
                            icon: const Icon(Icons.skip_next_rounded),
                          ),
                        ],
                      )),
          ],
        ),
        bottomNavigationBar: BottomNavigationBarWidget(
          width: width,
        ),
      ),
    );
  }
}
