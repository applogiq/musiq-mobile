import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';

import '../../../../common_widgets/loader.dart';
import '../../../../constants/color.dart';
import '../../../../utils/image_url_generate.dart';
import '../../../common/screen/offline_screen.dart';
import '../../../home/screens/sliver_app_bar/widgets/album_song_list.dart';
import '../../../home/screens/sliver_app_bar/widgets/sliver_app_bar.dart';
import '../../provider/library_provider.dart';
import '../../widgets/playlist/no_song_playlist.dart';
import '../../widgets/playlist/view_all_playlist_pop_up_menu.dart';

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
                              popUpMenu: ViewAllPlaylistPopUpMenu(
                                id: widget.id!,
                                title: widget.title!,
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
                                          popUpMenu: ViewAllPlaylistPopUpMenu(
                                            id: widget.id!,
                                            title: widget.title!,
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
                                          },
                                          imageUrl: generateSongImageUrl(
                                                  pro.playlistSongListModel
                                                      .records[0].albumName,
                                                  pro.playlistSongListModel
                                                      .records[0].albumId) ??
                                              "",
                                          addToQueue: () {}),
                                      SliverList(
                                        delegate: SliverChildBuilderDelegate(
                                          childCount: pro.playlistSongListModel
                                              .records.length,
                                          (context, index) {
                                            var records = pro
                                                .playlistSongListModel.records;
                                            return InkWell(
                                              onTap: () {
                                                context
                                                    .read<LibraryProvider>()
                                                    .navigateToPlayerScreen(
                                                        context, widget.id!,
                                                        index: index);
                                              },
                                              child: PlaylistSongListTile(
                                                playlistId: records[index]
                                                    .playlistSongs
                                                    .playlistId,
                                                albumName:
                                                    records[index].albumName,
                                                imageUrl: generateSongImageUrl(
                                                    records[index].albumName,
                                                    records[index].albumId),
                                                musicDirectorName:
                                                    records[index]
                                                        .musicDirectorName[0],
                                                songName:
                                                    records[index].songName,
                                                songId: records[index]
                                                    .playlistSongs
                                                    .songId,
                                                playlistSongId: records[index]
                                                    .playlistSongs
                                                    .id,
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );

                  // return FutureBuilder(
                  //     future: pro.getPlayListSongList(widget.id!),
                  //     builder: (context, snapshot) {
                  //       if (snapshot.connectionState ==
                  //           ConnectionState.waiting) {
                  //         return const LoaderScreen();
                  //       } else {
                  //         return pro.playlistSongListModel.records.isEmpty
                  //             ? NoPlaylistSong(
                  //                 appBarTitle: widget.title!,
                  //                 playListId: widget.id.toString(),
                  //                 popUpMenu: ViewAllPlaylistPopUpMenu(
                  //                   id: widget.id!,
                  //                   title: widget.title!,
                  //                 ),
                  //               )
                  //             : DecoratedBox(
                  //                 decoration: const BoxDecoration(
                  //                   gradient: LinearGradient(
                  //                       begin: Alignment.topCenter,
                  //                       end: Alignment.bottomCenter,
                  //                       colors: [
                  //                         Colors.black,
                  //                         Colors.black,
                  //                       ],
                  //                       stops: [
                  //                         0,
                  //                         0.7
                  //                       ]),
                  //                 ),
                  //                 child: Stack(
                  //                   children: [
                  //                     CustomScrollView(
                  //                       controller: scrollController,
                  //                       slivers: [
                  //                         SliverCustomAppBar(
                  //                             popUpMenu:
                  //                                 ViewAllPlaylistPopUpMenu(
                  //                               id: widget.id!,
                  //                               title: widget.title!,
                  //                             ),
                  //                             maxAppBarHeight: maxAppBarHeight,
                  //                             minAppBarHeight: minAppBarHeight,
                  //                             title: widget.title!,
                  //                             songCounts: pro
                  //                                 .playlistSongListModel
                  //                                 .records
                  //                                 .length,
                  //                             callback: () {
                  //                               context
                  //                                   .read<LibraryProvider>()
                  //                                   .navigateToPlayerScreen(
                  //                                       context, widget.id!);
                  //                             },
                  //                             imageUrl: generateSongImageUrl(
                  //                                     pro.playlistSongListModel
                  //                                         .records[0].albumName,
                  //                                     pro
                  //                                         .playlistSongListModel
                  //                                         .records[0]
                  //                                         .albumId) ??
                  //                                 "",
                  //                             addToQueue: () {}),
                  //                         SliverList(
                  //                           delegate:
                  //                               SliverChildBuilderDelegate(
                  //                             childCount: pro
                  //                                 .playlistSongListModel
                  //                                 .records
                  //                                 .length,
                  //                             (context, index) {
                  //                               var records = pro
                  //                                   .playlistSongListModel
                  //                                   .records;
                  //                               return InkWell(
                  //                                 onTap: () {
                  //                                   context
                  //                                       .read<LibraryProvider>()
                  //                                       .navigateToPlayerScreen(
                  //                                           context, widget.id!,
                  //                                           index: index);
                  //                                 },
                  //                                 child: PlaylistSongListTile(
                  //                                   playlistId: records[index]
                  //                                       .playlistSongs
                  //                                       .playlistId,
                  //                                   albumName: records[index]
                  //                                       .albumName,
                  //                                   imageUrl:
                  //                                       generateSongImageUrl(
                  //                                           records[index]
                  //                                               .albumName,
                  //                                           records[index]
                  //                                               .albumId),
                  //                                   musicDirectorName: records[
                  //                                           index]
                  //                                       .musicDirectorName[0],
                  //                                   songName:
                  //                                       records[index].songName,
                  //                                   songId: records[index]
                  //                                       .playlistSongs
                  //                                       .songId,
                  //                                   playlistSongId:
                  //                                       records[index]
                  //                                           .playlistSongs
                  //                                           .id,
                  //                                 ),
                  //                               );
                  //                             },
                  //                           ),
                  //                         ),
                  //                       ],
                  //                     ),
                  //                   ],
                  //                 ),
                  //               );
                  //       }
                  //     });
                },
              ),
            ),
    );
  }
}
