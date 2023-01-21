import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musiq/src/features/player/provider/extension/player_controller_extension.dart';
import 'package:provider/provider.dart';

import '../../../../common_widgets/box/vertical_box.dart';
import '../../../../constants/color.dart';
import '../../../../constants/style.dart';
import '../../../../routing/route_name.dart';
import '../../../../utils/navigation.dart';
import '../../../home/provider/artist_view_all_provider.dart';
import '../../domain/model/player_song_list_model.dart';
import '../../provider/player_provider.dart';

class PlayerController extends StatelessWidget {
  const PlayerController({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 5,
      child: Column(
        children: [
          const VerticalBox(height: 18),
          Consumer<ArtistViewAllProvider>(
            builder: (context, pro, _) {
              return StreamBuilder<SequenceState?>(
                  stream:
                      context.read<PlayerProvider>().player.sequenceStateStream,
                  builder: (context, snapshot) {
                    final state = snapshot.data;
                    if (state?.sequence.isEmpty ?? true) {
                      return const SizedBox();
                    }
                    final metadata =
                        state!.currentSource!.tag as PlayerSongListModel;
                    return Column(
                      children: [
                        Text(metadata.title, style: fontWeight500(size: 16.0)),
                        Text(
                          metadata.musicDirectorName,
                          style: fontWeight400(
                              size: 14.0, color: CustomColor.subTitle),
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
                                InkWell(
                                    onTap: () {
                                      // context
                                      //     .read<PlayerProvider>()
                                      //     .addFavourite(metadata.id);
                                      context
                                          .read<PlayerProvider>()
                                          .deleteFavourite(metadata.id);
                                      // print(playScreenModel[index].id);
                                      // songController.checkFav();
                                    },
                                    child: const Icon(
                                      Icons.favorite_rounded,
                                      color: Colors.white,
                                    )),
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
                                child: const Icon(Icons.playlist_add_rounded,
                                    size: 34)),
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
                            }, child: Consumer<PlayerProvider>(
                                builder: (context, pro, _) {
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
          )
        ],
      ),
    );
  }
}

class PlayNextPrev extends StatelessWidget {
  const PlayNextPrev({
    Key? key,
    required this.onTap,
    required this.iconData,
  }) : super(key: key);
  final Function onTap;
  final IconData iconData;
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          onTap();
        },
        child: Icon(
          iconData,
          size: 34,
        ));
  }
}

class ProgressBarWidget extends StatelessWidget {
  const ProgressBarWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Consumer<PlayerProvider>(builder: (context, pro, _) {
        return ProgressBar(
          progress: Duration(milliseconds: pro.progressDurationValue),
          buffered: Duration(milliseconds: pro.bufferDurationValue),
          total: Duration(milliseconds: pro.totalDurationValue),
          progressBarColor: CustomColor.secondaryColor,
          baseBarColor: Colors.white.withOpacity(0.24),
          bufferedBarColor: Colors.white.withOpacity(0.24),
          thumbColor: Colors.white,
          barHeight: 6.0,
          thumbRadius: 6.0,
          onSeek: (duration) {
            pro.seekDuration(duration);
            // songController.seekDuration(duration);
          },
        );
      }),
    );
  }
}

class PlayPauseController extends StatelessWidget {
  const PlayPauseController({
    Key? key,
  }) : super(key: key);

  // final SongController songController;

  @override
  Widget build(BuildContext context) {
    return Consumer<PlayerProvider>(builder: (context, pro, _) {
      return InkWell(
        onTap: () {
          pro.playOrPause();
        },
        child: pro.isPlay
            ? PlayButtonWidget(
                bgColor: CustomColor.secondaryColor,
                iconColor: Colors.white,
                size: 34.0,
                padding: 14.0,
                icon: Icons.pause_rounded,
              )
            : PlayButtonWidget(
                bgColor: CustomColor.secondaryColor,
                iconColor: Colors.white,
                size: 34.0,
                padding: 14.0,
              ),
      );
    });
  }
}

class PlayButtonWidget extends StatelessWidget {
  PlayButtonWidget(
      {Key? key,
      this.bgColor = const Color.fromRGBO(255, 255, 255, 0.8),
      this.iconColor = const Color.fromRGBO(254, 86, 49, 1),
      this.size = 20.0,
      this.padding = 6.0,
      this.icon = Icons.play_arrow})
      : super(key: key);
  var bgColor;
  var iconColor;
  var size;
  var padding;
  var icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
      child: Icon(
        icon,
        size: size,
        color: iconColor,
      ),
    );
  }
}
