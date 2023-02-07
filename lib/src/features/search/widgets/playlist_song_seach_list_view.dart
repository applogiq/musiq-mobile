import 'package:flutter/material.dart';
import 'package:musiq/src/features/home/domain/model/song_search_model.dart';
import 'package:musiq/src/features/search/screens/search_screen.dart';
import 'package:provider/provider.dart';

import '../../../core/utils/url_generate.dart';
import '../../home/screens/sliver_app_bar/widgets/song_play_list_tile.dart';
import '../../player/domain/model/player_song_list_model.dart';
import '../../player/provider/player_provider.dart';
import '../provider/search_provider.dart';

class PlaylistSearchSongTile extends StatelessWidget {
  const PlaylistSearchSongTile({
    Key? key,
    required this.searchRequestModel,
    required this.pro,
  }) : super(key: key);

  final SearchRequestModel searchRequestModel;
  final SearchProvider pro;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: pro.searchSongModel.records.length,
        itemBuilder: (context, index) => InkWell(
          onTap: () {
            context.read<SearchProvider>().searchSongStore();
            Record rec = pro.searchSongModel.records[index];
            PlayerSongListModel playerSongListModel = PlayerSongListModel(
                id: rec.id,
                albumName: rec.albumName,
                title: rec.songName,
                imageUrl: generateSongImageUrl(rec.albumName, rec.albumId),
                musicDirectorName: rec.musicDirectorName[0],
                duration: rec.duration);
            context
                .read<PlayerProvider>()
                .playSingleSong(context, playerSongListModel);
          },
          child: SongPlayListTile(
            playlistId: searchRequestModel.playlistId!,
            albumName: pro.searchSongModel.records[index].albumName,
            imageUrl: generateSongImageUrl(
                pro.searchSongModel.records[index].albumName,
                pro.searchSongModel.records[index].albumId),
            musicDirectorName:
                pro.searchSongModel.records[index].musicDirectorName[0],
            songName: pro.searchSongModel.records[index].songName,
            songId: pro.searchSongModel.records[index].id,
            isAdded: pro.playlistSongId
                    .contains(pro.searchSongModel.records[index].id)
                ? true
                : false,
          ),
        ),
      ),
    );
  }
}
