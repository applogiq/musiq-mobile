import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:musiq/src/common_widgets/container/custom_color_container.dart';
import 'package:musiq/src/common_widgets/loader.dart';
import 'package:musiq/src/constants/color.dart';
import 'package:musiq/src/constants/style.dart';
// import 'package:musiq/src/common_widgets/loader.dart';
import 'package:musiq/src/features/common/screen/offline_screen.dart';
import 'package:musiq/src/features/home/provider/view_all_provider.dart';
import 'package:musiq/src/features/home/screens/artist_view_all/album_info.dart';
import 'package:musiq/src/features/home/screens/sliver_app_bar/widgets/sliver_app_bar.dart';
import 'package:musiq/src/features/home/view_all_status.dart';
import 'package:musiq/src/features/library/domain/models/playlist_model.dart';
import 'package:musiq/src/features/library/provider/play_list_provider.dart';
import 'package:musiq/src/features/library/screens/playlist/no_playlist_song_screen.dart';
import 'package:musiq/src/features/library/widgets/playlist_tile.dart';
import 'package:musiq/src/utils/image_url_generate.dart';
import 'package:provider/provider.dart';

import 'widgets/album_song_list.dart';

class ViewSongScreen extends StatefulWidget {
  final String albumId;
  final String albumName;
  final String songId;
  final String playListName;
  const ViewSongScreen({
    super.key,
    required this.albumId,
    required this.albumName,
    required this.songId,
    required this.playListName,
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
      var playListDetails =
          Provider.of<PlayListProvider>(context, listen: false)
              .getPlayListDetails(widget.songId);
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
                    ? LoaderScreen()
                    // :
                    //  pro.noOfSongs == 0
                    //     ? Center(
                    //         child: Text("No Data"),
                    //       )
                    : pro.isNoSong
                        ? NoPlaylistSong(
                            appBarTitle: widget.playListName, playListId: "")
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
                                        imageUrl: generateSongImageUrl(
                                            widget.albumName, widget.albumId),
                                        addToQueue: () {
                                          print("object");
                                        }),
                                    SliverList(
                                      delegate: SliverChildListDelegate(
                                          List.generate(pro.noOfSongs, (index) {
                                        var playList =
                                            pro.playListModel.records;
                                        return SongListTile(
                                            imageUrl: generateSongImageUrl(
                                                playList[index].albumName,
                                                playList[index].albumId),
                                            songName: playList[index]
                                                .albumName
                                                .toString(),
                                            musicDirectorName: playList[index]
                                                .musicDirectorName
                                                .toString(),
                                            songId: int.parse(playList[index]
                                                .playlistSongs!
                                                .songId
                                                .toString()),
                                            albumName: playList[index]
                                                .albumName
                                                .toString());
                                      })),
                                    )
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

class SongListTile extends StatelessWidget {
  const SongListTile({
    super.key,
    required this.imageUrl,
    required this.songName,
    required this.musicDirectorName,
    required this.songId,
    required this.albumName,
  });
  final String imageUrl;
  final String songName;
  final String albumName;
  final String musicDirectorName;
  final int songId;
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
        decoration: const BoxDecoration(
          color: Colors.black,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: CustomColorContainer(
                  child: Image.network(
                    imageUrl,
                    height: 70,
                    width: 70,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Expanded(
                  flex: 8,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          songName,
                          style: fontWeight400(),
                        ),
                        Text(
                          musicDirectorName,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: fontWeight400(
                              size: 12.0, color: CustomColor.subTitle),
                        ),
                      ],
                    ),
                  )),
              Expanded(
                  child: PopupMenuButton<int>(
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
                  //
                },
                itemBuilder: (BuildContext context) {
                  return [
                    const PopupMenuItem(
                      value: 1,
                      child: Text('Add to Favourites'),
                    ),
                    const PopupMenuItem(
                      value: 2,
                      child: Text('Add to Playlist'),
                    ),
                    const PopupMenuItem(
                      value: 5,
                      child: Text('Add to Queue'),
                    ),
                    const PopupMenuItem(
                      value: 3,
                      child: Text('Play next'),
                    ),
                    const PopupMenuItem(
                      value: 4,
                      child: Text('Song info'),
                    ),
                  ];
                },
              ))
            ],
          ),
        ));
  }
}
