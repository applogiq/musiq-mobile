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
enum Options { play, queue, delete }
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
          : SafeArea(
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
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0),
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            // CustomSongVerticalList(
                            //   images: images.favList,
                            //   playButton: false,
                            // )
                            Column(
                                children: List.generate(
                              libraryController.view_all_songs_list.length,
                              // images.favList.length,
                              (index) => Container(
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.all(8),
                                child: InkWell(
                                    onTap: () {
                                      // var songPlayList=[];
                                      // for(int i=0;i<songList.length;i++){

                                      //   songPlayList.add(songList.records[i].id);
                                      // }
                                      // print(index);
                                      // Navigator.of(context).push(MaterialPageRoute(
                                      //     builder: (context) => PlayScreen(
                                      //       songList: songList,
                                      //       index: index,
                                      //       id:songList.records[index].id.toString(),
                                      //           imageURL:  "${APIConstants.SONG_BASE_URL}public/music/tamil/${songList.records[index].albumName[0].toUpperCase()}/${songList.records[index].albumName}/image/${songList.records[index].albumId}.png",
                                      //           songName: songList.records[index].songName,
                                      //           artistName: songList.records[index].musicDirectorName[0].toString(),
                                      //           songplayList: songPlayList,
                                      //         )));
                                    },
                                    child: SongListTile(
                                        view_all_song_list_model:
                                            libraryController
                                                .view_all_songs_list,
                                        index: index)),
                              ),
                            )),
                          ],
                        ),
                      ),
                      PlaylistScreen(images: images),
                    ],
                  ),
                ),
              ),
            );
    });

    ;
  }
}

class PlaylistScreen extends StatelessWidget {
  PlaylistScreen({
    Key? key,
    required this.images,
  }) : super(key: key);

