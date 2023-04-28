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
import 'package:musiq/src/core/utils/toast_message.dart';
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
  final player = AudioPlayer();
  var header = {'icy-br': '10'};

  deleteInQueue(
    int index,
    BuildContext context,
  ) async {
    await context.read<PlayerProvider>().deleteSongInQueue(index);
    // objectbox.removeQueueSong(id);
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

  Set<String> addedSongs = {};
  addToQueue(PlayerSongListModel e, BuildContext context) async {
    log("789");
    if (addedSongs.contains(e.id.toString())) {
      return toastMessage("Song already added", Colors.white, Colors.black);
    } else {
      try {
        List<SongListModel> songListModels = [];
        List<PlayerSongListModel> addQueues = [];
        for (var song in songListModels) {
          if (song.songId == e.id) {
            return;
          }
        }
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
            extras: {
              "song_id": e.id,
              "isImage": e.isImage,
            });
        // player.quality
        // player.quality = AudioQuality.high;
        await playlist.add(AudioSource.uri(
          Uri.parse(
            generateSongUrl(e.id),
          ),
          tag: item,
          headers: header,
        ));

        player.setAudioSource(playlist);
        objectbox.addSongListQueue(songListModels);
        context
            .read<PlayerProvider>()
            .addSongToQueueSongList(addQueues, context);
        notifyListeners();
        log("879/////////////////////////////////////////////////////");
      } catch (e) {
        log("10,11,12");

        debugPrint(e.toString());
      }
    }
  }

  // addToQueue(PlayerSongListModel e, BuildContext context) async {
  //   // Create empty lists and add the new song to the addQueues list
  //   try {
  //     // Get the current position of the player
  //     final currentPosition = player.position;

  //     // Create the songListModels and addQueues lists
  //     List<SongListModel> songListModels = [];
  //     List<PlayerSongListModel> addQueues = [];
  //     addQueues.add(e);

  //     // Create a new SongListModel instance and add it to the songListModels list
  //     songListModels.add(SongListModel(
  //         songId: e.id,
  //         albumName: e.albumName,
  //         title: e.title,
  //         musicDirectorName: e.musicDirectorName,
  //         imageUrl: e.imageUrl,
  //         songUrl: generateSongUrl(e.id),
  //         duration: e.duration,
  //         isImage: e.isImage));

  //     // Create a new MediaItem instance and add it to the playlist
  //     var item = MediaItem(
  //         id: generateSongUrl(e.id),
  //         album: e.albumName,
  //         title: e.title,
  //         artist: e.musicDirectorName,
  //         duration: Duration(milliseconds: totalDuration(e.duration)),
  //         artUri: Uri.parse(e.imageUrl),
  //         extras: {"song_id": e.id, "isImage": e.isImage});
  //     await playlist
  //         .add(AudioSource.uri(Uri.parse(generateSongUrl(e.id)), tag: item));

  //     // Set the player's audio source to the new playlist
  //     player.setAudioSource(playlist);

  //     // Restore the player's position to the saved position
  //     await player.seek(currentPosition);

  //     // Add the songListModels list to the objectbox instance
  //     objectbox.addSongListQueue(songListModels);

  //     // Add the addQueues list to the PlayerProvider instance using the context
  //     context.read<PlayerProvider>().addSongToQueueSongList(addQueues, context);

  //     // Notify any listeners that the object has been updated
  //     notifyListeners();
  //   } catch (e) {
  //     // Handle any errors
  //     debugPrint(e.toString());
  //   }
  // }

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
          tag: item,
          headers: header));

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
