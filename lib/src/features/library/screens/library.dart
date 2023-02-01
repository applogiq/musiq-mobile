import 'package:flutter/material.dart';

import '../../../constants/color.dart';
import 'favourite_screen.dart';
import 'playlist/playlists_screen.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const LibraryTabBarMain();
  }
}

class LibraryTabBarMain extends StatelessWidget {
  const LibraryTabBarMain({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              "Library",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            bottom: PreferredSize(
              preferredSize: const Size(double.maxFinite, 60),
              child: Container(
                margin: const EdgeInsets.fromLTRB(16, 24, 16, 0),
                decoration: BoxDecoration(
                    color: CustomColor.textfieldBg,
                    borderRadius: BorderRadius.circular(12)),
                child: const FavouritesAndPlaylistsTab(),
              ),
            ),
            backgroundColor: Colors.transparent,
          ),
          body: const TabBarView(
            children: [FavouritesScreen(), PlaylistsScreen()],
          ),
        ),
      ),
    );
  }
}

class FavouritesAndPlaylistsTab extends StatelessWidget {
  const FavouritesAndPlaylistsTab({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TabBar(
      indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(12), // Creates border
          color: CustomColor.secondaryColor),
      tabs: const [
        Tab(
            icon: Text(
          "Favourites",
          style: TextStyle(fontWeight: FontWeight.w400),
        )),
        Tab(
          icon: Text(
            "Playlists",
            style: TextStyle(fontWeight: FontWeight.w400),
          ),
        ),
      ],
    );
  }
}
