import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:musiq/src/features/player/widget/up_next/song_list_tile_up_next.dart';
import 'package:provider/provider.dart';

import '../../provider/player_provider.dart';
import 'reorderable_song_list_tile.dart';

class SongReorderListViewWidget extends StatefulWidget {
  const SongReorderListViewWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<SongReorderListViewWidget> createState() =>
      _SongReorderListViewWidgetState();
}

class _SongReorderListViewWidgetState extends State<SongReorderListViewWidget> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SequenceState?>(
      stream: context.read<PlayerProvider>().player.sequenceStateStream,
      builder: (context, snapshot) {
        final state = snapshot.data;
        if (state?.sequence.isEmpty ?? true) {
          return const ColoredBox(
            color: Colors.black,
          );
        }

        return state!.shuffleModeEnabled
            ? ListView.builder(
                itemCount: state.shuffleIndices.length,
                itemBuilder: (context, index) {
                  var metadata =
                      state.effectiveSequence[index].tag as MediaItem;
                  return SongListTileUpNext(
                    state: state,
                    metadata: metadata,
                    index: index,
                    currentIndex: context
                                .read<PlayerProvider>()
                                .player
                                .shuffleModeEnabled ==
                            true
                        ? state.shuffleIndices.indexOf(state.currentIndex)
                        : state.currentIndex,
                  );
                })
            : ReorderableListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: state.shuffleModeEnabled
                    ? state.shuffleIndices.length
                    : state.effectiveSequence.length,
                itemBuilder: (context, index) {
                  var metadata =
                      state.effectiveSequence[index].tag as MediaItem;

                  return ReorderableSongListTile(
                    key: Key(index.toString()),
                    state: state,
                    metadata: metadata,
                    index: index,
                    currentIndex: context
                                .read<PlayerProvider>()
                                .player
                                .shuffleModeEnabled ==
                            true
                        ? state.shuffleIndices.indexOf(state.currentIndex)
                        : state.currentIndex,
                  );
                },
                shrinkWrap: true,
                onReorder: (oldIndex, newIndex) async {
                  if (oldIndex < newIndex) {
                    newIndex--;
                  }

                  if (state.shuffleModeEnabled == false) {
                    context
                        .read<PlayerProvider>()
                        .playlist
                        .move(oldIndex, newIndex);
                    print(oldIndex);
                    print(newIndex);
                    final element = state.effectiveSequence.removeAt(oldIndex);
                    state.effectiveSequence.insert(newIndex, element);
                  } else {
                    if (newIndex > state.effectiveSequence.length - 1) {
                      final element = state.shuffleIndices.removeAt(oldIndex);
                      state.shuffleIndices.insert(newIndex, element);
                    }
                  }
                  setState(() {});
                });
      },
    );
  }
}
