import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common_widgets/box/vertical_box.dart';
import '../../../common_widgets/loader.dart';
import '../../../core/enums/enums.dart';
import '../../../core/utils/size_config.dart';
import '../provider/home_provider.dart';
import '../widgets/artist_list_view.dart';
import '../widgets/current_mood.dart';
import '../widgets/home_screen_song_list.dart';
import '../widgets/search_notifications.dart';
import '../widgets/top_album_list.dart';
import '../widgets/trending_hits.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      context.read<HomeProvider>().getSongData();
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Consumer<HomeProvider>(builder: (context, pro, _) {
      return SizedBox(
        child: pro.isLoad
            ? const LoaderScreen()
            : ListView(
                shrinkWrap: true,
                children: [
                  const VerticalBox(height: 8),
                  const SearchAndNotifications(
                    searchStatus: SearchStatus.song,
                  ),
                  pro.recentlyPlayed.success == false
                      ? const SizedBox.shrink()
                      : Consumer<HomeProvider>(
                          builder: (context, homeProvider, _) {
                          return homeProvider.isRecentlyPlayedLoad
                              ? const LoaderScreen()
                              : HomeScreenSongList(
                                  title: "Recently Played",
                                  isViewAll: true,
                                  songList: homeProvider.recentSongListModel,
                                );
                        }),
                  TrendingHitsWidget(
                    trendingHitsModel: pro.trendingHitsModel,
                  ),
                  ArtistListView(artist: pro.artistModel),
                  HomeScreenSongList(
                    title: "New Releases",
                    isViewAll: true,
                    songList: pro.newReleaseListModel,
                  ),
                  CurrentMood(auraModel: pro.auraListModel),
                  TopAlbum(album: pro.albumListModel),
                ],
              ),
      );
    });
  }
}
