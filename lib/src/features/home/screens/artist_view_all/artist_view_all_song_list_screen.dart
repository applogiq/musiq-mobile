import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:musiq/src/constants/color.dart';
import 'package:musiq/src/features/home/domain/model/artist_view_all_model.dart';
import 'package:musiq/src/features/player/screen/player_screen.dart';
import 'package:provider/provider.dart';

import '../../../../common_widgets/buttons/custom_button.dart';
import '../../../../constants/style.dart';
import '../../provider/artist_view_all_provider.dart';
import 'album_songs_list.dart';
import 'custom_flexible_space.dart';

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
        body: DecoratedBox(
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
                  ),
                  // AlbumInfo(infoBoxHeight: infoBoxHeight),
                  const AlbumSongsList(),
                ],
              ),
              // PlayPauseButton(
              //   scrollController: scrollController,
              //   maxAppBarHeight: maxAppBarHeight,
              //   minAppBarHeight: minAppBarHeight,
              //   playPauseButtonSize: playPauseButtonSize,
              //   infoBoxHeight: infoBoxHeight,
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class GradientCover extends StatelessWidget {
  const GradientCover({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            tileMode: TileMode.decal,
            begin: Alignment.topCenter,
            end: Alignment(0.0, 1),
            stops: [
              0.1,
              0.9,
            ],
            colors: [
              Color.fromRGBO(22, 21, 28, 0),
              Color.fromRGBO(22, 21, 28, 1),
            ]),
      ),
    );
  }
}

class SliverCustomeAppBar extends StatelessWidget {
  const SliverCustomeAppBar({
    Key? key,
    required this.maxAppBarHeight,
    required this.minAppBarHeight,
    required this.title,
    required this.artistViewAllModel,
  }) : super(key: key);

  final double maxAppBarHeight;
  final double minAppBarHeight;
  final String title;
  final ArtistViewAllModel artistViewAllModel;

  @override
  Widget build(BuildContext context) {
    final extraTopPadding = MediaQuery.of(context).size.height * 0.03;
    //app bar content padding
    final padding = EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + extraTopPadding,
        right: 10,
        left: 10);

