import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:musiq/src/core/routing/route_name.dart';
import 'package:musiq/src/core/utils/navigation.dart';
import 'package:provider/provider.dart';

import '../../../common_widgets/bottom_navigation_bar/bottom_navigation_bar.dart';
import '../../../common_widgets/box/horizontal_box.dart';
import '../../../core/constants/constant.dart';
import '../../player/provider/player_provider.dart';
import '../../player/widget/player/player_button_widget.dart';

class BottomNavigationBarWithMiniPlayer extends StatelessWidget {
  const BottomNavigationBarWithMiniPlayer({super.key, required this.width});
  final double width;

  @override
  Widget build(BuildContext context) {
    return Consumer<PlayerProvider>(builder: (context, pro, _) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          pro.isPlaying == false
              ? const SizedBox.shrink()
              : ColoredBox(
                  color: CustomColor.bg,
                  child:

                      // Row(
                      //   children: [
                      //     StreamBuilder<MediaItem?>(
                      // stream: context
                      //     .read<PlayerProvider>()
                      //     .audioHandler!
                      //     .mediaItem,
                      //         builder: (context, snapshot) {
                      // MediaItem? mediaItem = snapshot.data;
                      // if (mediaItem == null) return const SizedBox();
                      //           return Text(mediaItem.title);
                      //         }),
                      //     IconButton(
                      //         onPressed: () {
                      //           context.read<PlayerProvider>().audioHandler!.play();
                      //         },
                      //         icon: const Icon(Icons.play_arrow)),
                      //     IconButton(
                      //         onPressed: () {
                      //           context
                      //               .read<PlayerProvider>()
                      //               .audioHandler!
                      //               .pause();
                      //         },
                      //         icon: const Icon(Icons.play_arrow)),
                      //   ],
                      // )

                      context.read<PlayerProvider>().audioHandler != null
                          ? StreamBuilder<MediaItem?>(
                              stream: context
                                  .read<PlayerProvider>()
                                  .audioHandler!
                                  .mediaItem,
                              builder: (context, snapshot) {
                                MediaItem? mediaItem = snapshot.data;
                                if (mediaItem == null) {
                                  return const SizedBox();
                                }
                                // final metadata =
                                //     state!.currentSource!.tag as PlayerSongListModel;
                                return Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {},
                                      child: SizedBox(
                                        height: 60,
                                        width: 60,
                                        child: Image.network(
                                          mediaItem.artUri.toString(),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    const HorizontalBox(width: 10),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigation.navigateToScreen(
                                              context, RouteName.player);
                                        },
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(mediaItem.title),
                                            Text(mediaItem.album!),
                                          ],
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      padding: const EdgeInsets.all(0),
                                      onPressed: () {
                                        context
                                            .read<PlayerProvider>()
                                            .playPrev();
                                      },
                                      icon: const Icon(
                                          Icons.skip_previous_rounded),
                                    ),
                                    StreamBuilder<PlaybackState>(
                                        stream: context
                                            .read<PlayerProvider>()
                                            .audioHandler!
                                            .playbackState,
                                        builder: (context, snapshot) {
                                          final playbackState = snapshot.data;
                                          final playing =
                                              playbackState?.playing ?? true;

                                          return InkWell(
                                            onTap: () {
                                              context
                                                  .read<PlayerProvider>()
                                                  .playOrPause();
                                            },
                                            child: PlayButtonWidget(
                                              size: 24.0,
                                              padding: 4.0,
                                              iconColor: const Color.fromRGBO(
                                                  255, 255, 255, 0.8),
                                              bgColor: const Color.fromRGBO(
                                                  254, 86, 49, 1),
                                              icon: !playing
                                                  ? Icons.play_arrow
                                                  : Icons
                                                      .pause_circle_filled_rounded,
                                            ),
                                          );
                                        }),
                                    IconButton(
                                      padding: const EdgeInsets.all(0),
                                      onPressed: () {
                                        context
                                            .read<PlayerProvider>()
                                            .playNext();
                                      },
                                      icon: const Icon(Icons.skip_next_rounded),
                                    ),
                                  ],
                                );
                              })
                          : const SizedBox.shrink()),
          BottomNavigationBarWidget(
            width: width,
          ),
        ],
      );
    });
  }
}
