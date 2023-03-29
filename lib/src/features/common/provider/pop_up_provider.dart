import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:musiq/main.dart';
import 'package:musiq/src/core/constants/local_storage_constants.dart';
import 'package:musiq/src/core/extensions/context_extension.dart';
import 'package:musiq/src/core/local/model/queue_model.dart';
import 'package:musiq/src/core/utils/time.dart';
import 'package:musiq/src/core/utils/url_generate.dart';
import 'package:musiq/src/features/library/provider/library_provider.dart';
import 'package:musiq/src/features/player/domain/model/player_song_list_model.dart';
import 'package:musiq/src/features/profile/widgets/logout_dialog.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/routing/route_name.dart';
import '../../../core/utils/navigation.dart';
import '../../player/provider/player_provider.dart';

class PopUpProvider extends ChangeNotifier {
  ConcatenatingAudioSource playlist = ConcatenatingAudioSource(children: []);
  AudioPlayer player = AudioPlayer();

  deleteInQueue(int index, BuildContext context) {
    context.read<PlayerProvider>().deleteSongInQueue(index);
  }

  addToFavourites(int songId, BuildContext context) async {
    context.read<PlayerProvider>().addFavourite(songId);
  }

  goToPlaylist(int songId, BuildContext context) {
    Navigation.navigateToScreen(context, RouteName.addPlaylist,
        args: songId.toString());
  }

  goToSongInfo(int songId, BuildContext context) {
    Navigation.navigateToScreen(context, RouteName.songInfo, args: songId);
  }

  addToQueue(PlayerSongListModel e, BuildContext context) async {
    log("789");
    log("789");
    log("789");
    log("789");
    log("789");
    log("789");
    log("789");
    log("789");
    log("789");
    log("789");
    log("789");
    log("789");
    log("789");
    log("789");
    log("789");
    log("789");
    log("789");
    log("789");
    log("789");
    log("789");
    try {
      List<SongListModel> songListModels = [];
      List<PlayerSongListModel> addQueues = [];
      addQueues.add(e);

      songListModels.add(SongListModel(
          songId: e.id,
          albumName: e.albumName,
          title: e.title,
          musicDirectorName: e.musicDirectorName,
          imageUrl: e.imageUrl,
          songUrl: generateSongUrl(e.id),
          duration: e.duration,
          isImage: e.isImage));
      var item = MediaItem(
          id: generateSongUrl(e.id),
          album: e.albumName,
          title: e.title,
          artist: e.musicDirectorName,
          duration: Duration(milliseconds: totalDuration(e.duration)),
          artUri: Uri.parse(e.imageUrl),
          extras: {"song_id": e.id, "isImage": e.isImage});
      await playlist.add(AudioSource.uri(
          Uri.parse(
            generateSongUrl(e.id),
          ),
          tag: item));

      player.setAudioSource(playlist);
      objectbox.addSongListQueue(songListModels);
      context.read<PlayerProvider>().addSongToQueueSongList(addQueues, context);
      notifyListeners();
      log("879");
    } catch (e) {
      log("10,11,12");

      debugPrint(e.toString());
    }
  }

  void queueSong(PlayerSongListModel e) async {
    log("message");
    try {
      List<SongListModel> songListModels = [];

      songListModels.add(SongListModel(
          songId: e.id,
          albumName: e.albumName,
          title: e.title,
          musicDirectorName: e.musicDirectorName,
          imageUrl: e.imageUrl,
          songUrl: generateSongUrl(e.id),
          duration: e.duration,
          isImage: e.isImage));
      var item = MediaItem(
          id: generateSongUrl(e.id),
          album: e.albumName,
          title: e.title,
          artist: e.musicDirectorName,
          duration: Duration(milliseconds: totalDuration(e.duration)),
          artUri: Uri.parse(e.imageUrl),
          extras: {"song_id": e.id, "isImage": e.isImage});
      await playlist.add(AudioSource.uri(
          Uri.parse(
            generateSongUrl(e.id),
          ),
          tag: item));

      player.setAudioSource(playlist);
      objectbox.addSongListQueue(songListModels);
      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  addListToQueue() {}

  goToAlbumInfo() {}

  share() {
    Share.share(
        'check out MusiQ app\n https://play.google.com/store/apps/details?id=app.gotoz.parent');
  }

  playNext(PlayerSongListModel playerSongListModel, BuildContext context) {
    context.read<PlayerProvider>().queuePlayNext(playerSongListModel);
  }

  removeFromFavourites(int id, BuildContext context, BuildContext mainContext) {
    context.read<PlayerProvider>().deleteFavourite(id,
        isFromFav: true, ctx: context, mainContext: mainContext);
  }

  deletePlaylist(int id, BuildContext context) {
    // context
    //     .read<PlayerProvider>()
    //     .deleteFavourite(id, isFromFav: true, ctx: context);
  }

  renamePlaylist() {}

  playAll() {}

  addSong() {}

  removeSongFromPlaylist(
      int playlistSongId, BuildContext context, int playlistId) {
    context
        .read<LibraryProvider>()
        .removeSongFromPlayLlist(playlistSongId, playlistId);
  }

  subscriptionCheck(BuildContext context) async {
    FlutterSecureStorage secureStorage = const FlutterSecureStorage();
    var subscriptionEndDate =
        await secureStorage.read(key: LocalStorageConstant.subscriptionEndDate);
    print("subscriptionEndDate");
    print(subscriptionEndDate);
    if (subscriptionEndDate != null) {
      DateTime endDate = DateTime.parse(subscriptionEndDate).toLocal();
      DateTime now = DateTime.now().toLocal();
      print("😁😁😂😂😂");
      print(endDate);
      print("😁😁😂😂😂");
      print(endDate.isAfter(now));

      print(now);
      if (endDate.compareTo(now) < 0) {
        if (context.mounted) {
          showSubscriptionDialog(context);
        }
      } else {
        print("SSSSDD");
      }
    }
    // await secureStorage.write(
    //     key: LocalStorageConstant.subscriptionEndDate, value: "2023-02-21");
  }
}
