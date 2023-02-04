import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utils/url_generate.dart';
import '../../home/domain/model/song_search_model.dart';
import '../../home/screens/sliver_app_bar/widgets/album_song_list.dart';
import '../../player/domain/model/player_song_list_model.dart';
import '../../player/provider/player_provider.dart';
import '../provider/search_provider.dart';

class SearchArtistPreference extends StatelessWidget {
  const SearchArtistPreference({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount:
            context.read<SearchProvider>().searchSongModel.records.length,
        itemBuilder: (context, index) => InkWell(
          onTap: () {
            context.read<SearchProvider>().searchSongStore();
            Record rec =
                context.read<SearchProvider>().searchSongModel.records[index];
            PlayerSongListModel playerSongListModel = PlayerSongListModel(
                id: rec.id,
                albumName: rec.albumName,
                title: rec.songName,
                imageUrl: generateSongImageUrl(rec.albumName, rec.albumId),
                musicDirectorName: rec.musicDirectorName[0]);
            context
                .read<PlayerProvider>()
                .playSingleSong(context, playerSongListModel);
          },
          child: SongListTile(
              albumName: context
                  .read<SearchProvider>()
                  .searchSongModel
                  .records[index]
                  .albumName,
              imageUrl: generateSongImageUrl(
                  context
                      .read<SearchProvider>()
                      .searchSongModel
                      .records[index]
                      .albumName,
                  context
                      .read<SearchProvider>()
                      .searchSongModel
                      .records[index]
                      .albumId),
              musicDirectorName: context
                  .read<SearchProvider>()
                  .searchSongModel
                  .records[index]
                  .musicDirectorName[0],
              songName: context
                  .read<SearchProvider>()
                  .searchSongModel
                  .records[index]
                  .songName,
              songId: context
                  .read<SearchProvider>()
                  .searchSongModel
                  .records[index]
                  .id),
        ),
      ),
    );
  }
}
