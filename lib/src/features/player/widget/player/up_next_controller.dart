import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:provider/provider.dart';

import '../../../../common_widgets/container/empty_box.dart';
import '../../../../core/constants/constant.dart';
import '../../provider/player_provider.dart';
import '../../screen/player_screen/player_screen.dart';
import '../../screen/player_screen/up_next.dart';

class UpNextController extends StatelessWidget {
  const UpNextController({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PlayerProvider>(
      builder: (context, pro, _) {
        return pro.isUpNextShow
            ? const SizedBox.shrink()
            : Container(
                decoration: topLeftRightDecoration(),
                child: ListTile(
                  onTap: () {
                    context.read<PlayerProvider>().toggleUpNext();
                  },
                  title: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const UpNext(),
                      Consumer<PlayerProvider>(
                        builder: (context, playerProvider, _) {
                          return StreamBuilder<SequenceState?>(
                            stream: playerProvider.player.sequenceStateStream,
                            builder: (context, snapshot) {
                              final state = snapshot.data;
                              if (state?.sequence.isEmpty ?? true) {
                                return const ColoredBox(
                                  color: Colors.black,
                                );
                              }
                              MediaItem? metadata;
                              try {
                                int currentShuffleIndex = playerProvider
                                    .player.shuffleIndices!
                                    .indexOf(state!.currentIndex);
                                int index =
                                    playerProvider.player.shuffleModeEnabled
                                        ? playerProvider.player.shuffleIndices!
                                            .indexOf(state.currentIndex)
                                        : state.currentIndex;
                                metadata = state.effectiveSequence[index + 1]
                                    .tag as MediaItem;
                              } catch (e) {
                                debugPrint(e.toString());
                                metadata = null;
                              }
                              return Text(
                                metadata != null
                                    ? metadata.title.toString()
                                    : "",
                                style: fontWeight400(size: 14.0),
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                  trailing: const Icon(Icons.keyboard_arrow_up),
                ),
              );
      },
    );
  }
}

class UpNextExpandableWidget extends StatelessWidget {
  const UpNextExpandableWidget({
    Key? key,
    required this.widget,
  }) : super(key: key);

  final PlayerScreen widget;

  @override
  Widget build(BuildContext context) {
    return Consumer<PlayerProvider>(builder: (context, pro, _) {
      return SizedBox(
        child: pro.isUpNextShow ? const UpNextExpandable() : const EmptyBox(),
      );
    });
  }
}
