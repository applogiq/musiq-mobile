import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:musiq/src/core/constants/local_storage_constants.dart';
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
  final storage = const FlutterSecureStorage();
  store() async {
    return await storage.read(key: LocalStorageConstant.premierStatus);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, left: 0),
      child: Expanded(
        child: Consumer<PlayerProvider>(
          builder: (context, pro, _) {
            return pro.isPlaying == false
                ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: provider.searchSongModel.records.length,
                    itemBuilder: (context, index) {
                      var rec = provider.searchSongModel.records[index];

                      return InkWell(
                        onTap: () async {
                          log("1111111111111111");
                          log("1111111111111111");
                          log("1111111111111111");
                          log("1111111111111111");
                          log("1111111111111111");
                          log("1111111111111111");
                          log("1111111111111111");
                          log("1111111111111111");
                          log("1111111111111111");
                          log("1111111111111111");
                          log("1111111111111111");
                          log("1111111111111111");
                          var ram = await storage.read(
                              key: LocalStorageConstant.premierStatus);
                          if (rec.premiumStatus == "free") {
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
                                    duration: rec.duration,
                                    premium: rec.premiumStatus,
                                    isImage: rec.isImage);
                            context
                                .read<PlayerProvider>()
                                .playSingleSong(context, playerSongListModel);
                          } else if (rec.premiumStatus != "free" &&
                              ram != "free") {
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
                                    duration: rec.duration,
                                    premium: rec.premiumStatus,
                                    isImage: rec.isImage);
                            context
                                .read<PlayerProvider>()
                                .playSingleSong(context, playerSongListModel);
                          } else {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    const SubscriptionsScreen(),
                              ),
                            );
                            FocusScope.of(context).unfocus();
                          }
                        },
                        child: SongListTile(
                          isPremium: rec.premiumStatus != "free" ? true : false,
                          albumName: rec.albumName,
                          imageUrl:
                              generateSongImageUrl(rec.albumName, rec.albumId),
                          musicDirectorName: rec.musicDirectorName[0],
                          songName: rec.songName,
                          songId: rec.id,
                          duration: rec.duration,
                          isPlay: false,
                          isImage: false,
                        ),
                      );
                    },
                  )
                : StreamBuilder<SequenceState?>(
                    stream: pro.player.sequenceStateStream,
                    builder: (context, snapshot) {
                      final state = snapshot.data;
                      if (state != null) {
                        var s = state.effectiveSequence[state.currentIndex].tag
                            as MediaItem;
                        if (state.sequence.isEmpty) {
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
                              onTap: () async {
                                var ram = await storage.read(
                                    key: LocalStorageConstant.premierStatus);
                                print("jangriiiiii");
                                print("jangriiiiii");
                                print("jangriiiiii");
                                print("jangriiiiii");
                                print("jangriiiiii");
                                print("jangriiiiii");
                                print(ram);
                                print(ram);
                                print(ram);
                                print(ram);
                                print(ram);
                                print(ram);

                                if (rec.premiumStatus == "free") {
                                  context
                                      .read<SearchProvider>()
                                      .searchSongStore();
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
                                          musicDirectorName:
                                              rec.musicDirectorName[0],
                                          duration: rec.duration,
                                          premium: rec.premiumStatus,
                                          isImage: rec.isImage);
                                  context.read<PlayerProvider>().playSingleSong(
                                      context, playerSongListModel);
                                } else if (rec.premiumStatus != "free" &&
                                    ram != "free") {
                                  context
                                      .read<SearchProvider>()
                                      .searchSongStore();
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
                                          musicDirectorName:
                                              rec.musicDirectorName[0],
                                          duration: rec.duration,
                                          premium: rec.premiumStatus,
                                          isImage: rec.isImage);
                                  context.read<PlayerProvider>().playSingleSong(
                                      context, playerSongListModel);
                                } else {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const SubscriptionsScreen(),
                                    ),
                                  );
                                  FocusScope.of(context).unfocus();
                                }
                              },
                              child: SongListTile(
                                isPremium:
                                    rec.premiumStatus != "free" ? true : false,
                                albumName: rec.albumName,
                                imageUrl: generateSongImageUrl(
                                    rec.albumName, rec.albumId),
                                musicDirectorName: rec.musicDirectorName[0],
                                songName: rec.songName,
                                songId: rec.id,
                                duration: rec.duration,
                                isPlay: s.extras!["song_id"] == rec.id,
                                isImage: false,
                              ),
                            );
                          },
                        );
                      }
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: provider.searchSongModel.records.length,
                        itemBuilder: (context, index) {
                          var rec = provider.searchSongModel.records[index];

                          return InkWell(
                            onTap: () async {
                              if (rec.premiumStatus == "free") {
                                context
                                    .read<SearchProvider>()
                                    .searchSongStore();
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
                                        musicDirectorName:
                                            rec.musicDirectorName[0],
                                        duration: rec.duration,
                                        premium: rec.premiumStatus,
                                        isImage: rec.isImage);
                                context.read<PlayerProvider>().playSingleSong(
                                    context, playerSongListModel);
                              } else if (rec.premiumStatus != "free" &&
                                  storage
                                          .read(
                                              key: LocalStorageConstant
                                                  .premierStatus)
                                          .toString() !=
                                      "free") {
                                context
                                    .read<SearchProvider>()
                                    .searchSongStore();
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
                                        musicDirectorName:
                                            rec.musicDirectorName[0],
                                        duration: rec.duration,
                                        premium: rec.premiumStatus,
                                        isImage: rec.isImage);
                                context.read<PlayerProvider>().playSingleSong(
                                    context, playerSongListModel);
                              } else {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const SubscriptionsScreen(),
                                  ),
                                );
                                FocusScope.of(context).unfocus();
                              }
                            },
                            child: SongListTile(
                              isPremium:
                                  rec.premiumStatus != "free" ? true : false,
                              albumName: rec.albumName,
                              imageUrl: generateSongImageUrl(
                                  rec.albumName, rec.albumId),
                              musicDirectorName: rec.musicDirectorName[0],
                              songName: rec.songName,
                              songId: rec.id,
                              duration: rec.duration,
                              isPlay: false,
                              isImage: false,
                            ),
                          );
                        },
                      );
                    },
                  );
          },
        ),
      ),
    );
  }
}
