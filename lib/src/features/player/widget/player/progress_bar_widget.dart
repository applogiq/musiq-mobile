import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:musiq/src/core/utils/time.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/constant.dart';
import '../../../../core/package/audio_progress_bar.dart';
import '../../provider/player_provider.dart';

class ProgressBarWidget extends StatelessWidget {
  const ProgressBarWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Consumer<PlayerProvider>(builder: (context, pro, _) {
        return StreamBuilder<MediaItem?>(
            stream: context.read<PlayerProvider>().audioHandler!.mediaItem,
            builder: (context, snapshot) {
              final state = snapshot.data;
              MediaItem? mediaItem = snapshot.data;

              if (mediaItem == null) {
                return const SizedBox.shrink();
              }
              return Column(
                children: [
                  StreamBuilder<Duration>(
                      stream: pro.positionStream,
                      builder: (context, snapshot) {
                        final position = snapshot.data;
                        return ProgressBar(
                          progress: Duration(
                              milliseconds: totalDuration(position.toString())),
                          buffered: const Duration(milliseconds: 0),
                          total: Duration(
                              milliseconds:
                                  totalDuration(mediaItem.duration.toString())),
                          progressBarColor: CustomColor.secondaryColor,
                          baseBarColor: Colors.white.withOpacity(0.24),
                          bufferedBarColor: Colors.transparent,
                          thumbColor: Colors.white,
                          barHeight: 6.0,
                          thumbRadius: 6.0,
                          onSeek: (duration) {
                            pro.seekDuration(duration);
                            // songController.seekDuration(duration);
                          },
                        );
                      }),
                ],
              );
            });
      }),
    );
  }
}
