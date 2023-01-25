import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:musiq/src/common_widgets/box/vertical_box.dart';
import 'package:musiq/src/common_widgets/loader.dart';
import 'package:musiq/src/features/common/screen/offline_screen.dart';
import 'package:musiq/src/features/home/domain/model/song_list_model.dart';
import 'package:musiq/src/features/home/provider/home_provider.dart';
import 'package:musiq/src/features/home/view_all_status.dart';
import 'package:musiq/src/features/home/widgets/current_mood.dart';
import 'package:musiq/src/features/home/widgets/top_album_list.dart';
import 'package:musiq/src/features/home/widgets/trending_hits.dart';
import 'package:musiq/src/routing/route_name.dart';
import 'package:musiq/src/utils/navigation.dart';
import 'package:musiq/src/utils/size_config.dart';
import 'package:provider/provider.dart';

import '../../../common_widgets/container/custom_color_container.dart';
import '../../../constants/api.dart';
import '../../../constants/color.dart';
import '../widgets/artist_list_view.dart';
import '../widgets/search_notifications.dart';

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
    return
        // Provider.of<InternetConnectionStatus>(context) ==
        //         InternetConnectionStatus.disconnected
        //     ? const OfflineScreen()
        //:
        Consumer<HomeProvider>(builder: (context, pro, _) {
      return SizedBox(
        child: pro.isLoad
            ? const LoaderScreen()
            : ListView(
                shrinkWrap: true,
                children: [
                  const VerticalBox(height: 8),
                  const SearchAndNotifications(),
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
                  ArtistListView(artist: pro.artistModel),
                  HomeScreenSongList(
                    title: "New Releases",
                    isViewAll: true,
                    songList: pro.newReleaseListModel,
                  ),
                  CurrentMood(auraModel: pro.auraListModel),
                  TopAlbum(album: pro.albumListModel),
                  const SizedBox(
                    height: 60,
                  )
                ],
              ),
      );
    });
  }
}

class HomeScreenSongList extends StatelessWidget {
  const HomeScreenSongList(
      {super.key,
      required this.title,
      required this.isViewAll,
      required this.songList});

