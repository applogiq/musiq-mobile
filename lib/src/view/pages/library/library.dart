import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:musiq/src/helpers/constants/color.dart';
import 'package:musiq/src/helpers/constants/images.dart';
import 'package:musiq/src/helpers/constants/string.dart';
import 'package:musiq/src/helpers/utils/image_url_generate.dart';
import 'package:musiq/src/logic/controller/library_controller.dart';
import 'package:musiq/src/logic/services/api_route.dart';
import 'package:musiq/src/model/api_model/playlist_song_model.dart';
import 'package:musiq/src/view/pages/home/components/pages/view_all/view_all_songs_list.dart';
import 'package:musiq/src/view/pages/home/components/widget/loader.dart';
import 'package:musiq/src/view/pages/home/components/widget/vertical_list_view.dart';

import '../../../helpers/constants/style.dart';
import '../../../model/ui_model/view_all_song_list_model.dart';
import '../../widgets/custom_color_container.dart';
import '../../widgets/custom_dialog_box.dart';
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

