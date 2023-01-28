import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:musiq/src/features/home/domain/model/trending_hits_model.dart';
import 'package:musiq/src/features/view_all/widgets/secondary_app_bar.dart';

import '../app_bar_overlay.dart';
import '../gradient_cover.dart';
import 'album_image.dart';

typedef SliverAppBarDelegateBuilder = Widget Function(
  BuildContext context,
  double shrinkOffset,
);

class SliverCustomAppBarSong extends StatelessWidget {
  const SliverCustomAppBarSong({
    Key? key,
    required this.maxAppBarHeight,
    required this.minAppBarHeight,
    required this.title,
    required this.artistViewAllModel,
    required this.songCount,
  }) : super(key: key);

  final double maxAppBarHeight;
  final double minAppBarHeight;
  final String title;
  final TrendingHitsModel artistViewAllModel;
  final int songCount;

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
              // final appBarVisible =
              //     shrinkOffset >= (maxAppBarHeight - minAppBarHeight);

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
                      id: "AR001",
                      isImage: true,
                      albumId: artistViewAllModel.records[0].albumId,
                      albumName: artistViewAllModel.records[0].albumName,
                      label: 'Recently Played',
                    ),
                  ),
                  const GradientCover(),
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
                          size: shrinkToMaxAppBarHeightRatio,
                          titleOpacity: titleOpacity,
                          title: title,
                        ),
                      ),
                    ),
                  ),
                  shrinkToMaxAppBarHeightRatio > 0.6
                      ? const SizedBox.shrink()
                      : AppBarOverlayContent(
                          title: title,
                          count: songCount,
                          callback: () {},
                          size: shrinkToMaxAppBarHeightRatio,
                        ),
                ],
              );
            }));
  }
}

class SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.builder,
  });
  final double minHeight;
  final double maxHeight;
  final SliverAppBarDelegateBuilder builder;
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
