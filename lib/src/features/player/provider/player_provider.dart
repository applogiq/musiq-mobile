// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musiq/src/core/local/model/favourite_model.dart';
import 'package:musiq/src/features/library/domain/models/favourite_model.dart';
import 'package:musiq/src/features/player/domain/model/player_song_list_model.dart';
import 'package:musiq/src/features/player/domain/model/song_info_model.dart';
import 'package:musiq/src/features/player/domain/repo/player_repo.dart';
import 'package:musiq/src/features/player/provider/extension/player_controls_extension.dart';
import 'package:provider/provider.dart';

import '../../../../main.dart';
import '../../../core/local/model/queue_model.dart';
import '../../../core/utils/time.dart';
import '../../../core/utils/toast_message.dart';
import '../../../core/utils/url_generate.dart';
import '../../home/provider/home_provider.dart';
import '../../library/domain/library_repo.dart';
import '../../library/domain/models/playlist_model.dart';
import '../../library/provider/library_provider.dart';

export "extension/player_controls_extension.dart";
export "extension/player_local_db_controller_extension.dart";

class QueueState {
  static const QueueState empty =
      QueueState([], 0, [], AudioServiceRepeatMode.none);

  final List<MediaItem> queue;
  final int? queueIndex;
  final List<int>? shuffleIndices;
  final AudioServiceRepeatMode repeatMode;

  const QueueState(
      this.queue, this.queueIndex, this.shuffleIndices, this.repeatMode);

  bool get hasPrevious =>
      repeatMode != AudioServiceRepeatMode.none || (queueIndex ?? 0) > 0;
  bool get hasNext =>
      repeatMode != AudioServiceRepeatMode.none ||
      (queueIndex ?? 0) + 1 < queue.length;

  List<int> get indices =>
      shuffleIndices ?? List.generate(queue.length, (i) => i);
}

class PlayerProvider extends ChangeNotifier {
  // final MiniplayerController controller = MiniplayerController();
  // AudioPlayerHandler audioPlayerHandler = AudioPlayerHandler();
  FlutterSecureStorage storage = const FlutterSecureStorage();
  bool isPlay = false;
  bool isPlaying = false;
  bool isShuffle = false;
  bool issongInfoDetailsLoad = true;
  int loopStatus = 0;
  int index = 2;
  bool inQueue = false;
  bool isUpNextShow = false;
  void toggleUpNext() {
    isUpNextShow = !isUpNextShow;
    notifyListeners();
  }

  // late Store store;
  List<int> favouritesList = [];
  List<int> queueIdList = [];
  List songPosition = [];
  ConcatenatingAudioSource playlist = ConcatenatingAudioSource(children: []);

  AudioPlayer player = AudioPlayer();

  var selectedIndex = 0;
  var progressDurationValue = 0;
  var totalDurationValue = 0;
  var bufferDurationValue = 0;
  SongInfoModel? songInfoModel;
  PlayerRepo playerRepo = PlayerRepo();
  bool isPlayListLoad = true;
  FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  PlayListModel playListModel = PlayListModel(
      success: false, message: "No records", records: [], totalRecords: 0);
  AudioHandler? _audioHandler;
  List<MediaItem> globalQueue = [];
  int? globalIndex;
  Stream<Duration>? positionStream = const Stream.empty();
  Stream<int>? currentIndex = const Stream.empty();

  AudioHandler? get audioHandler => _audioHandler;

  iscurrentIndex() {
    return player.currentIndex.toString();
  }

  void queuePlayNext(PlayerSongListModel playerSongListModel) {
    // player.currentIndex
    if (player.currentIndex != null) {
      final item = MediaItem(
          id: generateSongUrl(playerSongListModel.id),
          album: playerSongListModel.albumName,
          title: playerSongListModel.title,
          artist: playerSongListModel.musicDirectorName,
          duration: Duration(
              milliseconds: totalDuration(playerSongListModel.duration)),
          artUri: Uri.parse(playerSongListModel.imageUrl),
          extras: {"song_id": playerSongListModel.id});
      playlist.insert(player.currentIndex! + 1,
          AudioSource.uri(Uri.parse(item.id), tag: item));
    }
  }

  getFavourites() async {
    log(player.currentIndex.toString());
    objectbox.removeAllFavourite();
    var id = await secureStorage.read(key: "id");

    var response = await LibraryRepository().getFavouritesList(id!);

    if (response.statusCode == 200) {
      List<FavouriteSong> fav = [];
      FavouriteModel favouriteModel =
          FavouriteModel.fromMap(jsonDecode(response.body.toString()));
      print(favouriteModel.records.length);
      for (var element in favouriteModel.records) {
        fav.add(FavouriteSong(songUniqueId: element.id));
      }

      objectbox.addFavouritesSongList(fav);
    }
  }

  void deleteFavourite(int id,
      {required bool isFromFav, required BuildContext ctx}) async {
    Map params = {"song_id": id};

    var res = await playerRepo.deleteFavourite(params);

    if (res.statusCode == 200) {
      objectbox.removeFavourite(id);
      if (isFromFav) {
        ctx.read<LibraryProvider>().getFavouritesList();
      }
      toastMessage(
          "Song removed from favourite list", Colors.grey, Colors.white);
    } else if (res.statusCode == 404) {
      //  loadFavourites();
      toastMessage("Favourites not found", Colors.grey, Colors.white);
    }
  }

