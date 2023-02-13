import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musiq/src/features/player/widget/player/player_widgets.dart';
import 'package:provider/provider.dart';

import '../../../../../main.dart';
import '../../../../core/constants/constant.dart';
import '../../../../core/local/model/favourite_model.dart';
import '../../../../core/routing/route_name.dart';
import '../../../../core/utils/navigation.dart';
import '../../../home/provider/artist_view_all_provider.dart';
import '../../provider/player_provider.dart';

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
              final metadata = state!.currentSource!.tag as MediaItem;

              return Column(
                children: [
                  Text(metadata.title, style: fontWeight500(size: 16.0)),
                  Text(
                    metadata.album!,
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
                          StreamBuilder<bool>(
                              stream: playerProvider
                                  .player.shuffleModeEnabledStream,
                              builder: (context, snapshot) {
                                final shuffleModeEnabled =
                                    snapshot.data ?? false;
                                return InkWell(
                                    onTap: () async {
                                      final enable = !shuffleModeEnabled;
                                      playerProvider.shuffleSong(enable);
                                    },
                                    child: Icon(
                                      Icons.shuffle_rounded,
                                      color: shuffleModeEnabled
                                          ? CustomColor.secondaryColor
                                          : Colors.white,
                                    ));
                              }),
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
                                              metadata.extras!["song_id"])
                                          ? context
                                              .read<PlayerProvider>()
                                              .deleteFavourite(
                                                  metadata.extras!["song_id"],
                                                  ctx: context,
                                                  isFromFav: false)
                                          : context
                                              .read<PlayerProvider>()
                                              .addFavourite(
                                                  metadata.extras!["song_id"]);
                                    },
                                    child: Icon(
                                      Icons.favorite_rounded,
                                      color: list3.contains(
                                              metadata.extras!["song_id"])
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
                                args: metadata.extras!["song_id"].toString());
                          },
                          child:
                              const Icon(Icons.playlist_add_rounded, size: 34)),
                      StreamBuilder<SequenceState?>(
                          stream: context
                              .read<PlayerProvider>()
                              .player
                              .sequenceStateStream,
                          builder: (context, snapshot) {
                            return PlayNextPrev(
                              onTap: () {
                                context.read<PlayerProvider>().playPrev();
                              },
                              iconData: Icons.skip_previous_rounded,
                              isEnable: context
                                  .read<PlayerProvider>()
                                  .player
                                  .hasPrevious,
                            );
                          }),
                      const PlayPauseController(),
                      StreamBuilder<SequenceState?>(
                          stream: context
                              .read<PlayerProvider>()
                              .player
                              .sequenceStateStream,
                          builder: (context, snapshot) {
                            return PlayNextPrev(
                              onTap: () {
                                context.read<PlayerProvider>().playNext();
                              },
                              iconData: Icons.skip_next_rounded,
                              isEnable:
                                  context.read<PlayerProvider>().player.hasNext,
                            );
                          }),
                      Consumer<PlayerProvider>(builder: (context, pro, _) {
                        return StreamBuilder<LoopMode>(
                            stream: pro.player.loopModeStream,
                            builder: (context, snapshot) {
                              return Consumer<PlayerProvider>(
                                  builder: (context, pro, _) {
                                final loopMode = snapshot.data ?? LoopMode.off;
                                const icons = [
                                  Icon(Icons.repeat, color: Colors.grey),
                                  Icon(Icons.repeat, color: Colors.orange),
                                  Icon(Icons.repeat_one, color: Colors.orange),
                                ];
                                const cycleModes = [
                                  LoopMode.off,
                                  LoopMode.all,
                                  LoopMode.one,
                                ];
                                final index = cycleModes.indexOf(loopMode);
                                return IconButton(
                                  icon: icons[index],
                                  iconSize: 34,
                                  onPressed: () {
                                    pro.player.setLoopMode(cycleModes[
                                        (cycleModes.indexOf(loopMode) + 1) %
                                            cycleModes.length]);
                                  },
                                );
                              });
                            });
                      })
                    ],
                  )
                ],
              );
            });
      },
    );
  }
}
