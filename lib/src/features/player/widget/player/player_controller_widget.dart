import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../main.dart';
import '../../../../core/constants/constant.dart';
import '../../../../core/local/model/favourite_model.dart';
import '../../../../core/routing/route_name.dart';
import '../../../../core/utils/navigation.dart';
import '../../../home/provider/artist_view_all_provider.dart';
import '../../provider/player_provider.dart';
import 'player_widgets.dart';

class PlayerControllerWidget extends StatelessWidget {
  const PlayerControllerWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ArtistViewAllProvider>(
      builder: (context, pro, _) {
        return StreamBuilder<MediaItem?>(
            stream: context.read<PlayerProvider>().audioHandler!.mediaItem,
            builder: (context, snapshot) {
              MediaItem? mediaItem = snapshot.data;

              if (mediaItem == null) {
                return const SizedBox.shrink();
              }
              return Column(
                children: [
                  Text(mediaItem.title, style: fontWeight500(size: 16.0)),
                  Text(
                    mediaItem.album!,
                    style:
                        fontWeight400(size: 14.0, color: CustomColor.subTitle),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Consumer<PlayerProvider>(
                        builder: (context, playerProvider, _) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                              onTap: () async {
                                playerProvider.shuffleSong();
                              },
                              child: Icon(
                                Icons.shuffle_rounded,
                                color: playerProvider.isShuffle
                                    ? CustomColor.secondaryColor
                                    : Colors.white,
                              )),
                          StreamBuilder<List<FavouriteSong>>(
                              stream: objectbox.getFavourites(),
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  return const SizedBox.shrink();
                                } else if (snapshot.data == null) {
                                  return const SizedBox.shrink();
                                }
                                var list3 =
                                    snapshot.data!.map((e) => e.songUniqueId);

                                return GestureDetector(
                                    onTap: () {
                                      list3.contains(
                                              mediaItem.extras!["song_id"])
                                          ? context
                                              .read<PlayerProvider>()
                                              .deleteFavourite(
                                                  mediaItem.extras!["song_id"])
                                          : context
                                              .read<PlayerProvider>()
                                              .addFavourite(
                                                  mediaItem.extras!["song_id"]);
                                    },
                                    child: Icon(
                                      Icons.favorite_rounded,
                                      color: list3.contains(
                                              mediaItem.extras!["song_id"])
                                          ? CustomColor.secondaryColor
                                          : Colors.white,
                                    ));
                              }),
                        ],
                      );
                    }),
                  ),
                  const ProgressBarWidget(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                          onTap: () {
                            Navigation.navigateToScreen(
                                context, RouteName.addPlaylist,
                                args: mediaItem.extras!["song_id"].toString());
                          },
                          child:
                              const Icon(Icons.playlist_add_rounded, size: 34)),
                      StreamBuilder<List<MediaItem>>(
                          stream: context
                              .read<PlayerProvider>()
                              .audioHandler!
                              .queue,
                          builder: (context, snapshot) {
                            List<MediaItem>? mediaItem = snapshot.data;

                            return PlayNextPrev(
                              onTap: () {
                                for (var element in mediaItem!) {
                                  print(element.album);
                                }
                                context.read<PlayerProvider>().playPrev();
                              },
                              iconData: Icons.skip_previous_rounded,
                            );
                          }),
                      const PlayPauseController(),
                      PlayNextPrev(
                        onTap: () {
                          context.read<PlayerProvider>().playNext();
                        },
                        iconData: Icons.skip_next_rounded,
                      ),
                      InkWell(onTap: () async {
                        context.read<PlayerProvider>().loopSong();
                      }, child:
                          Consumer<PlayerProvider>(builder: (context, pro, _) {
                        return Icon(
                          pro.loopStatus == 2
                              ? Icons.repeat_one_rounded
                              : Icons.repeat_rounded,
                          size: 34,
                          color: pro.loopStatus == 0
                              ? Colors.white
                              : CustomColor.secondaryColor,
                        );
                      }))
                    ],
                  )
                ],
              );
            });
      },
    );
  }
}
