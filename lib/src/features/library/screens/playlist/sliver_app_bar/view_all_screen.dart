import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:musiq/src/common_widgets/loader.dart';
import 'package:musiq/src/features/common/screen/offline_screen.dart';
import 'package:musiq/src/features/home/provider/view_all_provider.dart';
import 'package:musiq/src/features/home/screens/artist_view_all/album_info.dart';
import 'package:musiq/src/features/home/screens/sliver_app_bar/widgets/sliver_app_bar.dart';
import 'package:musiq/src/features/home/view_all_status.dart';
import 'package:musiq/src/features/library/provider/play_list_provider.dart';
import 'package:musiq/src/utils/image_url_generate.dart';
import 'package:provider/provider.dart';

import 'widgets/album_song_list.dart';

class ViewSongScreen extends StatefulWidget {
  const ViewSongScreen({
    super.key,
  });

  @override
  State<ViewSongScreen> createState() => _ViewSongScreenState();
}

class _ViewSongScreenState extends State<ViewSongScreen> {
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
      Provider.of<PlayListProvider>(context, listen: false)
          .getPlayListDetails();
    });
  }

  getTitle(ViewAllStatus viewAllStatus) {
    switch (viewAllStatus) {
      case ViewAllStatus.newRelease:
        return "New Release";
      case ViewAllStatus.recentlyPlayed:
        return "Recently Played";
      case ViewAllStatus.trendingHits:
        return "Trending hits";
      case ViewAllStatus.album:
        return context
            .read<ViewAllProvider>()
            .albumSongListModel
            .records[0]
            .albumName;
      case ViewAllStatus.aura:

      default:
        return "";
    }
  }

  getImageUrl(ViewAllStatus status, ViewAllProvider pro) {
    switch (status) {
      case ViewAllStatus.newRelease:
        return generateSongImageUrl(pro.newReleaseModel.records[0].albumName,
            pro.newReleaseModel.records[0].albumId);
      case ViewAllStatus.recentlyPlayed:
        return generateSongImageUrl(pro.recentlyPlayed.records[0][0].albumName,
            pro.recentlyPlayed.records[0][0].albumId);
      case ViewAllStatus.trendingHits:
        return generateSongImageUrl(pro.trendingHitsModel.records[0].albumName,
            pro.trendingHitsModel.records[0].albumId);
      case ViewAllStatus.album:
        return generateSongImageUrl(
          pro.albumSongListModel.records[0].albumName,
          pro.albumSongListModel.records[0].albumId,
        );
      case ViewAllStatus.aura:
      default:
        return "https://images.unsplash.com/photo-1499415479124-43c32433a620?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1032&q=80";
    }
  }

  int getSongCount(ViewAllStatus viewAllStatus) {
    switch (viewAllStatus) {
      case ViewAllStatus.newRelease:
        return context.read<ViewAllProvider>().newReleaseModel.records.length;
      case ViewAllStatus.recentlyPlayed:
        return context.read<ViewAllProvider>().recentlyPlayed.records.length;
      case ViewAllStatus.trendingHits:
        return context.read<ViewAllProvider>().trendingHitsModel.records.length;
      case ViewAllStatus.album:
        return context
            .read<ViewAllProvider>()
            .albumSongListModel
            .records
            .length;
      case ViewAllStatus.aura:
        return context.read<ViewAllProvider>().auraSongListModel.records.length;
      default:
        return 0;
    }
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
              body: Consumer<PlayListProvider>(builder: (context, pro, _) {
                return pro.isLoad
                    ? Center(child: CircularProgressIndicator())
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
                                    title: pro.playListName,
                                    songCounts: pro.noOfSongs,
                                    callback: () {},
                                    imageUrl:
                                        "https://images.unsplash.com/photo-1499415479124-43c32433a620?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1032&q=80",
                                    addToQueue: () {
                                      print("object");
                                    }),
                                // AlbumInfo(infoBoxHeight: infoBoxHeight),
                                // AlbumSongsList(
                                //   status: "",
                                //   newReleaseModel: pro.newReleaseModel,
                                //   recentlyPlayed: pro.recentlyPlayed,
                                //   trendingHitsModel: pro.trendingHitsModel,
                                //   albumSongListModel: pro.albumSongListModel,
                                //   auraSongListModel: pro.auraSongListModel,
                                // ),
                              ],
                            ),
                          ],
                        ),
                      );
              }),
            ),
    );
  }
}