    return SliverPersistentHeader(
        pinned: true,
        delegate: SliverAppBarDelegate(
            maxHeight: maxAppBarHeight,
            minHeight: minAppBarHeight,
            builder: (context, shrinkOffset) {
              final appBarVisible =
                  shrinkOffset >= (maxAppBarHeight - minAppBarHeight);
              print(appBarVisible);
              final double shrinkToMaxAppBarHeightRatio =
                  shrinkOffset / maxAppBarHeight;
              const double animatAlbumImageFromPoint = 0.2;
              final animateAlbumImage =
                  shrinkToMaxAppBarHeightRatio >= animatAlbumImageFromPoint;
              final animateOpacityToZero = shrinkToMaxAppBarHeightRatio > 0.7;
              final albumPositionFromTop = animateAlbumImage
                  ? (animatAlbumImageFromPoint - shrinkToMaxAppBarHeightRatio) *
                      maxAppBarHeight
                  : null;
              final albumImageSize = MediaQuery.of(context).size.height * 0.45 -
                  shrinkOffset / 1.5;
              final showFixedAppBar = shrinkToMaxAppBarHeightRatio > 0.8;
              final double titleOpacity = showFixedAppBar
                  ? 1 - (maxAppBarHeight - shrinkOffset) / minAppBarHeight
                  : 0;

              return Stack(
                alignment: Alignment.topCenter,
                children: [
                  Positioned(
                    top: albumPositionFromTop,
                    child: AlbumImage(
                      padding: EdgeInsets.only(top: extraTopPadding),
                      animateOpacityToZero: animateOpacityToZero,
                      animateAlbumImage: animateAlbumImage,
                      shrinkToMaxAppBarHeightRatio:
                          shrinkToMaxAppBarHeightRatio,
                      albumImageSize: albumImageSize,
                      id: artistViewAllModel.artistId,
                    ),
                  ),
                  const GradientCover(),
                  AppBarOverlayContent(
                    title: artistViewAllModel.artistName,
                    count: 20,
                    callback: () {},
                    size: shrinkToMaxAppBarHeightRatio,
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    decoration: BoxDecoration(
                      gradient: showFixedAppBar
                          ? const LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                  Colors.black,
                                  Colors.black,
                                ],
                              stops: [
                                  0,
                                  0.5
                                ])
                          : null,
                    ),
                    child: Padding(
                      padding: padding,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: double.maxFinite,
                        child: FixedAppBar(
                          titleOpacity: titleOpacity,
                          title: title,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }));
  }
}

class AppBarOverlayContent extends StatelessWidget {
  AppBarOverlayContent(
      {Key? key,
      required this.title,
      required this.count,
      required this.callback,
      required this.size})
      : super(key: key);

  final String title;
  final int count;
  VoidCallback callback;
  final double size;
  PopupMenuItem _buildPopupMenuItem(String title, String routeName) {
    return PopupMenuItem(
      onTap: () {
        if (routeName == "hide") {
          // setState(() {
          //   hideLyrics;
          // });
        } else {
          print(routeName);
        }
      },
      child: Text(title),
    );
  }

  @override
  Widget build(BuildContext context) {
    print("size");
    log(size.toString());
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Spacer(),
            AnimatedOpacity(
              opacity: (size - 1.0).abs(),
              duration: const Duration(milliseconds: 100),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: fontWeight600(
                        size: size < 0.3
                            ? 22.0
                            : size > 0.48
                                ? 0.0
                                : 18.0),
                  ),
                  size < 0.6
                      ? PopupMenuButton(
                          color: CustomColor.appBarColor,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(8.0),
                              bottomRight: Radius.circular(8.0),
                              topLeft: Radius.circular(8.0),
                              topRight: Radius.circular(8.0),
                            ),
                          ),
                          padding: const EdgeInsets.all(0.0),
                          itemBuilder: (ctx) => [
                                _buildPopupMenuItem('Add to queue', 'share'),
                                _buildPopupMenuItem(
                                    'Add to playlist', "song_info"),
                              ])
                      : const SizedBox.shrink()
                ],
              ),
            ),
            Text(
              "$count Songs",
              //  "",
              style: fontWeight400(
                size: size < 0.3
                    ? 22.0
                    : size > 0.48
                        ? 0.0
                        : 18.0,
                color: CustomColor.subTitle2,
              ),
            ),
            AnimatedOpacity(
              opacity: (size - 1.0).abs(),
              duration: const Duration(milliseconds: 100),
              child: Padding(
                padding: const EdgeInsets.only(top: 24),
                child: InkWell(
                  onTap: () {
                    print(size);
                    //                             var songPlayList=[];
                    // for(int i=0;i<songList.totalrecords;i++){

                    //   songPlayList.add(songList.records[i].id);
                    // }
                    // // print(index);
                    // Navigator.of(context).push(MaterialPageRoute(
                    //     builder: (context) => PlayScreen(
                    //       songList: songList,
                    //       index: 0,
                    //       id:songList.records[0].id.toString(),
                    //           imageURL:  "${APIConstants.SONG_BASE_URL}public/music/tamil/${songList.records[0].albumDetails.name[0].toUpperCase()}/${songList.records[0].albumDetails.name}/image/${songList.records[0].albumDetails.albumId}.png",
                    //           songName: songList.records[0].name,
                    //           artistName: songList.records[0].albumDetails.musicDirectorName[0].toString(),
                    //           songplayList: songPlayList,
                    //         )));
                  },
                  child: InkWell(
                    onTap: () {
                      print(size.toString());
                    },
                    child: CustomButton(
                        isIcon: true,
                        label: "Play All",
                        horizontalMargin: 0.0,
                        height: size < 0.3
                            ? 52
                            : size < 0.4
                                ? 48
                                : size < 0.6
                                    ? 38
                                    : size < 0.65
                                        ? 36
                                        : 0,
                        verticalMargin: 0.0),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

typedef _SliverAppBarDelegateBuilder = Widget Function(
  BuildContext context,
  double shrinkOffset,
);

class SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.builder,
  });
  final double minHeight;
  final double maxHeight;
  final _SliverAppBarDelegateBuilder builder;
  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => math.max(maxHeight, minHeight);
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(
      child: builder(context, shrinkOffset),
    );
  }

  @override
  bool shouldRebuild(SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        builder != oldDelegate.builder;
  }
}

class FixedAppBar extends StatelessWidget {
  const FixedAppBar({
    Key? key,
    required this.titleOpacity,
    required this.title,
  }) : super(key: key);

  final double titleOpacity;
  final String title;

  @override
  Widget build(BuildContext context) {
    log(titleOpacity.toString());
    return titleOpacity < 0.5
        ? Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Padding(
                padding: EdgeInsets.only(top: 16.0),
                child: Icon(
                  Icons.arrow_back_ios_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ],
          )
        : AnimatedOpacity(
            opacity: titleOpacity.clamp(0, 1),
            duration: const Duration(milliseconds: 100),
            child: ColoredBox(
              color: Colors.black,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 0.0),
                    child: Icon(
                      Icons.arrow_back_ios_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                  // Text("Trending hits"), Spacer(),

                  const SizedBox(width: 10),

                  Expanded(
                    child: AnimatedOpacity(
                      opacity: titleOpacity.clamp(0, 1),
                      duration: const Duration(milliseconds: 100),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 0.0),
                        child: Text(title,
                            maxLines: 1,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                            )),
                      ),
                    ),
                  ),
                  // const Spacer(),
                  PlayButtonWidget(
                    bgColor: CustomColor.secondaryColor,
                    iconColor: CustomColor.playIconBg,
                  ),
                  AnimatedOpacity(
                    opacity: titleOpacity.clamp(0, 1),
                    duration: const Duration(milliseconds: 100),
                    child: const Padding(
                        padding: EdgeInsets.only(bottom: 0.0),
                        child: Icon(Icons.more_vert)),
                  ),
                ],
              ),
            ),
          );
  }
}
