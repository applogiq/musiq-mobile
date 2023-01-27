import 'package:flutter/material.dart';
import 'package:musiq/src/common_widgets/box/vertical_box.dart';
import 'package:musiq/src/common_widgets/loader.dart';
import 'package:musiq/src/features/home/domain/model/song_list_model.dart';
import 'package:musiq/src/features/home/provider/home_provider.dart';
import 'package:musiq/src/features/home/screens/sliver_app_bar/view_all_screen.dart';
import 'package:musiq/src/features/home/widgets/current_mood.dart';
import 'package:musiq/src/features/home/widgets/top_album_list.dart';
import 'package:musiq/src/features/home/widgets/trending_hits.dart';
import 'package:musiq/src/utils/size_config.dart';
import 'package:provider/provider.dart';

import '../../../common_widgets/container/custom_color_container.dart';
import '../../../constants/api.dart';
import '../../../constants/color.dart';
import '../provider/view_all_provider.dart';
import '../view_all_status.dart';
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
    return Consumer<HomeProvider>(builder: (context, pro, _) {
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
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ViewAllScreen(
                                  status: title == "New Releases"
                                      ? ViewAllStatus.newRelease
                                      : ViewAllStatus.recentlyPlayed,
                                )));
                      },
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
                          context.read<ViewAllProvider>().getViewAll(
                              title == "New Releases"
                                  ? ViewAllStatus.newRelease
                                  : ViewAllStatus.recentlyPlayed,
                              context: context,
                              goToNextfunction: true,
                              index: index);
                        },
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
