import 'package:flutter/material.dart';

import '../../../../view_all/widgets/gradient_cover.dart';
import '../../../../view_all/widgets/sliver_app_bar.dart';
import 'app_bar_overlay.dart';
import 'collapse_app_bar.dart';
import 'flexible_app_bar.dart';

class SliverCustomAppBar extends StatelessWidget {
  const SliverCustomAppBar({
    Key? key,
    required this.maxAppBarHeight,
    required this.minAppBarHeight,
    required this.title,
    required this.songCounts,
    required this.callback,
    required this.imageUrl,
    required this.addToQueue,
    required this.popUpMenu,
  }) : super(key: key);

  final double maxAppBarHeight;
  final double minAppBarHeight;
  final String title;
  final String imageUrl;
  final int songCounts;
  final Function callback;
  final Function addToQueue;
  final Widget popUpMenu;

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
              final showFixedAppBar = shrinkToMaxAppBarHeightRatio > 0.5;
              final double titleOpacity = showFixedAppBar
                  ? 1 - (maxAppBarHeight - shrinkOffset) / minAppBarHeight
                  : 0;

              return Stack(
                alignment: Alignment.topCenter,
                children: [
                  Positioned(
                    top: albumPositionFromTop,
                    child: ExpandedAppBar(
                      padding: EdgeInsets.only(top: extraTopPadding),
                      animateOpacityToZero: animateOpacityToZero,
                      animateAlbumImage: animateAlbumImage,
                      shrinkToMaxAppBarHeightRatio:
                          shrinkToMaxAppBarHeightRatio,
                      albumImageSize: albumImageSize,
                      imageUrl: imageUrl,
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
                        child: CollapsedAppBar(
                          titleOpacity: titleOpacity,
                          size: shrinkToMaxAppBarHeightRatio,
                          title: title,
                          popUpMenu: popUpMenu,
                          callBack: () {
                            callback();
                          },
                          addToQueue: () {
                            addToQueue();
                          },
                        ),
                      ),
                    ),
                  ),
                  shrinkToMaxAppBarHeightRatio > 0.6
                      ? const SizedBox.shrink()
                      : AppBarOverlayContent(
                          popUpMenu: popUpMenu,
                          title: title,
                          count: songCounts,
                          callback: () {
                            callback();
                          },
                          size: shrinkToMaxAppBarHeightRatio,
                          addQueue: () {
                            addToQueue();
                          },
                        ),
                ],
              );
            }));
  }
}
