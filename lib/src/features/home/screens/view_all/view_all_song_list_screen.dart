import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../common_widgets/loader.dart';
import '../../../../core/enums/enums.dart';
import '../../../view_all/widgets/sliver_song/sliver_app_bar.dart';
import '../../provider/view_all_provider.dart';
import '../artist_view_all/album_songs_list.dart';

class ViewAllSongListScreen extends StatefulWidget {
  const ViewAllSongListScreen({super.key, required this.status});
  final ViewAllStatus status;

  @override
  State<ViewAllSongListScreen> createState() => _ViewAllSongListScreenState();
}

class _ViewAllSongListScreenState extends State<ViewAllSongListScreen> {
  late ScrollController scrollController;

  late double maxAppBarHeight;
  late double minAppBarHeight;
  late double playPauseButtonSize;
  late double infoBoxHeight;
  @override
  void initState() {
    scrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var provider = Provider.of<ViewAllProvider>(context, listen: false);
      provider.getViewAll(widget.status);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    maxAppBarHeight = MediaQuery.of(context).size.height * 0.5;
    minAppBarHeight = MediaQuery.of(context).padding.top +
        MediaQuery.of(context).size.height * 0.06;
    playPauseButtonSize = (MediaQuery.of(context).size.width / 320) * 50 > 80
        ? 80
        : (MediaQuery.of(context).size.width / 320) * 50;
    infoBoxHeight = 180;
    return Scaffold(
      backgroundColor: const Color.fromRGBO(22, 21, 28, 1),
      body: Consumer<ViewAllProvider>(builder: (context, pro, _) {
        return pro.isLoad
            ? const LoaderScreen()
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
                        SliverCustomAppBarSong(
                          title: widget.status == ViewAllStatus.recentlyPlayed
                              ? "Recently Plfeferferfayed"
                              : "fdf",
                          maxAppBarHeight: maxAppBarHeight,
                          minAppBarHeight: minAppBarHeight,
                          artistViewAllModel: pro.trendingHitsModel,
                          songCount: int.parse(
                              pro.trendingHitsModel.records.length.toString()),
                        ),
                        const AlbumSongsList(),
                      ],
                    ),
                  ],
                ),
              );
      }),
    );
  }
}
