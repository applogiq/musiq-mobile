
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musiq/src/logic/controller/library_controller.dart';
import 'package:musiq/src/view/pages/home/components/widget/loader.dart';

import '../../../constants/color.dart';
import '../../../constants/images.dart';
import 'favourites/favourite_main.dart';
import 'playlist/playlist_main.dart';

class Library extends StatelessWidget {
  Library({Key? key}) : super(key: key);
  Images images = Images();

  @override
  Widget build(BuildContext context) {
    LibraryController libraryController = Get.put(LibraryController());
    libraryController.loadFavouriteData();
    return Obx(() {
      return libraryController.isLoaded.value == false
          ? LoaderScreen()
          : LibraryTabBarMain(libraryController: libraryController,);
    });

    ;
  }
}

class LibraryTabBarMain extends StatelessWidget {
  const LibraryTabBarMain({
    Key? key,
    required this.libraryController,
  
  }) : super(key: key);

  final LibraryController libraryController;
  

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                "Library",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              bottom: PreferredSize(
                preferredSize: Size(double.maxFinite, 60),
                child: Container(
                  margin: EdgeInsets.fromLTRB(16, 24, 16, 0),
                  decoration: BoxDecoration(
                      color: CustomColor.textfieldBg,
                      borderRadius: BorderRadius.circular(12)),
                  child: TabBar(
                    indicator: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(12), // Creates border
                        color: CustomColor.secondaryColor),
                    tabs: [
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
                  ),
                ),
              ),
              backgroundColor: Colors.transparent,
            ),
            body: TabBarView(
              children: [
                FavouritesMain(libraryController: libraryController),
                PlaylistScreen(),
              ],
            ),
          ),
        ),
      );
  }
}

