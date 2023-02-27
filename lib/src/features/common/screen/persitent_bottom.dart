import 'package:flutter/material.dart';
import 'package:musiq/src/common_widgets/bottom_navigation_bar/bottom_navigation_bar.dart';
import 'package:musiq/src/features/common/provider/bottom_navigation_bar_provider.dart';
import 'package:musiq/src/features/player/provider/player_provider.dart';
import 'package:musiq/src/features/player/screen/player_screen/player_screen.dart';
import 'package:provider/provider.dart';

import '../../../core/package/we_slide/we_slide.dart';
import '../../home/widgets/bottom_navigation_bar_widget.dart';

class PersistentBottomBarScaffold extends StatefulWidget {
  /// pass the required items for the tabs and BottomNavigationBar
  final List<PersistentTabItem> items;

  const PersistentBottomBarScaffold({Key? key, required this.items})
      : super(key: key);

  @override
  _PersistentBottomBarScaffoldState createState() =>
      _PersistentBottomBarScaffoldState();
}

class _PersistentBottomBarScaffoldState
    extends State<PersistentBottomBarScaffold> {
  // final int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    final WeSlideController controller = WeSlideController();

    // final colorScheme = Theme.of(context).colorScheme;
    const double panelMinSize = 120.0;
    final double panelMaxSize = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        var pro = context.read<BottomNavigationBarProvider>();
        if (pro.selectedBottomIndex == 0) {
          if (pro.homeNavigatorKey.currentState?.canPop() ?? false) {
            pro.homeNavigatorKey.currentState?.pop();
          }
        } else if (pro.selectedBottomIndex == 1) {
          if (pro.libraryNavigatorKey.currentState?.canPop() ?? false) {
            pro.libraryNavigatorKey.currentState?.pop();
          }
        } else {
          if (pro.profileNavigatorKey2.currentState?.canPop() ?? false) {
            pro.profileNavigatorKey2.currentState?.pop();
          }
        }
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          body: Consumer<PlayerProvider>(builder: (context, playerProvider, _) {
            return WeSlide(
              controller: controller,
              panelMinSize: playerProvider.isPlaying ? panelMinSize : 60,
              panelMaxSize: panelMaxSize,
              body: Consumer<BottomNavigationBarProvider>(
                  builder: (context, pro, _) {
                return IndexedStack(
                  index: pro.selectedBottomIndex,
                  children: widget.items
                      .map((page) => Navigator(
                            key: page.navigatorkey,
                            onGenerateInitialRoutes: (navigator, initialRoute) {
                              return [
                                MaterialPageRoute(
                                    builder: (context) => page.tab)
                              ];
                            },
                          ))
                      .toList(),
                );
              }),
              panelHeader: playerProvider.isPlaying
                  ? MiniPlayer(
                      onChnage: controller.show,
                    )
                  : const SizedBox.shrink(),
              panel: PlayerScreen(
                onTap: () {
                  controller.hide();
                },
              ),
              footer: BottomNavigationBarWidget(
                width: width,
              ),
            );
          }),
        ),
      ),
    );
  }
}

/// Model class that holds the tab info for the [PersistentBottomBarScaffold]
class PersistentTabItem {
  final Widget tab;
  final GlobalKey<NavigatorState>? navigatorkey;
  final String title;
  final IconData icon;

  PersistentTabItem(
      {required this.tab,
      this.navigatorkey,
      required this.title,
      required this.icon});
}
