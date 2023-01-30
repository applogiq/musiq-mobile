import 'package:flutter/material.dart';
import 'package:musiq/src/features/library/screens/playlist/no_song_playlist.dart';

class PlayListSongList extends StatelessWidget {
  const PlayListSongList({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: NoPlaylistSong(
        appBarTitle: "S",
        playListId: "2",
      ),
    );
  }
}