  final Images images;
  APIRoute apiRoute = APIRoute();
  PopupMenuItem _buildPopupMenuItem(String title, index, {int position = 0}) {
    return PopupMenuItem(
      value: position,
      child: Row(
        children: [
          Text(title),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    LibraryController libraryController = Get.put(LibraryController());
    libraryController.loadPlayListData();
    return Obx(() {
      return libraryController.isLoadedPlayList.value == false
          ? LoaderScreen()
          : Scaffold(
              floatingActionButton: FloatingActionButton(
                mini: false,
                onPressed: () {
                  showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return CustomDialogBox(
                          title: ConstantText.createPlaylist,
                          fieldName: "Name",
                          buttonText: ConstantText.create,
                        );
                        ;
                      });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: CustomColor.secondaryColor,
                    borderRadius: BorderRadius.all(
                      Radius.circular(100),
                    ),
                    border: Border.all(color: Colors.transparent, width: 0.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.3),
                        // spreadRadius: 1,
                        // blurRadius: 1,
                        // offset: Offset(0, 4),
                        // offset: Offset(3, 5),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.add_rounded,
                  ),
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0),
                child: GetBuilder<LibraryController>(
                  init: LibraryController(),
                  initState: (_) {},
                  builder: (_) {
                    return ListView(
                      shrinkWrap: true,
                      // children: [
                      //   // CustomSongVerticalList(
                      //   //   images: images.playList,
                      //   //   playButton: false,
                      //   // )
                      // ],
                      children: List.generate(
                        libraryController.view_all_play_list.records.length,
                        (index) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: libraryController.view_all_play_list
                                        .records[index].noOfSongs ==
                                    0
                                ? () {}
                                : () async {
                                    print(libraryController
                                        .view_all_play_list.records[index].id);
                                    PlayListSongModel playListSongModel =
                                        await apiRoute.getSpecificPlaylist(
                                            libraryController.view_all_play_list
                                                .records[index].id);
                                    ViewAllBanner banner = ViewAllBanner(
                                        bannerId: libraryController
                                            .view_all_play_list
                                            .records[index]
                                            .id
                                            .toString(),
                                        bannerImageUrl: generateSongImageUrl(
                                            libraryController.view_all_play_list
                                                .records[index].albumName,
                                            libraryController.view_all_play_list
                                                .records[index].albumId),
                                        bannerTitle: libraryController
                                            .view_all_play_list
                                            .records[index]
                                            .playlistName);
                                    // auraSongModel= await apiRoute.getSpecificAuraSongs(id: auraModel.records[index].id);
                                    List<ViewAllSongList> viewAllSongListModel =
                                        [];
                                    for (int i = 0;
                                        i < playListSongModel.records.length;
                                        i++) {
                                      viewAllSongListModel.add(ViewAllSongList(
                                          playListSongModel.records[i].songId,
                                          generateSongImageUrl(
                                              playListSongModel
                                                  .records[i].albumName,
                                              playListSongModel
                                                  .records[i].albumId),
                                          playListSongModel.records[i].songName,
                                          playListSongModel
                                              .records[i].musicDirectorName[0],
                                          playListSongModel
                                              .records[i].albumName));
                                    }

                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ViewAllScreenSongList(
                                                    banner: banner,
                                                    view_all_song_list_model:
                                                        viewAllSongListModel)));
                                  },
                            child: Row(
                              children: [
                                libraryController.view_all_play_list
                                            .records[index].noOfSongs ==
                                        0
                                    ? Container(
                                        height: 70,
                                        width: 70,
                                        decoration: BoxDecoration(
                                            color: CustomColor.defaultCard,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            border: Border.all(
                                                color: CustomColor
                                                    .defaultCardBorder,
                                                width: 2.0)),
                                        child: Center(
                                            child: Text(
                                          libraryController.view_all_play_list
                                              .records[index].playlistName[0]
                                              .toString(),
                                          style: fontWeight600(),
                                        )),
                                      )
                                    : Align(
                                        alignment: Alignment.centerLeft,
                                        child: CustomColorContainer(
                                          bgColor: libraryController
                                                      .view_all_play_list
                                                      .records[index]
                                                      .noOfSongs ==
                                                  0
                                              ? CustomColor.defaultCard
                                              : Colors.transparent,
                                          child: libraryController
                                                      .view_all_play_list
                                                      .records[index]
                                                      .noOfSongs ==
                                                  0
                                              ? Container(
                                                  height: 70,
                                                  width: 70,
                                                  alignment: Alignment.center,
                                                  child: Text(libraryController
                                                      .view_all_play_list
                                                      .records[index]
                                                      .playlistName[0]))
                                              : Image.network(
                                                  generateSongImageUrl(
                                                      libraryController
                                                          .view_all_play_list
                                                          .records[index]
                                                          .albumName
                                                          .toString(),
                                                      libraryController
                                                          .view_all_play_list
                                                          .records[index]
                                                          .albumId
                                                          .toString())
                                                  // libraryController.view_all_songs_list[index].songImageUrl,
                                                  // images.playList[index].imageURL,
                                                  // "${APIConstants.SONG_BASE_URL}public/music/tamil/${songList.records[index].albumName[0].toUpperCase()}/${songList.records[index].albumName}/image/${songList.records[index].albumId}.png",
                                                  // "https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/450px-No_image_available.svg.png",
                                                  ,
                                                  height: 70,
                                                  width: 70,
                                                  fit: BoxFit.fill,
                                                ),
                                        ),
                                      ),
                                Expanded(
                                    flex: 9,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            libraryController.view_all_play_list
                                                .records[index].playlistName
                                                .toString(),
                                            // libraryController.view_all_play_list[index].records.
                                            // images.playList[index].title,
                                            // libraryController.view_all_play_list[index].records.      libraryController.view_all_play_list[index].songName,
                                            style: fontWeight400(),
                                          ),
                                          Text(
                                            "Playlist -" +
                                                libraryController
                                                    .view_all_play_list
                                                    .records[index]
                                                    .noOfSongs
                                                    .toString() +
                                                " songs",
                                            style: fontWeight400(
                                                size: 12.0,
                                                color: CustomColor.subTitle),
                                          ),
                                        ],
                                      ),
                                    )),
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: PopupMenuButton(
                                      color: CustomColor.appBarColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(8.0),
                                          bottomRight: Radius.circular(8.0),
                                          topLeft: Radius.circular(8.0),
                                          topRight: Radius.circular(8.0),
                                        ),
                                      ),
                                      onSelected: (value) {
                                        print(value);
                                        // _onMenuItemSelected(value as int);
                                        // _onMenuItemSelected(value as int);
                                      },
                                      itemBuilder: (ctx) => [
                                        _buildPopupMenuItem('Play All',Options.play.index),
                                        _buildPopupMenuItem('Add to queue',Options.queue.index),
                                        _buildPopupMenuItem('Delete',Options.delete.index),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
    });
  }
}
