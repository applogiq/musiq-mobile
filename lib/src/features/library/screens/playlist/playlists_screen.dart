import 'package:flutter/material.dart';
import 'package:musiq/src/common_widgets/loader.dart';
import 'package:musiq/src/features/library/screens/playlist/playlist_song_list.dart';
import 'package:provider/provider.dart';

import '../../../../common_widgets/container/custom_color_container.dart';
import '../../../../common_widgets/dialog/custom_dialog_box.dart';
import '../../../../constants/color.dart';
import '../../../../constants/string.dart';
import '../../../../constants/style.dart';
import '../../../../constants/style/box_decoration.dart';
import '../../../../utils/image_url_generate.dart';
import '../../provider/library_provider.dart';

class PlaylistsScreen extends StatefulWidget {
  const PlaylistsScreen({super.key});

  @override
  State<PlaylistsScreen> createState() => _PlaylistsScreenState();
}

class _PlaylistsScreenState extends State<PlaylistsScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      context.read<LibraryProvider>().getPlayListsList();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LibraryProvider>(builder: (context, pro, _) {
      return pro.isPlayListLoad
          ? const LoaderScreen()
          : Scaffold(
              floatingActionButton:
                  Consumer<LibraryProvider>(builder: (context, pro, _) {
                return FloatingActionButton(
                  onPressed: () {
                    pro.isPlayListError = false;
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return CustomDialogBox(
                            onChanged: (v) {
                              pro.checkPlayListName(v);
                            },
                            callBack: () async {
                              await pro.createPlayList(context);
                            },
                            title: ConstantText.createPlaylist,
                            fieldName: ConstantText.name,
                            buttonText: ConstantText.create,
                            errorValue: pro.playListError,
                            isError: pro.isPlayListError,
                            // callback: libraryController.createPlaylist(context),
                          );
                        });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: CustomColor.secondaryColor,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(100),
                      ),
                      border: Border.all(color: Colors.transparent, width: 0.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.3),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.add_rounded,
                    ),
                  ),
                );
              }),
              body: ListView.builder(
                  itemCount: pro.playListModel.records.length,
                  itemBuilder: (context, index) {
                    var record = pro.playListModel.records;
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const PlayListSongList()));
                        },
                        child: Row(
                          children: [
                            record[index].noOfSongs == 0
                                ? Container(
                                    height: 70,
                                    width: 70,
                                    decoration: PlayListNoImageDecoration(),
                                    child: Center(
                                      child: Text(
                                        record[index]
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
                                      bgColor: record[index].noOfSongs == 0
                                          ? CustomColor.defaultCard
                                          : Colors.transparent,
                                      child: record[index].noOfSongs == 0
                                          ? Container(
                                              height: 70,
                                              width: 70,
                                              alignment: Alignment.center,
                                              child: Text(record[index]
                                                  .playlistName[0]))
                                          : Image.network(
                                              generateSongImageUrl(
                                                  record[index]
                                                      .albumName
                                                      .toString(),
                                                  record[index]
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
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        record[index].playlistName.toString(),
                                        style: fontWeight400(),
                                      ),
                                      Text(
                                        "Playlist -${record[index].noOfSongs} songs",
                                        style: fontWeight400(
                                            size: 12.0,
                                            color: CustomColor.subTitle),
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
                                  shape: const RoundedRectangleBorder(
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
                                    // _buildPopupMenuItem('Play All',
                                    //     Options.play.index),
                                    // _buildPopupMenuItem(
                                    //     'Add to queue',
                                    //     Options.queue.index),
                                    // _buildPopupMenuItem('Delete',
                                    //     Options.delete.index,
                                    //     id: libraryController
                                    //         .view_all_play_list
                                    //         .records[index]
                                    //         .id),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }),
            );
    });
  }
}
