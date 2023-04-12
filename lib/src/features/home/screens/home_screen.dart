import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:musiq/src/common_widgets/box/vertical_box.dart';
import 'package:musiq/src/core/enums/enums.dart';
import 'package:musiq/src/features/home/widgets/search_notifications.dart';
import 'package:provider/provider.dart';

import '../../../common_widgets/loader.dart';
import '../../../core/utils/size_config.dart';
import '../provider/home_provider.dart';
import '../widgets/artist_list_view.dart';
import '../widgets/home_screen_song_list.dart';
import '../widgets/top_album_list.dart';
import '../widgets/trending_hits.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  List pages = [];
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      context.read<HomeProvider>().getSongData();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    log(_scrollController.offset.toString());
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        pages;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Consumer<HomeProvider>(
      builder: (context, pro, _) {
        pages = [
          const VerticalBox(height: 8),
          const SearchAndNotifications(
            searchStatus: SearchStatus.song,
          ),
          const VerticalBox(height: 8),

          pro.recentlyPlayed.success == false
              ? const SizedBox.shrink()
              : HomeScreenSongList(
                  title: "Recently Played",
                  isViewAll: true,
                  songList: pro.recentSongListModel,
                ),
          TrendingHitsWidget(
            trendingHitsModel: pro.trendingHitsModel,
          ),
          ArtistListView(artist: pro.preferableartistmodel),
          HomeScreenSongList(
            title: "New Releases",
            isViewAll: true,
            songList: pro.newReleaseListModel,
          ),
          // CurrentMood(auraModel: pro.auraListModel),
          TopAlbum(album: pro.albumListModel),
          const SizedBox(
            height: 24,
          )
        ];

        return SizedBox(
            child: pro.isLoad
                ? const LoaderScreen()
                : ListView.builder(
                    itemCount: pages.length,
                    controller: ScrollController(),
                    itemBuilder: (context, index) {
                      if (index == pages.length) {
                        return const Center(child: CircularProgressIndicator());
                      } else {
                        return pages[index];
                      }
                    })
            // : ListView(
            //     shrinkWrap: true,
            //     children: [
            //       const VerticalBox(height: 8),
            //       const SearchAndNotifications(
            //         searchStatus: SearchStatus.song,
            //       ),
            //       pro.recentlyPlayed.success == false
            //           ? const SizedBox.shrink()
            //           : HomeScreenSongList(
            //               title: "Recently Played",
            //               isViewAll: true,
            //               songList: pro.recentSongListModel,
            //             ),
            //       TrendingHitsWidget(
            //         trendingHitsModel: pro.trendingHitsModel,
            //       ),
            //       ArtistListView(artist: pro.artistModel),
            //       HomeScreenSongList(
            //         title: "New Releases",
            //         isViewAll: true,
            //         songList: pro.newReleaseListModel,
            //       ),
            //       CurrentMood(auraModel: pro.auraListModel),
            //       TopAlbum(album: pro.albumListModel),
            //       const SizedBox(
            //         height: 24,
            //       )
            //     ],
            //   ),
            );
      },
    );
  }
}
