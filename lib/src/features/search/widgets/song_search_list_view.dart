import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:musiq/src/features/home/provider/home_provider.dart';
import 'package:musiq/src/features/payment/screen/subscription_screen.dart';
import 'package:provider/provider.dart';

import '../../../core/utils/url_generate.dart';
import '../../home/domain/model/song_search_model.dart';
import '../../home/screens/sliver_app_bar/widgets/song_list_tile.dart';
import '../../player/domain/model/player_song_list_model.dart';
import '../../player/provider/player_provider.dart';
import '../provider/search_provider.dart';

class SongSearchListView extends StatelessWidget {
  const SongSearchListView({
    Key? key,
    required this.provider,
  }) : super(key: key);
  final SearchProvider provider;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Consumer<PlayerProvider>(builder: (context, pro, _) {
        return StreamBuilder<SequenceState?>(
            stream: pro.player.sequenceStateStream,
            builder: (context, snapshot) {
              final state = snapshot.data;
              if (state != null) {
                var s = state.effectiveSequence[state.currentIndex].tag
                    as MediaItem;
                if (state.sequence.isEmpty ?? true) {
                  return const ColoredBox(
                    color: Colors.black,
                  );
                }
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: provider.searchSongModel.records.length,
                  itemBuilder: (context, index) {
                    var rec = provider.searchSongModel.records[index];

                    return InkWell(
                      onTap: () {
                        if ((index == 1 &&
                            context.read<HomeProvider>().premiumStatus ==
                                "free")) {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  const SubscriptionsScreen()));
                        } else {
                          if (s.extras!["song_id"] ==
                              provider.searchSongModel.records[index].id) {
                          } else {
                            context.read<SearchProvider>().searchSongStore();
                            Record rec = context
                                .read<SearchProvider>()
                                .searchSongModel
                                .records[index];
                            PlayerSongListModel playerSongListModel =
                                PlayerSongListModel(
                                    id: rec.id,
                                    albumName: rec.albumName,
                                    title: rec.songName,
                                    imageUrl: generateSongImageUrl(
                                        rec.albumName, rec.albumId),
                                    musicDirectorName: rec.musicDirectorName[0],
                                    duration: rec.duration);
                            context
                                .read<PlayerProvider>()
                                .playSingleSong(context, playerSongListModel);
                          }
                        }
                      },
                      child: SongListTile(
                        isPremium: (index == 1 &&
                                context.read<HomeProvider>().premiumStatus ==
                                    "free")
                            ? true
                            : false,
                        albumName: rec.albumName,
                        imageUrl:
                            generateSongImageUrl(rec.albumName, rec.albumId),
                        musicDirectorName: rec.musicDirectorName[0],
                        songName: rec.songName,
                        songId: rec.id,
                        duration: rec.duration,
                        isPlay: s.extras!["song_id"] == rec.id,
                      ),
                    );
                  },
                );
              }
              return const SizedBox.shrink();
            });
      }),
    );
  }
}
