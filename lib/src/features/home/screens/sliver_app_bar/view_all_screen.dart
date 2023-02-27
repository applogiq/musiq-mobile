import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';

import '../../../../common_widgets/loader.dart';
import '../../../../core/constants/color.dart';
import '../../../../core/enums/enums.dart';
import '../../../../core/utils/url_generate.dart';
import '../../../common/screen/offline_screen.dart';
import '../../../payment/screen/subscription_screen.dart';
import '../../provider/view_all_provider.dart';
import 'widgets/album_song_list.dart';
import 'widgets/sliver_app_bar.dart';

class ViewAllScreen extends StatefulWidget {
  const ViewAllScreen(
      {super.key,
      required this.status,
      this.id,
      this.auraId,
      this.title,
      this.isImage = true,
      this.isPremium = false});
  final ViewAllStatus status;
  final int? id;
  final String? auraId;
  final String? title;
  final bool isImage;
  final bool isPremium;

  @override
  State<ViewAllScreen> createState() => _ViewAllScreenState();
}

class _ViewAllScreenState extends State<ViewAllScreen> {
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
      var provider = Provider.of<ViewAllProvider>(context, listen: false);
      provider.getViewAll(widget.status, id: widget.id);
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
      case ViewAllStatus.artist:
        return widget.title;
      case ViewAllStatus.aura:
        return widget.title;
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
        return generateAuraImageUrl(widget.auraId);
      case ViewAllStatus.artist:
        if (widget.isImage) {
          return generateArtistImageUrl(widget.auraId);
        } else {
          return "";
        }
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
      case ViewAllStatus.artist:
        return context
            .read<ViewAllProvider>()
            .collectionViewAllModel
            .records
            .length;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    maxAppBarHeight = MediaQuery.of(context).size.height * 0.5;
    minAppBarHeight = MediaQuery.of(context).padding.top +
        MediaQuery.of(context).size.height * 0.08;
    // double width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Provider.of<InternetConnectionStatus>(context) ==
              InternetConnectionStatus.disconnected
          ? const OfflineScreen()
          : Scaffold(
              body: Consumer<ViewAllProvider>(
                builder: (context, pro, _) {
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
                                  SliverCustomAppBar(
                                      isPremium: widget.isPremium,
                                      popUpMenu: PopupMenuButton(
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
                                        onSelected: (value) {
                                          if (widget.isPremium) {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const SubscriptionsScreen()));
                                          } else {
                                            context
                                                .read<ViewAllProvider>()
                                                .addQueue(
                                                    widget.status, context);
                                          }
                                        },
                                        itemBuilder: (ctx) => [
                                          const PopupMenuItem(
                                            value: 1,
                                            child: Text('Add to Queue'),
                                          ),
                                        ],
                                      ),
                                      maxAppBarHeight: maxAppBarHeight,
                                      minAppBarHeight: minAppBarHeight,
                                      title: getTitle(widget.status),
                                      songCounts: getSongCount(widget.status),
                                      callback: () {
                                        context
                                            .read<ViewAllProvider>()
                                            .navigateToPlayerScreen(
                                                context, widget.status);
                                      },
                                      imageUrl: getImageUrl(widget.status, pro),
                                      addToQueue: () {}),
                                  AlbumSongsList(
                                    isPremium: widget.isPremium,
                                    status: widget.status,
                                    newReleaseModel: pro.newReleaseModel,
                                    recentlyPlayed: pro.recentlyPlayed,
                                    trendingHitsModel: pro.trendingHitsModel,
                                    albumSongListModel: pro.albumSongListModel,
                                    auraSongListModel: pro.auraSongListModel,
                                    collectionViewAllModel:
                                        pro.collectionViewAllModel,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                },
              ),
            ),
    );
  }
}
