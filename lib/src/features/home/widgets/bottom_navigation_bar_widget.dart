import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musiq/src/features/player/screen/player_screen/player_screen.dart';
import 'package:provider/provider.dart';

import '../../../common_widgets/bottom_navigation_bar/bottom_navigation_bar.dart';
import '../../../common_widgets/box/horizontal_box.dart';
import '../../../core/constants/constant.dart';
import '../../player/provider/player_provider.dart';
import '../../player/widget/player/player_widgets.dart';

class BottomNavigationBarWithMiniPlayer extends StatelessWidget {
  const BottomNavigationBarWithMiniPlayer({super.key, required this.width});
  final double width;

  @override
  Widget build(BuildContext context) {
    return Consumer<PlayerProvider>(builder: (context, pro, _) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          BottomNavigationBarWidget(
            width: width,
          ),
        ],
      );
    });
  }
}

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PlayerProvider>(builder: (context, pro, _) {
      return Container(
          height: 60,
          color: CustomColor.bg,
          child: StreamBuilder<SequenceState?>(
              stream: context.read<PlayerProvider>().player.sequenceStateStream,
              builder: (context, snapshot) {
                final state = snapshot.data;
                if (state?.sequence.isEmpty ?? true) {
                  return const SizedBox();
                }
                final metadata = state!.currentSource!.tag as MediaItem;
                return Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        context.read<PlayerProvider>().isUpNextShow = false;
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const PlayerScreen()));
                      },
                      child: SizedBox(
                        height: 60,
                        width: 60,
                        child: Image.network(
                          metadata.artUri.toString(),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const HorizontalBox(width: 10),
                    Expanded(
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          context.read<PlayerProvider>().isUpNextShow = false;
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const PlayerScreen()));
                        },
                        child: SizedBox(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(metadata.title),
                              Text(metadata.album!),
                            ],
                          ),
                        ),
                      ),
                    ),
                    StreamBuilder<SequenceState?>(
                      stream: pro.player.sequenceStateStream,
                      builder: (context, snapshot) {
                        return IconButton(
                          padding: const EdgeInsets.all(0),
                          onPressed: pro.player.hasPrevious
                              ? () {
                                  context.read<PlayerProvider>().playPrev();
                                }
                              : null,
                          icon: const Icon(Icons.skip_previous_rounded),
                        );
                      },
                    ),
                    StreamBuilder<PlayerState>(
                        stream: pro.player.playerStateStream,
                        builder: (context, snapshot) {
                          final playerState = snapshot.data;
                          final processingState = playerState?.processingState;
                          final playing = playerState?.playing;

                          return InkWell(
                            onTap: () {
                              context
                                  .read<PlayerProvider>()
                                  .playOrPause(playerState!);
                            },
                            child: (processingState ==
                                        ProcessingState.loading ||
                                    processingState ==
                                        ProcessingState.buffering)
                                ? const CircularNotificationPlayerWidget()
                                : PlayButtonWidget(
                                    size: 24.0,
                                    padding: 4.0,
                                    iconColor: const Color.fromRGBO(
                                        255, 255, 255, 0.8),
                                    bgColor:
                                        const Color.fromRGBO(254, 86, 49, 1),
                                    icon: playing != true
                                        ? Icons.play_arrow
                                        : processingState !=
                                                ProcessingState.completed
                                            ? Icons.pause_rounded
                                            : Icons.replay,
                                  ),
                          );
                        }),
                    StreamBuilder<SequenceState?>(
                        stream: pro.player.sequenceStateStream,
                        builder: (context, snapshot) {
                          return IconButton(
                            padding: const EdgeInsets.all(0),
                            onPressed: pro.player.hasNext
                                ? () {
                                    context.read<PlayerProvider>().playNext();
                                  }
                                : null,
                            icon: const Icon(Icons.skip_next_rounded),
                          );
                        }),
                  ],
                );
              }));
    });
  }
}

class CircularNotificationPlayerWidget extends StatelessWidget {
  const CircularNotificationPlayerWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12.0),
      child: CircularProgressIndicator(
        color: CustomColor.secondaryColor,
      ),
    );
  }
}
