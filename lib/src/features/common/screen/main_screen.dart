import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:musiq/src/features/common/screen/offline_screen.dart';
import 'package:musiq/src/features/profile/screens/profile_screen.dart';
import 'package:musiq/src/features/view_all/widgets/sliver_app_bar/sliver_primary_app_bar.dart';
import 'package:provider/provider.dart';

import '../../../common_widgets/bottom_navigation_bar/bottom_navigation_bar.dart';
import '../../../core/package/miniplayer/miniplayer.dart';
import '../../player/screen/player_screen/player_controller.dart';
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
      child: Provider.of<InternetConnectionStatus>(context) ==
              InternetConnectionStatus.disconnected
          ? const OfflineScreen()
          : Scaffold(
              body: Stack(
                children: [
                  Column(
                    children: [
                      Expanded(
                        child: Consumer<BottomNavigationBarProvider>(
                            builder: (context, provider, _) {
                          return provider.pages[provider.selectedBottomIndex];
                        }),
                      ),
                      const SizedBox(
                        height: 60,
                      ),
                    ],
                  ),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Text("Song name"),
                                      Text("Album name"),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  padding: const EdgeInsets.all(0),
                                  onPressed: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (context) => AppBarSliver(
                                                  sliverList: SliverList(
                                                    delegate:
                                                        SliverChildBuilderDelegate(
                                                      (BuildContext context,
                                                          int index) {
                                                        return Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Center(
                                                              child: Text(
                                                                  "Item: $index")),
                                                        );
                                                      },
                                                      childCount: 50,
                                                    ),
                                                  ),
                                                )));
                                  },
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
