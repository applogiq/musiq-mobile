import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musiq/src/core/utils/time.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/constant.dart';
import '../../../../core/package/audio_progress_bar.dart';
import '../../domain/model/player_song_list_model.dart';
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
        return StreamBuilder<SequenceState?>(
            stream: pro.player.sequenceStateStream,
            builder: (context, snapshot) {
              final state = snapshot.data;
              if (state?.sequence.isEmpty ?? true) {
                return const SizedBox.shrink();
              }
              final metadata = state!.currentSource!.tag as PlayerSongListModel;
              return Column(
                children: [
                  ProgressBar(
                    progress: Duration(milliseconds: pro.progressDurationValue),
                    buffered: Duration(milliseconds: pro.bufferDurationValue),
                    total: Duration(
                        milliseconds: totalDuration(metadata.duration)),
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
                  ),
                ],
              );
            });
      }),
    );
  }
}
