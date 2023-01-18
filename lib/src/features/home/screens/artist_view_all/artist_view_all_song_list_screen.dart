import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:musiq/src/common_widgets/loader.dart';
import 'package:musiq/src/constants/color.dart';
import 'package:musiq/src/features/home/domain/model/artist_view_all_model.dart';
import 'package:musiq/src/features/player/screen/player_screen.dart';
import 'package:provider/provider.dart';

import '../../../view_all/widgets/sliver_app_bar.dart';
import '../../provider/artist_view_all_provider.dart';
import 'album_songs_list.dart';

class ArtistViewAllSongListScreen extends StatefulWidget {
  const ArtistViewAllSongListScreen(
      {super.key, required this.artistViewAllModel});
  final ArtistViewAllModel artistViewAllModel;

  @override
  State<ArtistViewAllSongListScreen> createState() =>
      _ViewAllSongListScreenState();
}

class _ViewAllSongListScreenState extends State<ArtistViewAllSongListScreen> {
  late ScrollController scrollController;

  late double maxAppBarHeight;
  late double minAppBarHeight;
  late double playPauseButtonSize;
  late double infoBoxHeight;
  @override
  void initState() {
    scrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var provider = Provider.of<ArtistViewAllProvider>(context, listen: false);
      provider.getSpecificArtistSongList(widget.artistViewAllModel.id);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    maxAppBarHeight = MediaQuery.of(context).size.height * 0.5;
    minAppBarHeight = MediaQuery.of(context).padding.top +
        MediaQuery.of(context).size.height * 0.05;
    playPauseButtonSize = (MediaQuery.of(context).size.width / 320) * 50 > 80
        ? 80
        : (MediaQuery.of(context).size.width / 320) * 50;
    infoBoxHeight = 180;
    return SafeArea(
      child: Scaffold(
        body: Consumer<ArtistViewAllProvider>(builder: (context, pro, _) {
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
                          SliverCustomeAppBar(
                            title: widget.artistViewAllModel.artistName,
                            maxAppBarHeight: maxAppBarHeight,
                            minAppBarHeight: minAppBarHeight,
                            artistViewAllModel: widget.artistViewAllModel,
                            songCount: int.parse(pro
                                .collectionViewAllModel.totalrecords
                                .toString()),
                          ),
                          const AlbumSongsList(),
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
