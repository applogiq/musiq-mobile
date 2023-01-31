import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:musiq/src/constants/color.dart';
import 'package:musiq/src/features/library/provider/library_provider.dart';
import 'package:musiq/src/features/library/screens/playlist/no_song_playlist.dart';
import 'package:musiq/src/utils/image_url_generate.dart';
import 'package:provider/provider.dart';

import '../../../../common_widgets/loader.dart';
import '../../../common/screen/offline_screen.dart';
import '../../../home/screens/sliver_app_bar/widgets/album_song_list.dart';
import '../../../home/screens/sliver_app_bar/widgets/sliver_app_bar.dart';

class ViewPlaylistSongScreen extends StatefulWidget {
  const ViewPlaylistSongScreen(
      {super.key, this.id, this.auraId, this.title, this.isImage = true});

  final int? id;
  final String? auraId;
  final String? title;
  final bool isImage;

  @override
  State<ViewPlaylistSongScreen> createState() => _ViewPlaylistSongScreenState();
}

class _ViewPlaylistSongScreenState extends State<ViewPlaylistSongScreen> {
  late ScrollController scrollController;

  late double maxAppBarHeight;
  late double minAppBarHeight;
  late double playPauseButtonSize;
  late double infoBoxHeight;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var provider = Provider.of<LibraryProvider>(context, listen: false);
      provider.getPlayListSongList(widget.id!);
    });
  }

  // getTitle(ViewAllStatus viewAllStatus) {
  //   switch (viewAllStatus) {
  //     case ViewAllStatus.newRelease:
  //       return "New Release";
  //     case ViewAllStatus.recentlyPlayed:
  //       return "Recently Played";
  //     case ViewAllStatus.trendingHits:
  //       return "Trending hits";
  //     case ViewAllStatus.album:
  //       return context
  //           .read<ViewAllProvider>()
  //           .albumSongListModel
  //           .records[0]
  //           .albumName;
  //     case ViewAllStatus.artist:
  //       return widget.title;
  //     case ViewAllStatus.aura:
  //       return widget.title;
  //     default:
  //       return "";
  //   }
  // }

  // getImageUrl(ViewAllStatus status, ViewAllProvider pro) {
  //   switch (status) {
  //     case ViewAllStatus.newRelease:
  //       return generateSongImageUrl(pro.newReleaseModel.records[0].albumName,
  //           pro.newReleaseModel.records[0].albumId);
  //     case ViewAllStatus.recentlyPlayed:
  //       return generateSongImageUrl(pro.recentlyPlayed.records[0][0].albumName,
  //           pro.recentlyPlayed.records[0][0].albumId);
  //     case ViewAllStatus.trendingHits:
  //       return generateSongImageUrl(pro.trendingHitsModel.records[0].albumName,
  //           pro.trendingHitsModel.records[0].albumId);
  //     case ViewAllStatus.album:
  //       return generateSongImageUrl(
  //         pro.albumSongListModel.records[0].albumName,
  //         pro.albumSongListModel.records[0].albumId,
  //       );
  //     case ViewAllStatus.aura:
  //       return generateAuraImageUrl(widget.auraId);
  //     case ViewAllStatus.artist:
  //       if (widget.isImage) {
  //         return generateArtistImageUrl(widget.auraId);
  //       } else {
  //         return "";
  //       }
  //     default:
  //       return "https://images.unsplash.com/photo-1499415479124-43c32433a620?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1032&q=80";
  //   }
  // }

  // int getSongCount(ViewAllStatus viewAllStatus) {
  //   switch (viewAllStatus) {
  //     case ViewAllStatus.newRelease:
  //       return context.read<ViewAllProvider>().newReleaseModel.records.length;
  //     case ViewAllStatus.recentlyPlayed:
  //       return context.read<ViewAllProvider>().recentlyPlayed.records.length;
  //     case ViewAllStatus.trendingHits:
  //       return context.read<ViewAllProvider>().trendingHitsModel.records.length;
  //     case ViewAllStatus.album:
  //       return context
  //           .read<ViewAllProvider>()
  //           .albumSongListModel
  //           .records
  //           .length;
  //     case ViewAllStatus.aura:
  //       return context.read<ViewAllProvider>().auraSongListModel.records.length;
  //     case ViewAllStatus.artist:
  //       return context
  //           .read<ViewAllProvider>()
  //           .collectionViewAllModel
  //           .records
  //           .length;
  //     default:
  //       return 0;
  //   }
  // }

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
                              playListId: widget.id.toString())
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
                                          maxAppBarHeight: maxAppBarHeight,
                                          minAppBarHeight: minAppBarHeight,
                                          title: widget.title!,
                                          songCounts: pro.playlistSongListModel
                                              .records.length,
                                          callback: () {
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
