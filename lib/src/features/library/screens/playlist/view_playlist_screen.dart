import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';

import '../../../../common_widgets/dialog/custom_dialog_box.dart';
import '../../../../common_widgets/loader.dart';
import '../../../../constants/color.dart';
import '../../../../constants/string.dart';
import '../../../../routing/route_name.dart';
import '../../../../utils/image_url_generate.dart';
import '../../../../utils/navigation.dart';
import '../../../common/screen/offline_screen.dart';
import '../../../home/provider/search_provider.dart';
import '../../../home/screens/sliver_app_bar/widgets/album_song_list.dart';
import '../../../home/screens/sliver_app_bar/widgets/sliver_app_bar.dart';
import '../../../search/screens/search_screen.dart';
import '../../../search/search_status.dart';
import '../../provider/library_provider.dart';
import 'no_song_playlist.dart';

class ViewPlaylistSongScreen extends StatefulWidget {
  const ViewPlaylistSongScreen(
      {super.key, this.id, this.auraId, this.title, this.isImage = true});

  final String? auraId;
  final int? id;
  final bool isImage;
  final String? title;

  @override
  State<ViewPlaylistSongScreen> createState() => _ViewPlaylistSongScreenState();
}

class _ViewPlaylistSongScreenState extends State<ViewPlaylistSongScreen> {
  late double infoBoxHeight;
  late double maxAppBarHeight;
  late double minAppBarHeight;
  late double playPauseButtonSize;
  late ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var provider = Provider.of<LibraryProvider>(context, listen: false);
      provider.getPlayListSongList(widget.id!);
    });
  }

  @override
  Widget build(BuildContext context) {
    maxAppBarHeight = MediaQuery.of(context).size.height * 0.5;
    minAppBarHeight = MediaQuery.of(context).padding.top +
        MediaQuery.of(context).size.height * 0.06;

    return SafeArea(
      child: Provider.of<InternetConnectionStatus>(context) ==
              InternetConnectionStatus.disconnected
          ? const OfflineScreen()
          : Scaffold(
              backgroundColor: CustomColor.bg,
              body: Consumer<LibraryProvider>(
                builder: (context, pro, _) {
                  return pro.isPlayListSongLoad
                      ? const LoaderScreen()
                      : pro.playlistSongListModel.records.isEmpty
                          ? NoPlaylistSong(
                              appBarTitle: widget.title!,
                              playListId: widget.id.toString(),
                              popUpMenu: PopupMenuButton(
                                color: CustomColor.appBarColor,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(8.0),
                                    bottomRight: Radius.circular(8.0),
                                    topLeft: Radius.circular(8.0),
                                    topRight: Radius.circular(8.0),
                                  ),
                                ),
                                padding: const EdgeInsets.all(0.0),
                                onSelected: (value) async {
                                  if (value == 1) {
                                    context.read<SearchProvider>().resetState();
                                    Navigation.navigateToScreen(
                                        context, RouteName.search,
                                        args: SearchRequestModel(
                                            searchStatus: SearchStatus.playlist,
                                            playlistId: widget.id));
                                    // context
                                    //     .read<ViewAllProvider>()
                                    //     .addQueue(
                                    //         widget.status, context);
                                  } else if (value == 2) {
                                    print("Rename");
                                    showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (BuildContext context) {
                                          return CustomDialogBox(
                                            onChanged: (v) {
                                              pro.checkPlayListName(v);
                                            },
                                            callBack: () async {
                                              await pro.updatePlayListName(
                                                  context, widget.id!);
                                            },
                                            initialText: widget.title!,
                                            title: ConstantText.renamePlaylist,
                                            fieldName: ConstantText.name,
                                            buttonText: ConstantText.rename,
                                            errorValue: pro.playListError,
                                            isError: pro.isPlayListError,
                                            // callback: libraryController.createPlaylist(context),
                                          );
                                        });
                                  } else if (value == 3) {
                                    await context
                                        .read<LibraryProvider>()
                                        .deletePlayList(widget.id!);
                                    Navigation.navigateReplaceToScreen(
                                        context, RouteName.library);
                                  }
                                },
                                itemBuilder: (ctx) => [
                                  const PopupMenuItem(
                                    value: 1,
                                    child: Text('Add songs'),
                                  ),
                                  const PopupMenuItem(
                                    value: 2,
                                    child: Text('Rename'),
                                  ),
                                  const PopupMenuItem(
                                    value: 3,
                                    child: Text('Delete'),
                                  ),
                                ],
                              ),
                            )
                          : DecoratedBox(
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.black,
                                      Colors.black,
                                    ],
                                    stops: [
                                      0,
                                      0.7
                                    ]),
                              ),
                              child: Stack(
                                children: [
                                  CustomScrollView(
                                    controller: scrollController,
                                    slivers: [
                                      SliverCustomAppBar(
                                          popUpMenu: PopupMenuButton(
                                            color: CustomColor.appBarColor,
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                bottomLeft:
                                                    Radius.circular(8.0),
                                                bottomRight:
                                                    Radius.circular(8.0),
                                                topLeft: Radius.circular(8.0),
                                                topRight: Radius.circular(8.0),
                                              ),
                                            ),
                                            padding: const EdgeInsets.all(0.0),
                                            onSelected: (value) async {
                                              if (value == 1) {
                                                context
                                                    .read<SearchProvider>()
                                                    .resetState();
                                                Navigation.navigateToScreen(
                                                    context, RouteName.search,
                                                    args: SearchRequestModel(
                                                        searchStatus:
                                                            SearchStatus
                                                                .playlist,
                                                        playlistId: widget.id));
                                                // context
                                                //     .read<ViewAllProvider>()
                                                //     .addQueue(
                                                //         widget.status, context);
                                              } else if (value == 2) {
                                                print("Rename");
                                                showDialog(
                                                    context: context,
                                                    barrierDismissible: false,
                                                    builder:
                                                        (BuildContext context) {
                                                      return CustomDialogBox(
                                                        onChanged: (v) {
                                                          pro.checkPlayListName(
                                                              v);
                                                        },
                                                        callBack: () async {
                                                          await pro
                                                              .updatePlayListName(
                                                                  context,
                                                                  widget.id!);
                                                        },
                                                        initialText:
                                                            widget.title!,
                                                        title: ConstantText
                                                            .renamePlaylist,
                                                        fieldName:
                                                            ConstantText.name,
                                                        buttonText:
                                                            ConstantText.rename,
                                                        errorValue:
                                                            pro.playListError,
                                                        isError:
                                                            pro.isPlayListError,
                                                        // callback: libraryController.createPlaylist(context),
                                                      );
                                                    });
                                              } else if (value == 3) {
                                                await context
                                                    .read<LibraryProvider>()
                                                    .deletePlayList(widget.id!);
                                                Navigation
                                                    .navigateReplaceToScreen(
                                                        context,
                                                        RouteName.library);
                                              }
                                            },
                                            itemBuilder: (ctx) => [
                                              const PopupMenuItem(
                                                value: 1,
                                                child: Text('Add songs'),
                                              ),
                                              const PopupMenuItem(
                                                value: 2,
                                                child: Text('Rename'),
                                              ),
                                              const PopupMenuItem(
                                                value: 3,
                                                child: Text('Delete'),
                                              ),
                                            ],
                                          ),
                                          maxAppBarHeight: maxAppBarHeight,
                                          minAppBarHeight: minAppBarHeight,
                                          title: widget.title!,
                                          songCounts: pro.playlistSongListModel
                                              .records.length,
                                          callback: () {
                                            context
                                                .read<LibraryProvider>()
                                                .navigateToPlayerScreen(
                                                    context, widget.id!);
                                            // context
                                            //     .read<ViewAllProvider>()
                                            //     .navigateToPlayerScreen(
                                            //         context, widget.status);
                                          },
                                          imageUrl: "",
                                          addToQueue: () {
                                            // context
                                            //     .read<ViewAllProvider>()
                                            //     .addQueue(widget.status, context);
                                          }),
                                      SliverList(
                                        delegate: SliverChildBuilderDelegate(
                                            childCount: pro
                                                .playlistSongListModel
                                                .records
                                                .length, (context, index) {
                                          var records =
                                              pro.playlistSongListModel.records;
                                          return InkWell(
                                            onTap: () {
                                              context
                                                  .read<LibraryProvider>()
                                                  .navigateToPlayerScreen(
                                                      context, widget.id!,
                                                      index: index);
                                              // context
                                              //     .read<ViewAllProvider>()
                                              //     .navigateToPlayerScreen(context, status, index: index);
                                            },
                                            child: SongListTile(
                                              albumName:
                                                  records[index].albumName,
                                              imageUrl: generateSongImageUrl(
                                                  records[index].albumName,
                                                  records[index].albumId),
                                              musicDirectorName: records[index]
                                                  .musicDirectorName[0],
                                              songName: records[index].songName,
                                              songId: records[index]
                                                  .playlistSongs
                                                  .songId,
                                            ),
                                          );
                                        }),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                },
              ),
            ),
    );
  }
}