  final String title;
  final bool isViewAll;
  final List<SongListModel> songList;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Text(
                title,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              !isViewAll
                  ? const SizedBox.shrink()
                  : InkWell(
                      onTap: () {
                        Navigation.navigateToScreen(
                            context, RouteName.viewAllScreen,
                            args: title == "New Releases"
                                ? ViewAllStatus.newRelease
                                : ViewAllStatus.recentlyPlayed);
                      },
//                                       onTap: () async {
//                                         // print(recentlyPlayed.records[index].id);

//                                         recentlyPlayed =
//                                             await apiRoute.getRecentlyPlayed();
//                                         // print(songList.records.length);
//                                         List<ViewAllSongList>
//                                             viewAllSongListModel = [];
//                                         for (int i = 0;
//                                             i < recentlyPlayed.records.length;
//                                             i++) {
//                                           viewAllSongListModel.add(
//                                               ViewAllSongList(
//                                                   recentlyPlayed
//                                                       .records[i][0].id
//                                                       .toString(),
//                                                   generateSongImageUrl(
//                                                       recentlyPlayed
//                                                           .records[i][0]
//                                                           .albumName,
//                                                       recentlyPlayed
//                                                           .records[i][0]
//                                                           .albumId),
//                                                   recentlyPlayed
//                                                       .records[i][0].songName,
//                                                   recentlyPlayed.records[i][0]
//                                                       .musicDirectorName[0],
//                                                   recentlyPlayed
//                                                       .records[i][0].albumName,
//                                                   recentlyPlayed
//                                                       .records[i][0].albumId));
//                                         }
//                                         ViewAllBanner banner = ViewAllBanner(
//                                           bannerId: recentlyPlayed
//                                               .records[0][0].albumId,
//                                           bannerImageUrl:
//                                               "${APIConstants.SONG_BASE_URL}public/music/tamil/${recentlyPlayed.records[0][0].albumName[0].toUpperCase()}/${recentlyPlayed.records[0][0].albumName}/image/${recentlyPlayed.records[0][0].albumId.toString()}.png",
//                                           bannerTitle: "Recently Played",
//                                         );

//                                         Navigator.of(context).push(MaterialPageRoute(
//                                             builder: (context) =>
//                                                 ViewAllScreenSongList(
//                                                     banner: banner,
//                                                     view_all_song_list_model:
//                                                         viewAllSongListModel)));

// //             Navigator.of(context).push(MaterialPageRoute(
// //                 builder: (context) =>  RecentlyPlayedViewAll(songList: recentlyPlayed, title: 'Recently Played',
// //                 imageURL:
// //                   "${APIConstants.SONG_BASE_URL}public/music/tamil/${recentlyPlayed.records[recentlyPlayed.records.length-1].albumName[0].toUpperCase()}/${recentlyPlayed.records[recentlyPlayed.records.length-1].albumName}/image/${recentlyPlayed.records[recentlyPlayed.records.length-1].albumId.toString()}.png",
// // )));
//                                       },

                      child: Text(
                        "View All",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: CustomColor.secondaryColor),
                      ),
                    )
            ],
          ),
        ),
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(top: 8),
          height: 200,
          child: ListView.builder(

              // reverse: true,

              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: songList.length,
              itemBuilder: (context, index) => Row(
                    children: [
                      index == 0
                          ? const SizedBox(
                              width: 10,
                            )
                          : const SizedBox(),
                      InkWell(
                        onTap: () {
                          // Navigator.of(context).push(MaterialPageRoute(
                          //     builder: (context) => const PlayerScreen()));
                          print(
                              "${APIConstants.baseUrl}public/music/tamil/${songList[index].albumName[0].toUpperCase()}/${songList[index].albumName}/image/${songList[index].albumId.toString()}.png");
                        },
                        // onTap: () {
                        //   List<PlayScreenModel>
                        //       playScreenModel = [];
                        //   print(recentlyPlayed
                        //       .records[index][0].id);
                        //   for (int i = 0;
                        //       i <
                        //           recentlyPlayed
                        //               .records.length;
                        //       i++) {
                        //     playScreenModel.add(PlayScreenModel(
                        //         id: recentlyPlayed
                        //             .records[i][0].id,
                        //         songName: recentlyPlayed
                        //             .records[i][0]
                        //             .songName,
                        //         musicDirectorName:
                        //             recentlyPlayed
                        //                     .records[i][0]
                        //                     .musicDirectorName[
                        //                 0],
                        //         albumId: recentlyPlayed
                        //             .records[i][0]
                        //             .albumId,
                        //         albumName: recentlyPlayed
                        //             .records[i][0]
                        //             .albumName));
                        //   }
                        //   print(playScreenModel.length);
                        //   Navigator.of(context).push(
                        //       MaterialPageRoute(
                        //           builder: (context) =>
                        //               MainPlayScreen(
                        //                   playScreenModel:
                        //                       playScreenModel,
                        //                   index: index)));
                        // },

                        child: Container(
                          padding: const EdgeInsets.fromLTRB(6, 8, 6, 0),
                          width: 135,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomColorContainer(
                                child: Image.network(
                                  "${APIConstants.baseUrl}public/music/tamil/${songList[index].albumName[0].toUpperCase()}/${songList[index].albumName}/image/${songList[index].albumId.toString()}.png",
                                  height: 125,
                                  width: 135,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(
                                height: 6,
                              ),
                              Text(
                                songList[index].songName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w400, fontSize: 12),
                              ),
                              const SizedBox(
                                height: 2,
                              ),
                              // Text(
                              //     "${songList[index][0].albumName}-${songList[index][0].musicDirectorName[0]}",
                              //     maxLines: 1,
                              //     overflow: TextOverflow.ellipsis,
                              //     style: TextStyle(
                              //         fontWeight: FontWeight.w400,
                              //         fontSize: 12,
                              //         color: CustomColor.subTitle))
                            ],
                          ),
                        ),
                      ),
                    ],
                  )),
        ),
      ],
    );
  }
}
