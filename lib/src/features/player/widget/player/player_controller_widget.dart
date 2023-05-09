import 'dart:async';
import 'dart:developer';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musiq/src/common_widgets/box/vertical_box.dart';
import 'package:musiq/src/features/player/widget/player/play_back_speed_widget.dart';
import 'package:musiq/src/features/player/widget/player/player_widgets.dart';
import 'package:musiq/src/features/player/widget/player/sleep_timer_sheet.dart';
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
    Timer? sleepTimer;
    return Consumer<ArtistViewAllProvider>(
      builder: (context, pro, _) {
        return StreamBuilder<SequenceState?>(
            stream: context.read<PlayerProvider>().player.sequenceStateStream,
            builder: (context, snapshot) {
              final state = snapshot.data;
              if (state?.sequence.isEmpty ?? true) {
                log("1object");
                return const Text("no song");
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
                  Text(
                    metadata.artist!,
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
                                // playerProvider.player.sleep
                                // log(shuffleModeEnabled.);
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
                          StreamBuilder<double>(
                            stream: playerProvider.player.speedStream,
                            builder: (context, snapshot) => IconButton(
                              icon: Text(
                                  "${snapshot.data?.toStringAsFixed(1)}x",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                              onPressed: () {
                                showModalBottomSheet(
                                  backgroundColor: Colors.transparent,
                                  context: context,
                                  builder: (context) {
                                    return PlaybackSheet(
                                      player: playerProvider.player,
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                          InkWell(
                              onTap: () {
                                showModalBottomSheet(
                                  backgroundColor: Colors.transparent,
                                  context: context,
                                  builder: (context) {
                                    return SleepTimerSheet(
                                      player: playerProvider.player,
                                    );
                                  },
                                );
                              },
                              child: const Icon(Icons.dark_mode)),
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
                                                  isFromFav: false,
                                                  mainContext: context)
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
                  const VerticalBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                            onTap: () {
                              Navigation.navigateToScreen(
                                  context, RouteName.addPlaylist,
                                  args: metadata.extras!["song_id"].toString());
                            },
                            child: const Icon(Icons.playlist_add_rounded,
                                size: 34)),
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
                                  isEnable: true
                                  // context
                                  //     .read<PlayerProvider>()
                                  //     .player
                                  //     .hasPrevious,
                                  );
                            }),
                        Consumer<PlayerProvider>(
                            // stream: null,
                            builder: (context, pro, _) {
                          log(pro.player.position.inSeconds.toString());
                          seekPrevious() async {
                            if (pro.player.position.inSeconds < 10) {
                              await pro.player.seek(Duration.zero);
                            } else {
                              await context.read<PlayerProvider>().player.seek(
                                  Duration(
                                      seconds:
                                          pro.player.position.inSeconds - 10));
                            }
                          }

                          return InkWell(
                            onTap: () {
                              seekPrevious();
                            },
                            child: const Icon(
                              Icons.replay_10,
                              size: 35,
                            ),
                          );
                        }),
                        const PlayPauseController(),
                        Consumer<PlayerProvider>(builder: (context, pro, _) {
                          seekForward() async {
                            if (pro.totalDurationValue == -10) {
                              await pro.player.seekToNext();
                            } else {
                              await context.read<PlayerProvider>().player.seek(
                                  Duration(
                                      seconds:
                                          pro.player.position.inSeconds + 10));
                            }
                          }

                          return InkWell(
                            onTap: () async {
                              seekForward();
                            },
                            child: const Icon(
                              Icons.forward_10,
                              size: 35,
                            ),
                          );
                        }),
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
                                  isEnable: true);
                            }),
                        Consumer<PlayerProvider>(builder: (context, pro, _) {
                          return StreamBuilder<LoopMode>(
                              stream: pro.player.loopModeStream,
                              builder: (context, snapshot) {
                                return Consumer<PlayerProvider>(
                                    builder: (context, pro, _) {
                                  final loopMode =
                                      snapshot.data ?? LoopMode.off;
                                  const icons = [
                                    Icon(Icons.repeat, color: Colors.grey),
                                    Icon(Icons.repeat, color: Colors.orange),
                                    Icon(Icons.repeat_one,
                                        color: Colors.orange),
                                  ];
                                  const cycleModes = [
                                    LoopMode.off,
                                    LoopMode.all,
                                    LoopMode.one,
                                  ];
                                  final index = cycleModes.indexOf(loopMode);
                                  return InkWell(
                                      onTap: () {
                                        pro.player.setLoopMode(cycleModes[
                                            (cycleModes.indexOf(loopMode) + 1) %
                                                cycleModes.length]);
                                      },
                                      child: Icon(
                                        icons[index].icon,
                                        color: icons[index].color,
                                        size: 30,
                                      ));
                                });
                              });
                        }),
                      ],
                    ),
                  )
                ],
              );
            });
      },
    );
  }
}

void showSliderDialog({
  required BuildContext context,
  required String title,
  required int divisions,
  required double min,
  required double max,
  String valueSuffix = '',
  required double value,
  required Stream<double> stream,
  required ValueChanged<double> onChanged,
}) {
  showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title, textAlign: TextAlign.center),
      content: StreamBuilder<double>(
        stream: stream,
        builder: (context, snapshot) => SizedBox(
          height: 100.0,
          child: Column(
            children: [
              Text('${snapshot.data?.toStringAsFixed(1)}$valueSuffix',
                  style: const TextStyle(
                      fontFamily: 'Fixed',
                      fontWeight: FontWeight.bold,
                      fontSize: 24.0)),
              Slider(
                divisions: divisions,
                min: min,
                max: max,
                value: snapshot.data ?? value,
                onChanged: onChanged,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
