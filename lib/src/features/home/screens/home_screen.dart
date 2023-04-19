import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:musiq/src/common_widgets/box/vertical_box.dart';
import 'package:musiq/src/core/constants/constant.dart';
import 'package:musiq/src/core/enums/enums.dart';
import 'package:musiq/src/features/common/packages/shimmer/shimmer.dart';
import 'package:musiq/src/features/home/widgets/search_notifications.dart';
import 'package:provider/provider.dart';

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
  int _currentMaxIndex = 5;

  List<Widget> pages = [];
  bool _isLoading = false;

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
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange &&
        !_isLoading) {
      setState(() {
        _isLoading = true;
        if (_currentMaxIndex + 3 < pages.length) {
          _currentMaxIndex += 3;
        } else {
          _currentMaxIndex = pages.length - 1;
        }
        _isLoading = false;
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
          // pro.isRecentSongList
          //     ?
          pro.isRecentSongList
              ? pro.recentlyPlayed.success == false
                  ? const SizedBox.shrink()
                  : HomeScreenSongList(
                      title: "Recently Played",
                      isViewAll: true,
                      songList: pro.recentSongListModel,
                    )
              : recentlyPlayedLoader(context),

          pro.istrendingHitsSongList
              ? TrendingHitsWidget(
                  trendingHitsModel: pro.trendingHitsModel,
                )
              : trendingHitsLoad(context),

          pro.isartistList
              ? ArtistListView(artist: pro.preferableartistmodel)
              : artistLoader(context),

          pro.isnewRelease
              ? HomeScreenSongList(
                  title: "New Releases",
                  isViewAll: true,
                  songList: pro.newReleaseListModel,
                )
              : recentlyPlayedLoader(context),

          pro.isalbumList
              ? TopAlbum(album: pro.albumListModel)
              : recentlyPlayedLoader(context),

          const SizedBox(
            height: 24,
          )
        ];
        final displayedPages = pages.sublist(0, _currentMaxIndex + 1);

        return SizedBox(
            child: pro.isLoad
                ? homeScreenLoader(context)
                : ListView.builder(
                    itemCount: displayedPages.length,
                    controller: _scrollController,
                    itemBuilder: (context, index) {
                      if (index >= displayedPages.length) {
                        return const Text(
                            "data"); // or some other fallback widget
                      }
                      log(displayedPages.length.toString());
                      return displayedPages[index];
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

Shimmer homeScreenLoader(BuildContext context) {
  SizeConfig().init(context);

  return Shimmer.fromColors(
      baseColor: Colors.grey[600]!,
      highlightColor: const Color.fromRGBO(255, 255, 255, 0.1),
      child: ListView(
        scrollDirection: Axis.vertical,
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        children: [
          recentlyPlayedLoader(context),
          trendingHitsLoad(context),
          artistLoader(context),
          recentlyPlayedLoader(context),
          recentlyPlayedLoader(context),
        ],
      ));
}

Shimmer recentlyPlayedLoader(BuildContext context) {
  SizeConfig().init(context);

  return Shimmer.fromColors(
      baseColor: Colors.grey[600]!,
      highlightColor: const Color.fromRGBO(255, 255, 255, 0.1),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12, right: 12, top: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 16,
                  width: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: CustomColor.activeIconBgColor,
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(5, 31, 50, 0.08),
                        blurRadius: 15.0,
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 16,
                  width: 82,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: CustomColor.activeIconBgColor,
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(5, 31, 50, 0.08),
                        blurRadius: 15.0,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(top: 8),
            height: 120,
            child: ListView.builder(
              itemCount: 5,
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Container(
                    // padding: const EdgeInsets.only(left: 16, right: 16),
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: CustomColor.activeIconBgColor,
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(5, 31, 50, 0.08),
                          blurRadius: 15.0,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ));
}

Shimmer trendingHitsLoad(BuildContext context) {
  SizeConfig().init(context);

  return Shimmer.fromColors(
      baseColor: Colors.grey[600]!,
      highlightColor: const Color.fromRGBO(255, 255, 255, 0.1),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12, right: 12, top: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 16,
                  width: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: CustomColor.activeIconBgColor,
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(5, 31, 50, 0.08),
                        blurRadius: 15.0,
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 16,
                  width: 82,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: CustomColor.activeIconBgColor,
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(5, 31, 50, 0.08),
                        blurRadius: 15.0,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12, right: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  height: getProportionateScreenHeight(240),
                  width: getProportionateScreenWidth(200),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: CustomColor.activeIconBgColor,
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(5, 31, 50, 0.08),
                        blurRadius: 15.0,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: getProportionateScreenHeight(114),
                      width: getProportionateScreenWidth(120),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: CustomColor.activeIconBgColor,
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromRGBO(5, 31, 50, 0.08),
                            blurRadius: 15.0,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Container(
                      height: getProportionateScreenHeight(114),
                      width: getProportionateScreenWidth(120),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: CustomColor.activeIconBgColor,
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromRGBO(5, 31, 50, 0.08),
                            blurRadius: 15.0,
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ));
}

Shimmer artistLoader(BuildContext context) {
  SizeConfig().init(context);

  return Shimmer.fromColors(
      baseColor: Colors.grey[600]!,
      highlightColor: const Color.fromRGBO(255, 255, 255, 0.1),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12, right: 12, top: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 16,
                  width: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: CustomColor.activeIconBgColor,
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(5, 31, 50, 0.08),
                        blurRadius: 15.0,
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 16,
                  width: 82,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: CustomColor.activeIconBgColor,
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(5, 31, 50, 0.08),
                        blurRadius: 15.0,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  height: getProportionateScreenHeight(240),
                  width: getProportionateScreenWidth(170),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: CustomColor.activeIconBgColor,
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(5, 31, 50, 0.08),
                        blurRadius: 15.0,
                      ),
                    ],
                  ),
                ),
                Container(
                  height: getProportionateScreenHeight(240),
                  width: getProportionateScreenWidth(170),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: CustomColor.activeIconBgColor,
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(5, 31, 50, 0.08),
                        blurRadius: 15.0,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ));
}
