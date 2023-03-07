// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:musiq/src/features/common/provider/pop_up_provider.dart';
import 'package:musiq/src/features/player/screen/player_screen/player_screen.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';

import '../../../core/package/we_slide/we_slide.dart';
import '../../home/widgets/bottom_navigation_bar_widget.dart';
import '../../player/provider/player_provider.dart';
import '../provider/bottom_navigation_bar_provider.dart';
import 'offline_screen.dart';

// import 'package:we_slide/we_slide.dart';

// final _colorScheme = Theme.of(context).colorScheme;
// final double _panelMinSize = 70.0;
// final double _panelMaxSize = MediaQuery.of(context).size.height / 2;
// return Scaffold(
//   backgroundColor: Colors.black,
// body: WeSlide(
//   panelMinSize: _panelMinSize,
//   panelMaxSize: _panelMaxSize,
//   body: Container(
//     color: _colorScheme.background,
//     child: Center(child: Text("This is the body 💪")),
//   ),
//   panel: Container(
//     color: _colorScheme.primary,
//     child: Center(child: Text("This is the panel 😊")),
//   ),
//   panelHeader: Container(
//     height: _panelMinSize,
//     color: _colorScheme.secondary,
//     child: Center(child: Text("Slide to Up ☝️")),
//   ),
// ),
// );
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
    final WeSlideController controller = WeSlideController();
    double width = MediaQuery.of(context).size.width;

    const double panelMinSize = 120.0;
    final double panelMaxSize = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Provider.of<InternetConnectionStatus>(context) ==
                    InternetConnectionStatus.disconnected
                ? const OfflineScreen()
                : WeSlide(
                    controller: controller,
                    panelMinSize: panelMinSize,
                    panelMaxSize: panelMaxSize,
                    body: Expanded(
                      child: Consumer<BottomNavigationBarProvider>(
                        builder: (context, provider, _) {
                          return provider.pages[provider.selectedBottomIndex];
                        },
                      ),
                    ),
                    panel: PlayerScreen(onTap: () {
                      controller.hide();
                    }),
                    panelHeader: MiniPlayer(
                      onChange: controller.show,
                    ),
                    footer: BottomNavigationBarWithMiniPlayer(
                      width: width,
                    ),
                  ),
            // : Column(
            //     children: [
            //       Expanded(
            //         child: Consumer<BottomNavigationBarProvider>(
            //           builder: (context, provider, _) {
            //             return provider.pages[provider.selectedBottomIndex];
            //           },
            //         ),
            //       ),
            //     ],
            //   ),
          ],
        ),
      ),
    );
  }
}
