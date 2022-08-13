import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musiq/src/view/pages/library/favourites/no_favourite.dart';
import 'package:musiq/src/view/pages/library/playlist/no_playlist_song.dart';

import '../../../../constants/color.dart';
import '../../../../constants/string.dart';
import '../../../../constants/style.dart';
import '../../../../constants/style/box_decoration.dart';
import '../../../../helpers/utils/image_url_generate.dart';
import '../../../../logic/controller/library_controller.dart';
import '../../../../logic/services/api_route.dart';
import '../../../../model/api_model/playlist_song_model.dart';
import '../../../../model/ui_model/view_all_song_list_model.dart';
import '../../../../widgets/custom_color_container.dart';
import '../../home/components/pages/view_all/view_all_songs_list.dart';
import '../../home/components/widget/loader.dart';
import 'playlist_floating_button.dart';

enum Options { play, queue, delete }

class PlaylistScreen extends StatelessWidget {
  PlaylistScreen({
    Key? key,
  }) : super(key: key);

  LibraryController libraryController = Get.put(LibraryController());

  APIRoute apiRoute = APIRoute();
  PopupMenuItem _buildPopupMenuItem(
    String title,
    value, {
    int position = 0,
    int id = 0,
  }) {
    return PopupMenuItem(
      onTap: () async {
        if (Options.delete == Options.values[value]) {
          await libraryController.deletePlaylist(id);
        }
      },
      value: value,
      child: Row(
        children: [
          Text(title),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    libraryController.loadPlayListData();
    return Obx(() {
      return libraryController.isLoadedPlayList.value == false
          ? LoaderScreen()
          : Scaffold(
              floatingActionButton: PlaylistButton(),
              body: Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0),
                child: GetBuilder<LibraryController>(
                  init: LibraryController(),
                  initState: (_) {},
                  builder: (_) {
                    return libraryController
                                .view_all_play_list.records.length ==
                            0
                        ? NoSongScreen(
                            mainTitle: ConstantText.noPlaylistHere,
                            subTitle: "")
                        : ListView(
                            shrinkWrap: true,
                            children: List.generate(
                              libraryController
                                  .view_all_play_list.records.length,
                              (index) => Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                  onTap: libraryController.view_all_play_list
                                              .records[index].noOfSongs ==
                                          0
                                      ? () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      NoPlaylistSong(
                                                        appBarTitle:
                                                            libraryController
                                                                .view_all_play_list
                                                                .records[index]
                                                                .playlistName
                                                                .toString(),
                                                        playListId:
                                                            libraryController
                                                                .view_all_play_list
                                                                .records[index]
                                                                .id
                                                                .toString(),
                                                      )));
                                        }
                                      : () async {
                                          PlayListSongModel playListSongModel =
                                              await apiRoute
                                                  .getSpecificPlaylist(
                                                      libraryController
                                                          .view_all_play_list
                                                          .records[index]
                                                          .id);
                                          ViewAllBanner banner = ViewAllBanner(
                                              bannerId: libraryController
                                                  .view_all_play_list
                                                  .records[index]
                                                  .id
                                                  .toString(),
                                              bannerImageUrl:
                                                  generateSongImageUrl(
                                                      libraryController
                                                          .view_all_play_list
                                                          .records[index]
                                                          .albumName,
                                                      libraryController
                                                          .view_all_play_list
                                                          .records[index]
                                                          .albumId),
                                              bannerTitle: libraryController
                                                  .view_all_play_list
                                                  .records[index]
                                                  .playlistName);
                                          List<ViewAllSongList>
                                              viewAllSongListModel = [];
                                          for (int i = 0;
                                              i <
                                                  playListSongModel
                                                      .records.length;
                                              i++) {
                                            viewAllSongListModel.add(
                                                ViewAllSongList(
                                                    playListSongModel.records[i]
                                                        .playlistSongs.songId
                                                        .toString(),
                                                    generateSongImageUrl(
                                                        playListSongModel
                                                            .records[i]
                                                            .albumName,
                                                        playListSongModel
                                                            .records[i]
                                                            .albumId),
                                                    playListSongModel
                                                        .records[i].songName,
                                                    playListSongModel.records[i]
                                                        .musicDirectorName[0],
                                                    playListSongModel
                                                        .records[i].albumName,
                                                    playListSongModel
                                                        .records[i].albumName));
                                          }

                                          Navigator.of(context).push(MaterialPageRoute(
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
                                              decoration:
                                                  PlayListNoImageDecoration(),
                                              child: Center(
                                                child: Text(
                                                  libraryController
                                                      .view_all_play_list
                                                      .records[index]
                                                      .playlistName[0]
                                                      .toString()
                                                      .toUpperCase(),
                                                  style: fontWeight600(),
                                                ),
                                              ),
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
                                                        alignment:
                                                            Alignment.center,
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
                                                                .toString()),
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
                                                  libraryController
                                                      .view_all_play_list
                                                      .records[index]
                                                      .playlistName
                                                      .toString(),
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
                                                      color:
                                                          CustomColor.subTitle),
                                                ),
                                              ],
                                            ),
                                          )),
                                      Expanded(
                                        flex: 2,
                                        child: Align(
                                          // alignment: Alignment.centerRight,
                                          child: PopupMenuButton(
                                            color: CustomColor.appBarColor,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                bottomLeft:
                                                    Radius.circular(8.0),
                                                bottomRight:
                                                    Radius.circular(8.0),
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
                                              _buildPopupMenuItem('Play All',
                                                  Options.play.index),
                                              _buildPopupMenuItem(
                                                  'Add to queue',
                                                  Options.queue.index),
                                              _buildPopupMenuItem('Delete',
                                                  Options.delete.index,
                                                  id: libraryController
                                                      .view_all_play_list
                                                      .records[index]
                                                      .id),
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
