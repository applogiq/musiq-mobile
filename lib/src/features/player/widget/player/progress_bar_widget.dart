import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/constant.dart';
import '../../../../core/package/audio_progress_bar.dart';
import '../../provider/player_provider.dart';

class PositionData {
  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;

  PositionData(this.position, this.bufferedPosition, this.duration);
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
        return StreamBuilder<SequenceState?>(
            stream: pro.player.sequenceStateStream,
            builder: (context, snapshot) {
              final state = snapshot.data;
              if (state?.sequence.isEmpty ?? true) {
                return const SizedBox.shrink();
              }
              // ignore: unused_local_variable
              final metadata = state!.currentSource!.tag as MediaItem;
              return Column(
                children: [
                  StreamBuilder<Duration>(builder: (context, snapshot) {
                    // final position = snapshot.data;
                    // log("1");
                    // log(pro.progressDurationValue.toString());
                    // // log("2");

                    // log(pro.bufferDurationValue.toString());
                    // // log("3");

                    // log(pro.totalDurationValue.toString());
                    return ProgressBar(
                      thumbGlowRadius: 20,
                      // thumbGlowColor: Colors.white.withOpacity(0.1),
                      progress:
                          Duration(milliseconds: pro.progressDurationValue),
                      buffered: Duration(milliseconds: pro.bufferDurationValue),
                      total: Duration(milliseconds: pro.totalDurationValue),
                      // total: Duration(
                      //     milliseconds:
                      //         totalDuration(metadata.duration.toString())),
                      progressBarColor: CustomColor.secondaryColor,
                      baseBarColor: Colors.white.withOpacity(0.24),
                      bufferedBarColor: Colors.transparent,
                      thumbColor: Colors.white,
                      barHeight: 3.0,
                      thumbRadius: 4.0,
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