  void queueSong(PlayerSongListModel e) async {
    print("fgdfg");
    try {
      List<SongListModel> songListModels = [];
      List<MediaItem> mediaItems = [];
      // removePlaylist();

      songListModels.add(SongListModel(
          songId: e.id,
          albumName: e.albumName,
          title: e.title,
          musicDirectorName: e.musicDirectorName,
          imageUrl: e.imageUrl,
          songUrl: generateSongUrl(e.id),
          duration: e.duration));
      var item = MediaItem(
          id: generateSongUrl(e.id),
          album: e.albumName,
          title: e.title,
          artist: e.musicDirectorName,
          duration: Duration(milliseconds: totalDuration(e.duration)),
          artUri: Uri.parse(e.imageUrl),
          extras: {"song_id": e.id});
      await playlist.add(AudioSource.uri(
          Uri.parse(
            generateSongUrl(e.id),
          ),
          tag: item));

      player.setAudioSource(playlist);
      objectbox.addSongListQueue(songListModels);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void addFavourite(int id) async {
    Map params = {"song_id": id};
    var res = await playerRepo.addToFavourite(params);

    if (res.statusCode == 200) {
      toastMessage("Song added to favourite list", Colors.grey, Colors.white);
      objectbox.addFavouritesSong(FavouriteSong(songUniqueId: id));
    } else if (res.statusCode == 400) {
      // loadFavourites();

      toastMessage("Song already in favourite list", Colors.grey, Colors.white);
    }
  }

  loadQueueSong() async {
    // await loadSongIndex();
    if (!inQueue) {
      await getFavourites();
      var index = await secureStorage.read(key: "currentIndex");
      var songPosition = await secureStorage.read(key: "lastPosition");
      print(songPosition);
      List songPositionList = [];
      List songPositionSeconds = [];
      if (songPosition != null) {
        songPositionList = songPosition.toString().split(":");
        songPositionSeconds = songPositionList[2].toString().split(".");
      }
      var res = objectbox.getAllQueueSong();
      if (res.isNotEmpty) {
        queueIdList.clear();
        List<PlayerSongListModel> playerSongList = [];
        for (var e in res) {
          playerSongList.add(PlayerSongListModel(
              id: e.songId,
              albumName: e.albumName,
              title: e.title,
              imageUrl: e.imageUrl,
              musicDirectorName: e.musicDirectorName,
              duration: e.duration));
          final item = MediaItem(
              id: generateSongUrl(e.songId),
              album: e.albumName,
              title: e.title,
              artist: e.musicDirectorName,
              duration: Duration(milliseconds: totalDuration(e.duration)),
              artUri: Uri.parse(e.imageUrl),
              extras: {"song_id": e.songId});
          playlist.add(
            AudioSource.uri(
                Uri.parse(
                  generateSongUrl(e.songId),
                ),
                tag: item),
          );

          // await _audioHandler!.addQueueItem(item);

          // await _audioHandler!.skipToQueueItem(index);
          // try {
          //   // print(await secureStorage.read(key: "lastPosition "));
          //   List sec = songPosition[2].toString().split(".");
          // await _audioHandler!.seek(Duration(
          //     hours: int.parse(songPosition[0]),
          //     minutes: int.parse(songPosition[1]),
          //     seconds: int.parse(sec[0])));
          // } catch (e) {
          //   print(e.toString());
          // }
        }
        player.setAudioSource(playlist);
        try {
          if (songPositionSeconds.isNotEmpty && songPositionList.isNotEmpty) {
            player.seek(
                Duration(
                    hours: int.parse(songPositionList[0]),
                    minutes: int.parse(songPositionList[1]),
                    seconds: int.parse(songPositionSeconds[0])),
                index: int.parse(index!));
          }
        } catch (e) {
          print(e.toString());
        }

        isPlaying = true;
        notifyListeners();
      } else {
        isPlaying = false;
      }
      inQueue = true;
      notifyListeners();
    }
  }

  void goToPlayer(BuildContext context,
      List<PlayerSongListModel> playerSongList, int index) async {
    player.stop();
    playlist = ConcatenatingAudioSource(children: []);
    try {
      List<MediaItem> mediaItems = [];
      List<SongListModel> songListModels = [];
      // removePlaylist();
      for (var e in playerSongList) {
        songListModels.add(SongListModel(
            songId: e.id,
            albumName: e.albumName,
            title: e.title,
            musicDirectorName: e.musicDirectorName,
            imageUrl: e.imageUrl,
            songUrl: generateSongUrl(e.id),
            duration: e.duration));
        final item = MediaItem(
            id: generateSongUrl(e.id),
            album: e.albumName,
            title: e.title,
            artist: e.musicDirectorName,
            duration: Duration(milliseconds: totalDuration(e.duration)),
            artUri: Uri.parse(e.imageUrl),
            extras: {"song_id": e.id});
        playlist.add(
          AudioSource.uri(
              Uri.parse(
                generateSongUrl(e.id),
              ),
              tag: item),
        );
      }
      objectbox.removeAllQueueSong();
      objectbox.addSongListQueue(songListModels);
      player.setAudioSource(playlist);
      player.seek(Duration.zero, index: index);
      isPlaying = true;
      notifyListeners();
      play();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // Stream<QueueState> get queueState =>
  //     Rx.combineLatest3<List<MediaItem>, PlaybackState, List<int>, QueueState>(
  //         queue,
  //         playbackState,
  //         player.shuffleIndicesStream.whereType<List<int>>(),
  //         (queue, playbackState, shuffleIndices) => QueueState(
  //               queue,
  //               playbackState.queueIndex,
  //               playbackState.shuffleMode == AudioServiceShuffleMode.all
  //                   ? shuffleIndices
  //                   : null,
  //               playbackState.repeatMode,
  //             )).where((state) =>
  //         state.shuffleIndices == null ||
  //         state.queue.length == state.shuffleIndices!.length);
  play() {
    player.play();
    player.positionStream.listen((event) {
      progressDurationValue = event.inMilliseconds;
      notifyListeners();
    });
    player.durationStream.listen((event) {
      try {
        totalDurationValue = event!.inMilliseconds;
      } catch (e) {}
      notifyListeners();
    });
    player.bufferedPositionStream.listen((event) {
      bufferDurationValue = event.inMilliseconds;
    });
    player.currentIndexStream.listen((event) {
      storage.write(key: "currentIndex", value: event.toString());
    });
    player.positionStream.listen((event) {
      if (event.toString().trim() != " 0:00:00.000000".toString().trim()) {
        storage.write(key: "lastPosition", value: event.toString());
      }
    });
    player.playerStateStream.listen((event) async {
      if (event.processingState == ProcessingState.ready) {
        var metaData = player.sequenceState!
            .effectiveSequence[player.currentIndex!].tag as MediaItem;

        Map params = {"song_id": metaData.extras!["song_id"]};
        var res = await PlayerRepo().recentList(params);
        print(res.statusCode);
        print(res.body);
        if (res.statusCode == 200) {
          HomeProvider().recentSongList();
        }
      }
    });
  }

  void addSongToQueueSongList(List<PlayerSongListModel> playerSongList) async {
    print(playerSongList.length);
    try {
      List<SongListModel> songListModels = [];
      List<MediaItem> mediaItems = [];
      // removePlaylist();
      for (var e in playerSongList) {
        songListModels.add(SongListModel(
            songId: e.id,
            albumName: e.albumName,
            title: e.title,
            musicDirectorName: e.musicDirectorName,
            imageUrl: e.imageUrl,
            songUrl: generateSongUrl(e.id),
            duration: e.duration));
        var item = MediaItem(
            id: generateSongUrl(e.id),
            album: e.albumName,
            title: e.title,
            artist: e.musicDirectorName,
            duration: Duration(milliseconds: totalDuration(e.duration)),
            artUri: Uri.parse(e.imageUrl),
            extras: {"song_id": e.id});
        await playlist.add(AudioSource.uri(
            Uri.parse(
              generateSongUrl(e.id),
            ),
            tag: item));
      }
      // player.setAudioSource(playlist);
      objectbox.addSongListQueue(songListModels);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void addQueueToLocalDb(PlayerSongListModel playerSongListModel) {}
  pause() async {
    await storage.write(
        key: "currentIndex", value: player.currentIndex.toString());
    await storage.write(
        key: "lastPosition", value: player.position.inSeconds.toString());
    player.pause();
    // print(_player.currentIndex);
  }

  void playOrPause(PlayerState playerState) {
    if (playerState.playing == false) {
      play();
    } else if (playerState.playing == true &&
        playerState.processingState == ProcessingState.completed) {
      player.seek(Duration.zero, index: 0);
    } else if (playerState.playing == true) {
      pause();
    }
  }

  void getPlayListsList() async {
    isPlayListLoad = true;
    notifyListeners();

    try {
      var id = await secureStorage.read(key: "id");

      var response = await LibraryRepository().getPlayListdata(id!);

      if (response.statusCode == 200) {
        playListModel =
            PlayListModel.fromMap(jsonDecode(response.body.toString()));
        // playListNameExistList.clear();
        if (playListModel.success == true) {
          for (int i = 0; i < playListModel.totalRecords; i++) {
            // playListNameExistList.add(playListModel.records[i].playlistName);
          }
        }
      } else {
        playListModel = PlayListModel(
            success: false,
            message: "No records",
            records: [],
            totalRecords: 0);
      }
    } catch (e) {
      playListModel = PlayListModel(
          success: false, message: "No records", records: [], totalRecords: 0);
    }
    isPlayListLoad = false;

    notifyListeners();
  }

  void loopSong() {}

  void shuffleSong(bool isEnable) async {
    print(isEnable);
    shuffleSongController(isEnable);
    notifyListeners();
    // if (isEnable) {
    //   await player.shuffle();
    //   await player.setShuffleModeEnabled(true);
    // } else {
    //   await player.setShuffleModeEnabled(false);
    // }
  }

  void seekDuration(Duration duration) {
    player.seek(duration);
  }

  void playSingleSong(BuildContext context, PlayerSongListModel e) {
    print(e.albumName);
    print(e.title);
    print(e.musicDirectorName);
    print(e.id);
    player.stop();
    playlist = ConcatenatingAudioSource(children: []);

    final item = MediaItem(
        id: generateSongUrl(e.id),
        album: e.albumName,
        title: e.title,
        artist: e.musicDirectorName,
        duration: Duration(milliseconds: totalDuration(e.duration)),
        artUri: Uri.parse(e.imageUrl),
        extras: {"song_id": e.id});
    playlist.add(AudioSource.uri(
        Uri.parse(
          generateSongUrl(e.id),
        ),
        tag: item));
    player.setAudioSource(playlist);

    play();
  }

  void songInfo(String songId) async {
    issongInfoDetailsLoad = true;
    notifyListeners();
    songInfoModel = null;
    var res = await playerRepo.songInfo(songId);

    if (res.statusCode == 200) {
      songInfoModel = SongInfoModel.fromMap(jsonDecode(res.body));
    }
    issongInfoDetailsLoad = false;
    notifyListeners();
  }

  void seekToIndex(int index) {
    player.seek(Duration.zero, index: index);
  }
  // Future<void> setUpAudio() async {
  //   _audioHandler = await AudioService.init(
  //     builder: () => AudioPlayerHandler(),
  //     config: const AudioServiceConfig(
  //       androidNotificationChannelId: 'org.applogiq.musiq.audio',
  //       androidNotificationChannelName: 'MusiQ',
  //       androidNotificationOngoing: true,
  //       androidShowNotificationBadge: true,
  //       androidNotificationIcon: "mipmap/ic_launcher",
  //     ),
  //   );
  //   positionStream = await _audioHandler!.customAction('positionStream');
  //   // defaultArt = await getDefaultArt();
  //   notifyListeners();
  // }

  // loadSongIndex() async {
  //   var currentIndex = await secureStorage.read(key: "currentIndex");
  //   try {
  //     index = int.parse(currentIndex.toString());
  //     var last = await secureStorage.read(key: "lastPosition");
  //     songPosition = last!.split(":");
  //     print("songPosition[2]");
  //     print(songPosition);
  //     debugPrint(last.toString());

  //     // print(await secureStorage.read(key: "lastPosition "));
  //     notifyListeners();
  //     debugPrint(index.toString());
  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }

  // void playOrPause() {
  //   if (isPlay) {
  //     isPlay = false;
  //     _audioHandler!.pause();
  //   } else {
  //     isPlay = true;
  //     _audioHandler!.play();
  //   }
  //   notifyListeners();
  // }

  // deleteFavourite(int id, {bool isFromFav = false, BuildContext? ctx}) async {
  //   Map params = {"song_id": id};

  //   var res = await playerRepo.deleteFavourite(params);

  //   if (res.statusCode == 200) {
  //     objectbox.removeFavourite(id);
  //     if (isFromFav) {
  //       ctx!.read<LibraryProvider>().getFavouritesList();
  //     }
  //     toastMessage(
  //         "Song removed from favourite list", Colors.grey, Colors.white);
  //   } else if (res.statusCode == 404) {
  //     loadFavourites();
  //     toastMessage("Favourites not found", Colors.grey, Colors.white);
  //   }
  // }

  // addFavourite(int id) async {
  //   Map params = {"song_id": id};
  //   var res = await playerRepo.addToFavourite(params);

  //   if (res.statusCode == 200) {
  //     toastMessage("Song added to favourite list", Colors.grey, Colors.white);
  //     // addFavouriteSongToLocalDb(songId);
  //     // await favouriteSongBox.add(song);
  //   } else if (res.statusCode == 400) {
  //     // loadFavourites();

  //     toastMessage("Song already in favourite list", Colors.grey, Colors.white);
  //   }
  // }

  // void loopSong() async {
  //   if (loopStatus == 0) {
  //     loopStatus = 1;
  //     await _audioHandler!.setRepeatMode(AudioServiceRepeatMode.all);
  //   } else if (loopStatus == 1) {
  //     loopStatus = 2;
  //     await _audioHandler!.setRepeatMode(AudioServiceRepeatMode.one);
  //   } else {
  //     loopStatus = 0;

  //     await _audioHandler!.setRepeatMode(AudioServiceRepeatMode.none);
  //   }
  //   notifyListeners();
  // }

  // void shuffleSong() async {
  //   if (isShuffle == false) {
  //     await _audioHandler!.setShuffleMode(AudioServiceShuffleMode.all);
  //   } else {
  //     await _audioHandler!.setShuffleMode(AudioServiceShuffleMode.none);
  //   }
  //   isShuffle = !isShuffle;
  //   notifyListeners();
  //   // _audioHandler!.setShuffleMode(AudioServiceShuffleMode.all);
  // }

  // void seekDuration(Duration duration) {
  //   _audioHandler!.seek(duration);
  // }

  // void playSingleSong(
  //     BuildContext context, PlayerSongListModel playerSongListModel) {}

  // void songInfo(String songId) async {
  //   issongInfoDetailsLoad = true;
  //   notifyListeners();
  //   songInfoModel = null;
  //   var res = await playerRepo.songInfo(songId);

  //   if (res.statusCode == 200) {
  //     songInfoModel = SongInfoModel.fromMap(jsonDecode(res.body));
  //   }
  //   issongInfoDetailsLoad = false;
  //   notifyListeners();
  // }

  // void addSongToQueueSongList(
  //     List<PlayerSongListModel> playSongListModel) async {
  //   debugPrint("Queue");
  //   List<SongListModel> songListModels = [];
  //   for (var e in playSongListModel) {
  //     songListModels.add(SongListModel(
  //         songId: e.id,
  //         albumName: e.albumName,
  //         title: e.title,
  //         imageUrl: e.imageUrl,
  //         musicDirectorName: e.musicDirectorName,
  //         duration: e.duration,
  //         songUrl: generateSongUrl(e.id)));

  //     final item = MediaItem(
  //       id: generateSongUrl(e.id),
  //       album: e.albumName,
  //       title: e.title,
  //       artist: e.musicDirectorName,
  //       duration: Duration(milliseconds: totalDuration(e.duration)),
  //       artUri: Uri.parse(e.imageUrl),
  //     );
  //     await _audioHandler!.addQueueItem(item);
  //   }
  //   objectbox.addSongListQueue(songListModels);
  // }

  // void addQueueToLocalDb(PlayerSongListModel playerSongListModel) {}

  // void queuePlayNext(PlayerSongListModel playerSongListModel) async {
  //   final item = MediaItem(
  //     id: generateSongUrl(playerSongListModel.id),
  //     album: playerSongListModel.albumName,
  //     title: playerSongListModel.title,
  //     artist: playerSongListModel.musicDirectorName,
  //     duration:
  //         Duration(milliseconds: totalDuration(playerSongListModel.duration)),
  //     artUri: Uri.parse(playerSongListModel.imageUrl),
  //   );
  //   await _audioHandler?.insertQueueItem(1, item);
  // }

  // void queueSong(PlayerSongListModel playerSongListModel) {}
  // void goToPlayer(BuildContext context,
  //     List<PlayerSongListModel> playerSongList, int i) async {
  //   print("index");
  //   print("ddddddddddd$i");
  //   isPlaying = false;
  //   // _audioHandler!.stop();
  //   notifyListeners();
  //   // // await _audioHandler!.customAction("clearPlaylist");
  //   try {
  //     List<MediaItem> mediaItems = [];
  //     List<SongListModel> songListModels = [];
  //     for (var e in playerSongList) {
  //       final item = MediaItem(
  //           id: generateSongUrl(e.id),
  //           album: e.albumName,
  //           title: e.title,
  //           artist: e.musicDirectorName,
  //           duration: Duration(milliseconds: totalDuration(e.duration)),
  //           artUri: Uri.parse(e.imageUrl),
  //           extras: {"song_id": e.id});
  //       mediaItems.add(item);
  //       songListModels.add(SongListModel(
  //           songId: e.id,
  //           albumName: e.albumName,
  //           title: e.title,
  //           musicDirectorName: e.musicDirectorName,
  //           imageUrl: e.imageUrl,
  //           songUrl: generateSongUrl(e.id),
  //           duration: e.duration));
  //     }
  //     objectbox.removeAllQueueSong();
  //     objectbox.addSongListQueue(songListModels);

  //     objectbox.addSongListQueue(songListModels);
  //     for (var element in mediaItems) {
  //       print(element.album);
  //     }
  //     await _audioHandler!.stop();
  //     await _audioHandler!.updateQueue(mediaItems);
  //     await _audioHandler!.addQueueItems(mediaItems);
  //     await _audioHandler!.skipToQueueItem(4);
  //     await _audioHandler!.play();
  //     isPlaying = true;
  //     notifyListeners();
  //   } catch (e) {
  //     print(e.toString());
  //   }

  //   // audioHandler!.queue.listen((event) {
  //   //   event.map((e) => print(e.album));
  //   // });
  // }

  // loadFavourites() async {
  //   var id = await secureStorage.read(key: "id");
  //   LibraryRepository libraryRepository = LibraryRepository();
  //   var res = await libraryRepository.getFavouritesList(id!);
  //   if (res.statusCode == 200) {
  //     FavouriteModel favouriteModel =
  //         FavouriteModel.fromMap(jsonDecode(res.body.toString()));
  //     favouritesList.clear();
  //     for (var element in favouriteModel.records) {
  //       favouritesList.add(element.id);
  //     }
  //     notifyListeners();
  //   }
  // }

  // // This function controller repeated queue, repeated specific song multiple times and cancel repeation
  // loopSong() async {
  //   await loopSongController();
  //   notifyListeners();
  // }

  // fetchLocalFavourites() async {}
  // getPlayListsList() async {
  //   isPlayListLoad = true;
  //   notifyListeners();

  //   try {
  //     var id = await secureStorage.read(key: "id");

  //     var response = await LibraryRepository().getPlayListdata(id!);

  //     if (response.statusCode == 200) {
  //       playListModel =
  //           PlayListModel.fromMap(jsonDecode(response.body.toString()));
  //       // playListNameExistList.clear();
  //       if (playListModel.success == true) {
  //         for (int i = 0; i < playListModel.totalRecords; i++) {
  //           // playListNameExistList.add(playListModel.records[i].playlistName);
  //         }
  //       }
  //     } else {
  //       playListModel = PlayListModel(
  //           success: false,
  //           message: "No records",
  //           records: [],
  //           totalRecords: 0);
  //     }
  //   } catch (e) {
  //     playListModel = PlayListModel(
  //         success: false, message: "No records", records: [], totalRecords: 0);
  //   }
  //   isPlayListLoad = false;

  //   notifyListeners();
  // }

  // playSingleSong(
  //     BuildContext context, PlayerSongListModel playerSongList) async {
  //   playlist = ConcatenatingAudioSource(
  //     useLazyPreparation: true,
  //     children: List.generate(
  //       1,
  //       (index) => AudioSource.uri(
  //           Uri.parse(
  //               "https://api-musiq.applogiq.org/api/v1/audio?song_id=${playerSongList.id.toString()}"),
  //           tag: PlayerSongListModel(
  //               id: playerSongList.id,
  //               albumName: playerSongList.albumName,
  //               title: playerSongList.title,
  //               musicDirectorName: playerSongList.musicDirectorName.toString(),
  //               imageUrl: playerSongList.imageUrl,
  //               duration: playerSongList.duration)),
  //     ),
  //   );
  //   await player.setAudioSource(
  //     playlist,
  //     initialIndex: 0,
  //     initialPosition: Duration.zero,
  //   );
  //   player.stop();
  //   isPlay = false;
  //   isPlaying = true;
  //   playOrPause();
  //   // try {
  //   //   await clearFavouriteSong();
  //   //   await loadFavourites();
  //   // } catch (e) {
  //   //   debugPrint(e.toString());
  //   // }

  //   Navigation.navigateToScreen(context, RouteName.player);

  //   notifyListeners();
  // }

  // loadSong(PlayerModel playerModel) async {
  //   await player.setAudioSource(
  //     ConcatenatingAudioSource(
  //       useLazyPreparation: true,
  //       children: List.generate(
  //         playerModel.collectionViewAllModel.records.length,
  //         (index) => AudioSource.uri(
  //             Uri.parse(
  //                 "https://api-musiq.applogiq.org/api/v1/audio?song_id=${playerModel.collectionViewAllModel.records[index]!.id.toString()}"),
  //             tag: PlayerSongListModel(
  //                 id: playerModel.collectionViewAllModel.records[index]!.id,
  //                 albumName: playerModel
  //                     .collectionViewAllModel.records[index]!.albumName,
  //                 title: playerModel
  //                     .collectionViewAllModel.records[index]!.songName,
  //                 musicDirectorName: playerModel.collectionViewAllModel
  //                     .records[index]!.musicDirectorName![0]
  //                     .toString(),
  //                 imageUrl: generateSongImageUrl(
  //                     playerModel
  //                         .collectionViewAllModel.records[index]!.albumName,
  //                     playerModel
  //                         .collectionViewAllModel.records[index]!.albumId),
  //                 duration: playerModel
  //                     .collectionViewAllModel.records[index]!.duration)),
  //       ),
  //     ),
  //     initialIndex: playerModel.selectedSongIndex,
  //     initialPosition: Duration.zero,
  //   );
  //   player.stop();
  //   isPlay = false;
  //   playOrPause();
  //   // await clearFavouriteSong();
  //   await loadFavourites();
  //   notifyListeners();
  // }

  // void playOrPause() {
  //   if (!isPlay) {
  //     play();
  //     isPlay = true;
  //   } else {
  //     player.stop();
  //     isPlay = false;
  //   }
  //   notifyListeners();
  // }

  // queuePlayNext(PlayerSongListModel playerSongListModel) {
  //   if (player.currentIndex != null) {
  //     playlist.insert(
  //         player.currentIndex! + 1,
  //         AudioSource.uri(
  //             Uri.parse(
  //                 "https://api-musiq.applogiq.org/api/v1/audio?song_id=${playerSongListModel.id.toString()}"),
  //             tag: PlayerSongListModel(
  //                 id: playerSongListModel.id,
  //                 albumName: playerSongListModel.albumName,
  //                 title: playerSongListModel.title,
  //                 musicDirectorName: playerSongListModel.musicDirectorName,
  //                 imageUrl: playerSongListModel.imageUrl,
  //                 duration: playerSongListModel.duration)));
  //   }
  // }

  // queueSong(PlayerSongListModel playerSongListModel) {
  //   playlist.add(
  //     AudioSource.uri(
  //       Uri.parse(
  //           "https://api-musiq.applogiq.org/api/v1/audio?song_id=${playerSongListModel.id.toString()}"),
  //       tag: PlayerSongListModel(
  //           id: playerSongListModel.id,
  //           albumName: playerSongListModel.albumName,
  //           title: playerSongListModel.title,
  //           musicDirectorName: playerSongListModel.musicDirectorName,
  //           imageUrl: playerSongListModel.imageUrl,
  //           duration: playerSongListModel.duration),
  //     ),
  //   );
  // }

  // void play() {
  //   if (player.playing) {
  //     player.stop();
  //     player.play();
  //   } else {
  //     player.play();
  //   }
  //   player.positionStream.listen((event) {
  //     progressDurationValue = event.inMilliseconds;
  //     notifyListeners();
  //   });
  //   player.durationStream.listen((event) {
  //     try {
  //       totalDurationValue = event!.inMilliseconds;
  //     } catch (e) {
  //       debugPrint(e.toString());
  //     }
  //     notifyListeners();
  //   });
  //   player.bufferedPositionStream.listen((event) {
  //     bufferDurationValue = event.inMilliseconds;
  //   });
  //   player.playerStateStream.listen((event) async {
  //     if (event.processingState == ProcessingState.ready) {
  //       var metaData = player.sequenceState!
  //           .effectiveSequence[player.currentIndex!].tag as PlayerSongListModel;
  //       Map params = {"song_id": metaData.id};
  //       var res = await PlayerRepo().recentList(params);

  //       if (res.statusCode == 200) {
  //         HomeProvider().recentSongList();
  //       }
  //     }
  //   });
  // }

  // seekDuration(value) {
  //   player.seek(value);
  // }

  // void addFavourite(int songId) async {
  //   Map params = {"song_id": songId};
  //   var res = await playerRepo.addToFavourite(params);

  //   if (res.statusCode == 200) {
  //     toastMessage("Song added to favourite list", Colors.grey, Colors.white);
  //     addFavouriteSongToLocalDb(songId);
  //     // await favouriteSongBox.add(song);
  //   } else if (res.statusCode == 400) {
  //     loadFavourites();

  //     toastMessage("Song already in favourite list", Colors.grey, Colors.white);
  //   }
  // }

  // void deleteFavourite(int songId,
  //     {bool isFromFav = false, BuildContext? ctx}) async {
  //   Map params = {"song_id": songId};

  //   var res = await playerRepo.deleteFavourite(params);

  //   if (res.statusCode == 200) {
  //     objectbox.removeFavourite(songId);
  //     if (isFromFav) {
  //       ctx!.read<LibraryProvider>().getFavouritesList();
  //     }
  //     toastMessage(
  //         "Song removed from favourite list", Colors.grey, Colors.white);
  //   } else if (res.statusCode == 404) {
  //     loadFavourites();
  //     toastMessage("Favourites not found", Colors.grey, Colors.white);
  //   }
  // }

  // // deleteFavouriteSongFormLocal(int uniqueId) async {
  // //   await getApplicationDocumentsDirectory().then((Directory dir) {
  // //     store = Store(getObjectBoxModel(), directory: '${dir.path}/musiq');
  // //   });
  // //   final box = store.box<FavouriteSong>();

  // //   box.remove(uniqueId);

  // //   store.close();
  // //   getSongList();
  // // }

  // addQueueToLocalDb(
  //   PlayerSongListModel playerSongListModel,
  // ) async {
  //   // await getApplicationDocumentsDirectory().then((Directory dir) {
  //   //   store = Store(getObjectBoxModel(), directory: '${dir.path}/musiq/db/1/');
  //   final SongListModel queueSongModel = SongListModel(
  //       songId: playerSongListModel.id,
  //       albumName: playerSongListModel.albumName,
  //       title: playerSongListModel.title,
  //       musicDirectorName: playerSongListModel.musicDirectorName,
  //       imageUrl: playerSongListModel.imageUrl,
  //       songUrl:
  //           "https://api-musiq.applogiq.org/api/v1/audio?song_id=${playerSongListModel.id.toString()}",
  //       duration: playerSongListModel.duration);

  //   // objectbox.addQueue(queueSongModel);

  //   var res = objectbox.getAllQueueSong();
  //   queueIdList.clear();
  //   for (var e in res) {
  //     queueIdList.add(e.songId);
  //   }
  //   if (queueIdList.contains(playerSongListModel.id)) {
  //     normalToastMessage("Song already in queue ");
  //   } else {
  //     queueSong(playerSongListModel);
  //     objectbox.addQueue(queueSongModel);
  //     normalToastMessage("Song added to queue ");
  //   }

  //   //   store.close();
  //   //   getQueueSongList();
  //   // });
  // }

  // // getQueueSongList() async {
  // //   await getApplicationDocumentsDirectory().then((Directory dir) {
  // //     store = Store(getObjectBoxModel(), directory: '${dir.path}/musiq/db/1/');
  // //   });
  // //   final box = store.box<SongListModel>();

  // //   var res = box.getAll();
  // //   queueIdList.clear();
  // //   for (var e in res) {
  // //     queueIdList.add(e.songId);
  // //   }
  // //   notifyListeners();

  // //   store.close();
  // // }

  // addFavouriteSongToLocalDb(int songId) async {
  //   final song = FavouriteSong(songUniqueId: songId);
  //   objectbox.saveFavourite(song);
  //   // await getApplicationDocumentsDirectory().then((Directory dir) {
  //   //   store = Store(getObjectBoxModel(), directory: '${dir.path}/musiq/db/1/');
  //   // });
  //   // final box = store.box<FavouriteSong>();
  //   // box.put(song);

  //   // store.close();
  //   // getSongList();
  // }

  // // clearFavouriteSong() async {
  // //   await getApplicationDocumentsDirectory().then((Directory dir) {
  // //     store = Store(getObjectBoxModel(), directory: '${dir.path}/musiq/db/1/');
  // //   });
  // //   final box = store.box<FavouriteSong>();
  // //   box.removeAll();

  // //   store.close();
  // //   getSongList();
  // // }

  // // getSongList() async {
  // //   await getApplicationDocumentsDirectory().then((Directory dir) {
  // //     store = Store(getObjectBoxModel(), directory: '${dir.path}/musiq/db/1/');
  // //     final box = store.box<FavouriteSong>();

  // //     var res = box.getAll();
  // //     favouritesList.clear();
  // //     for (var e in res) {
  // //       favouritesList.add(e.songUniqueId);
  // //     }
  // //     store.close();
  // //   });

  // //   notifyListeners();
  // // }

  // shuffleSong() async {
  //   await shuffleSongController();
  //   notifyListeners();
  // }

  // songInfo(String songId) async {
  //   issongInfoDetailsLoad = true;
  //   notifyListeners();
  //   songInfoModel = null;
  //   var res = await playerRepo.songInfo(songId);

  //   if (res.statusCode == 200) {
  //     songInfoModel = SongInfoModel.fromMap(jsonDecode(res.body));
  //   }
  //   issongInfoDetailsLoad = false;
  //   notifyListeners();
  // }

  // addNewQueueSongList(List<PlayerSongListModel> playerSongListModel) async {
  //   // await getApplicationDocumentsDirectory().then((Directory dir) {
  //   //   store = Store(getObjectBoxModel(), directory: '${dir.path}/musiq/db/1/');
  //   //   final queueBox = store.box<SongListModel>();

  //   //   queueBox.removeAll();
  //   List<SongListModel> songlist = [];
  //   for (var e in playerSongListModel) {
  //     songlist.add(SongListModel(
  //         duration: e.duration,
  //         songId: e.id,
  //         albumName: e.albumName,
  //         title: e.title,
  //         musicDirectorName: e.musicDirectorName,
  //         imageUrl: e.imageUrl,
  //         songUrl:
  //             "https://api-musiq.applogiq.org/api/v1/audio?song_id=${e.id.toString()}"));
  //   }
  //   objectbox.addNewSongListQueue(songlist);
  //   //     queueBox.putMany(songlist);

  //   //     store.close();
  //   //     getQueueSongList();
  //   //   });
  // }

  // addSongToQueueSongList(List<PlayerSongListModel> playerSongListModel) async {
  //   List<SongListModel> songlist = [];
  //   for (var e in playerSongListModel) {
  //     playlist.add(AudioSource.uri(
  //         Uri.parse(
  //             "https://api-musiq.applogiq.org/api/v1/audio?song_id=${e.id.toString()}"),
  //         tag: PlayerSongListModel(
  //             id: e.id,
  //             albumName: e.albumName,
  //             title: e.title,
  //             musicDirectorName: e.musicDirectorName,
  //             imageUrl: e.imageUrl,
  //             duration: e.duration)));
  //     songlist.add(SongListModel(
  //         songId: e.id,
  //         albumName: e.albumName,
  //         title: e.title,
  //         musicDirectorName: e.musicDirectorName,
  //         imageUrl: e.imageUrl,
  //         songUrl:
  //             "https://api-musiq.applogiq.org/api/v1/audio?song_id=${e.id.toString()}",
  //         duration: e.duration));
  //   }
  //   objectbox.addSongListQueue(songlist);
  // }

  // loadQueueSong() async {
  //   if (!inQueue) {
  //     try {
  //       var res = objectbox.getAllQueueSong();
  //       if (res.isNotEmpty) {
  //         queueIdList.clear();
  //         List<PlayerSongListModel> playerSongList = [];
  //         for (var e in res) {
  //           playerSongList.add(PlayerSongListModel(
  //               id: e.songId,
  //               albumName: e.albumName,
  //               title: e.title,
  //               imageUrl: e.imageUrl,
  //               musicDirectorName: e.musicDirectorName,
  //               duration: e.duration));
  //           final item = MediaItem(
  //             id: generateSongUrl(e.songId),
  //             album: e.albumName,
  //             title: e.title,
  //             artist: e.musicDirectorName,
  //             duration: Duration(milliseconds: totalDuration(e.duration)),
  //             artUri: Uri.parse(e.imageUrl),
  //           );
  //           await _audioHandler!.addQueueItem(item);
  //         }
  //         await _audioHandler!.play();
  //         // playlist = ConcatenatingAudioSource(
  //         //   useLazyPreparation: true,
  //         //   children: List.generate(
  //         //     playerSongList.length,
  //         //     (index) => AudioSource.uri(
  //         //         Uri.parse(
  //         //             "https://api-musiq.applogiq.org/api/v1/audio?song_id=${playerSongList[index].id.toString()}"),
  //         //         tag: PlayerSongListModel(
  //         //             id: playerSongList[index].id,
  //         //             albumName: playerSongList[index].albumName,
  //         //             title: playerSongList[index].title,
  //         //             musicDirectorName:
  //         //                 playerSongList[index].musicDirectorName.toString(),
  //         //             imageUrl: playerSongList[index].imageUrl,
  //         //             duration: playerSongList[index].duration)),
  //         //   ),
  //         // );

  //         // await player.setAudioSource(
  //         //   playlist,
  //         //   initialIndex: 0,
  //         //   initialPosition: Duration.zero,
  //         // );
  //         // player.stop();
  //         // isPlay = true;
  //         isPlaying = true;

  //         // playOrPause();
  //         // store.close();
  //       }
  //       inQueue = true;
  //       // init();
  //       // notifyListeners();
  //     } catch (e) {
  //       debugPrint(e.toString());
  //     }
  //   }
  // }

  // loadSingleQueueSong() async {
  //   // AudioPlayerHandler().load();
  //   // if (!inQueue) {
  //   //   // try {
  //   //   // await getApplicationDocumentsDirectory().then((Directory dir) async {
  //   //   //   store =
  //   //   //       Store(getObjectBoxModel(), directory: '${dir.path}/musiq/db/1/');
  //   //   //   final box = store.box<SongListModel>();

  //   var res = objectbox.getAllQueueSong();
  //   log("SFDgfg --- ${res.length}");

  //   if (res.isNotEmpty) {
  //     queueIdList.clear();
  //     List<PlayerSongListModel> playerSongList = [];
  //     var e = res.first;
  //     // for (var e in res) {
  //     playerSongList.add(PlayerSongListModel(
  //         id: e.songId,
  //         albumName: e.albumName,
  //         title: e.title,
  //         imageUrl: e.imageUrl,
  //         musicDirectorName: e.musicDirectorName,
  //         duration: e.duration));
  //     // AudioPlayerHandler playerHandler = AudioPlayerHandler();
  //     // playerHandler.setSongToPlayer(playerSongList.first);
  //   }
  //   //     // AudioPlayerHandler().setSongToPlayer(playerSongList.first);
  //   //     // }
  //   //     // playlist = ConcatenatingAudioSource(
  //   //     //   useLazyPreparation: true,
  //   //     //   children: List.generate(
  //   //     //     playerSongList.length,
  //   //     //     (index) => AudioSource.uri(
  //   //     //         Uri.parse(
  //   //     //             "https://api-musiq.applogiq.org/api/v1/audio?song_id=${playerSongList[index].id.toString()}"),
  //   //     //         tag: PlayerSongListModel(
  //   //     //             id: playerSongList[index].id,
  //   //     //             albumName: playerSongList[index].albumName,
  //   //     //             title: playerSongList[index].title,
  //   //     //             musicDirectorName:
  //   //     //                 playerSongList[index].musicDirectorName.toString(),
  //   //     //             imageUrl: playerSongList[index].imageUrl)),
  //   //     //   ),
  //   //     // );
  //   //     // await player.setAudioSource(
  //   //     //   playlist,
  //   //     //   initialIndex: 0,
  //   //     //   initialPosition: Duration.zero,
  //   //     // );
  //   //     // player.stop();
  //   //     // isPlay = true;
  //   //     // isPlaying = true;

  //   //     // playOrPause();
  //   //     // store.close();
  //   //     //     }
  //   //     //   });

  //   //     //   // try {
  //   //     //   //   await clearFavouriteSong();
  //   //     //   //   await loadFavourites();
  //   //     //   // } catch (e) {
  //   //     //   //   store.close();
  //   //     //   // }
  //   //     //   // inQueue = true;
  //   //     //   // notifyListeners();
  //   //     // } catch (e) {
  //   //     //   store.close();
  //   //     //   debugPrint(e.toString());
  //   //     // }
  //   //   }
  //   // }

  //   // loadAudioHandler() async {
  //   //   if (!inQueue) {
  //   //     await getApplicationDocumentsDirectory().then((Directory dir) async {
  //   //       store = Store(getObjectBoxModel(), directory: '\$\{dir\.path\}/musiq/db/1');
  //   //       final box = store.box<SongListModel>();

  //   //       var res = box.getAll();
  //   //       log("SFDgfg --- ${res.length}");

  //   //       if (res.isNotEmpty) {
  //   //         final mediaItems = res
  //   //             .map((song) => MediaItem(
  //   //                   id: song.id.toString() ?? '',
  //   //                   album: song.albumName ?? '',
  //   //                   title: song.title ?? '',
  //   //                   extras: {'url': song.songUrl},
  //   //                 ))
  //   //             .toList();
  //   //         _audioHandler.addQueueItems(mediaItems);
  //   //         // playerSongList.add(PlayerSongListModel(
  //   //         //     id: e.songId,
  //   //         //     albumName: e.albumName,
  //   //         //     title: e.title,
  //   //         //     imageUrl: e.imageUrl,
  //   //         //     musicDirectorName: e.musicDirectorName));

  //   //       }

  //   //       // if (res.isNotEmpty) {
  //   //       //   queueIdList.clear();
  //   //       //   List<PlayerSongListModel> playerSongList = [];
  //   //       //   for (var e in res) {
  //   //       //     print(e.songId);
  //   //       //     playerSongList.add(PlayerSongListModel(
  //   //       //         id: e.songId,
  //   //       //         albumName: e.albumName,
  //   //       //         title: e.title,
  //   //       //         imageUrl: e.imageUrl,
  //   //       //         musicDirectorName: e.musicDirectorName));
  //   //       //   }
  //   //       //   playlist = ConcatenatingAudioSource(
  //   //       //     useLazyPreparation: true,
  //   //       //     children: List.generate(
  //   //       //       playerSongList.length,
  //   //       //       (index) => AudioSource.uri(
  //   //       //           Uri.parse(
  //   //       //               "https://api-musiq.applogiq.org/api/v1/audio?song_id=${playerSongList[index].id.toString()}"),
  //   //       //           tag: PlayerSongListModel(
  //   //       //               id: playerSongList[index].id,
  //   //       //               albumName: playerSongList[index].albumName,
  //   //       //               title: playerSongList[index].title,
  //   //       //               musicDirectorName:
  //   //       //                   playerSongList[index].musicDirectorName.toString(),
  //   //       //               imageUrl: playerSongList[index].imageUrl)),
  //   //       //     ),
  //   //       //   );
  //   //       //   await player.setAudioSource(
  //   //       //     playlist,
  //   //       //     initialIndex: 0,
  //   //       //     initialPosition: Duration.zero,
  //   //       //   );
  //   //       //   player.stop();
  //   //       //   isPlay = true;
  //   //       //   isPlaying = true;

  //   //       //   playOrPause();
  //   //       //   store.close();
  //   //       // }
  //   //     });

  //   //     inQueue = true;
  //   //     notifyListeners();
  //   //   }
  //   // }
  // }
}
