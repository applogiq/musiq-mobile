import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musiq/src/core/local/model/favourite_model.dart';
import 'package:provider/provider.dart';

import '../../../../../main.dart';
import '../../../../core/constants/constant.dart';
import '../../../../core/routing/route_name.dart';
import '../../../../core/utils/navigation.dart';
import '../../../home/provider/artist_view_all_provider.dart';
import '../../domain/model/player_song_list_model.dart';
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
        return StreamBuilder<SequenceState?>(
            stream: context.read<PlayerProvider>().player.sequenceStateStream,
            builder: (context, snapshot) {
              final state = snapshot.data;
              if (state?.sequence.isEmpty ?? true) {
                return const SizedBox();
              }
              final metadata = state!.currentSource!.tag as PlayerSongListModel;
              return Column(
                children: [
                  Text(metadata.title, style: fontWeight500(size: 16.0)),
                  Text(
                    metadata.musicDirectorName,
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
                                      list3.contains(metadata.id)
                                          ? context
                                              .read<PlayerProvider>()
                                              .deleteFavourite(metadata.id)
                                          : context
                                              .read<PlayerProvider>()
                                              .addFavourite(metadata.id);
                                    },
                                    child: Icon(
                                      Icons.favorite_rounded,
                                      color: list3 == null
                                          ? Colors.white
                                          : list3.contains(metadata.id)
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
                                args: metadata.id.toString());
                          },
                          child:
                              const Icon(Icons.playlist_add_rounded, size: 34)),
                      PlayNextPrev(
                        onTap: () {
                          context.read<PlayerProvider>().playPrev();
                        },
                        iconData: Icons.skip_previous_rounded,
                      ),
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
