import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:musiq/src/features/player/provider/player_provider.dart';
import 'package:provider/provider.dart';

import '../../../../common_widgets/container/custom_color_container.dart';
import '../../../../core/constants/constant.dart';
import 'up_next_widgets.dart';

class ReorderableSongListTile extends StatelessWidget {
  const ReorderableSongListTile({
    Key? key,
    required this.state,
    required this.metadata,
    required this.index,
    required this.currentIndex,
  }) : super(key: key);

  final SequenceState? state;
  final MediaItem metadata;
  final int index;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        print(index);
        if (context.read<PlayerProvider>().player.shuffleModeEnabled == true) {
          int selectedIndex = context
              .read<PlayerProvider>()
              .player
              .shuffleIndices!
              .elementAt(index);
          context.read<PlayerProvider>().seekToIndex(selectedIndex);
        } else {
          context.read<PlayerProvider>().seekToIndex(index);
        }
      },
      child: Container(
        key: Key(index.toString()),
        padding: const EdgeInsets.symmetric(vertical: 4),
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: [
            ReorderableDragStartListener(
              index: 2,
              enabled: index != currentIndex,
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Icon(
                  index == currentIndex
                      ? Icons.play_arrow_rounded
                      : Icons.view_stream_rounded,
                  color: index == currentIndex
                      ? CustomColor.secondaryColor
                      : Colors.white,
                  size: 18,
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: CustomColorContainer(
                child: Image.network(
                  metadata.artUri.toString(),
                  height: 70,
                  width: 70,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Expanded(
              flex: 9,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      metadata.title,
                      style: fontWeight400(
                          color: index == currentIndex
                              ? CustomColor.secondaryColor
                              : Colors.white),
                    ),
                    Text(
                      metadata.artist.toString(),
                      style: fontWeight400(
                          size: 12.0,
                          color: index == currentIndex
                              ? CustomColor.secondaryColor
                              : CustomColor.subTitle),
                    ),
                  ],
                ),
              ),
            ),
            ReorderableSongListPopUpMenu(
              metadata: metadata,
              index: index,
            )
          ],
        ),
      ),
    );
  }
}
