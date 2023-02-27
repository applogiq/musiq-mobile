import 'package:flutter/material.dart';
import 'package:musiq/src/core/constants/images.dart';
import 'package:musiq/src/features/player/screen/add_playlist_screen.dart';
import 'package:musiq/src/features/player/screen/song_info_screen.dart';
import 'package:provider/provider.dart';

import '../../../../../common_widgets/container/custom_color_container.dart';
import '../../../../../core/constants/constant.dart';
import '../../../../payment/screen/subscription_screen.dart';
import '../../../../player/domain/model/player_song_list_model.dart';
import '../../../../player/provider/player_provider.dart';

class SongListTile extends StatelessWidget {
  const SongListTile({
    super.key,
    required this.imageUrl,
    required this.songName,
    required this.musicDirectorName,
    required this.songId,
    required this.albumName,
    required this.duration,
    required this.isPlay,
    this.isPremium = false,
  });

  final String albumName;
  final String imageUrl;
  final String musicDirectorName;
  final int songId;
  final bool isPlay;
  final String songName;
  final String duration;
  final bool isPremium;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: CustomColor.bg,
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
                      Row(
                        children: [
                          Text(
                            songName,
                            style: fontWeight400(
                                color: isPlay
                                    ? CustomColor.secondaryColor
                                    : Colors.white),
                          ),
                          isPremium
                              ? Image.asset(
                                  Images.crownImage,
                                  height: 18,
                                )
                              : const SizedBox.shrink()
                        ],
                      ),
                      Text(
                        musicDirectorName,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: fontWeight400(
                            size: 12.0,
                            color: isPlay
                                ? CustomColor.secondaryColor
                                : Colors.white),
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
                  switch (value) {
                    case 1:
                      if (isPremium) {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const SubscriptionsScreen()));
                      } else {
                        context.read<PlayerProvider>().addFavourite(songId);
                      }
                      break;

                    case 2:
                      if (isPremium) {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const SubscriptionsScreen()));
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    AddToPlaylistScreen(songId: songId)));
                      }

                      break;

                    case 3:
                      if (isPremium) {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const SubscriptionsScreen()));
                      } else {
                        PlayerSongListModel playerSongListModel =
                            PlayerSongListModel(
                                id: songId,
                                albumName: albumName,
                                title: songName,
                                imageUrl: imageUrl,
                                musicDirectorName: musicDirectorName,
                                duration: duration,
                                premium:
                                    isPremium != true ? "free" : "premium");
                        context
                            .read<PlayerProvider>()
                            .queuePlayNext(playerSongListModel);
                      }
                      break;
                    case 4:
                      if (isPremium) {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const SubscriptionsScreen()));
                      } else {
                        // PlayerSongListModel playerSongListModel =
                        //     PlayerSongListModel(
                        //         id: songId,
                        //         albumName: albumName,
                        //         title: songName,
                        //         imageUrl: imageUrl,
                        //         musicDirectorName: musicDirectorName,
                        //         duration: duration,
                        //         premium:
                        //             isPremium != true ? "free" : "premium");
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => SongInfoScreen(id: songId)));
                        // Navigation.navigateToScreen(context, RouteName.songInfo,
                        //     args: playerSongListModel);
                      }
                      break;
                    case 5:
                      if (isPremium) {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const SubscriptionsScreen()));
                      } else {
                        PlayerSongListModel playerSongListModel =
                            PlayerSongListModel(
                                id: songId,
                                albumName: albumName,
                                title: songName,
                                imageUrl: imageUrl,
                                musicDirectorName: musicDirectorName,
                                duration: duration,
                                premium:
                                    isPremium != true ? "free" : "premium");
                        // Navigation.navigateToScreen(context, RouteName.songInfo,
                        //     args: playerSongListModel);
                        context.read<PlayerProvider>().addQueueToLocalDb(
                              playerSongListModel,
                            );
                      }
                      break;
                  }
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
              ),
            )
          ],
        ),
      ),
    );
  }
}
