import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

import '../../domain/model/player_song_list_model.dart';
import '../../provider/player_provider.dart';
import 'up_next_widgets.dart';

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
          return ReorderableListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: state!.effectiveSequence.length,
            itemBuilder: (context, index) {
              var metadata =
                  state.effectiveSequence[index].tag as PlayerSongListModel;
              return ReorderableSongListTile(
                key: Key(index.toString()),
                state: state,
                metadata: metadata,
                index: index,
                currentIndex: state.currentIndex,
              );
            },
            shrinkWrap: true,
            onReorder: (oldIndex, newIndex) {
              if (newIndex != state.currentIndex &&
                  oldIndex != state.currentIndex) {
                setState(() {
                  if (newIndex > oldIndex) {
                    newIndex = newIndex - 1;
                  }
                  final element = state.effectiveSequence.removeAt(oldIndex);
                  state.effectiveSequence.insert(newIndex, element);
                });
              }
            },
          );
        });
  }
}
