import 'package:flutter/material.dart';
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
        return StreamBuilder<PositionData?>(builder: (context, snapshot) {
          return Column(
            children: [
              StreamBuilder<Duration>(builder: (context, snapshot) {
                // final position = snapshot.data;
                return ProgressBar(
                  progress: Duration(milliseconds: pro.progressDurationValue),
                  buffered: Duration(milliseconds: pro.bufferDurationValue),
                  total: Duration(milliseconds: pro.totalDurationValue),
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
