import 'package:flutter/material.dart';
import 'package:musiq/src/features/library/screens/playlist/no_song_playlist.dart';

class PlayListSongList extends StatefulWidget {
  const PlayListSongList({super.key, required this.id});
  final int id;

  @override
  State<PlayListSongList> createState() => _PlayListSongListState();
}

class _PlayListSongListState extends State<PlayListSongList> {
  @override
  void initState() {
    super.initState();
  }

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
