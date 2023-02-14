import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/constant.dart';
import '../../../home/widgets/bottom_navigation_bar_widget.dart';
import '../../provider/player_provider.dart';
import 'player_widgets.dart';

class PlayPauseController extends StatelessWidget {
  const PlayPauseController({
    Key? key,
  }) : super(key: key);

  // final SongController songController;

  @override
  Widget build(BuildContext context) {
    return Consumer<PlayerProvider>(builder: (context, pro, _) {
      return StreamBuilder<PlayerState>(
          stream: pro.player.playerStateStream,
          builder: (context, snapshot) {
            final playerState = snapshot.data;
            final processingState = playerState?.processingState;
            final playing = playerState?.playing;
            return GestureDetector(
                onTap: () {
                  context.read<PlayerProvider>().playOrPause(playerState!);
                },
                child: (processingState == ProcessingState.loading ||
                        processingState == ProcessingState.buffering)
                    ? const CircularNotificationPlayerWidget()
                    : PlayButtonWidget(
                        bgColor: CustomColor.secondaryColor,
                        iconColor: Colors.white,
                        size: 34.0,
                        padding: 8.0,
                        icon: playing != true
                            ? Icons.play_arrow
                            : processingState != ProcessingState.completed
                                ? Icons.pause_rounded
                                : Icons.replay,
                      ));
          });
    });
  }
}
