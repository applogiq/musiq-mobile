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
              duration: e.duration,
              premium: ''));
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
          print("TRY init");
          print(songPositionList);
          print(songPositionSeconds);
          if (songPositionSeconds.isNotEmpty && songPositionList.isNotEmpty) {
            player.seek(
                Duration(
                    hours: int.parse(songPositionList[0]),
                    minutes: int.parse(songPositionList[1]),
                    seconds: int.parse(songPositionSeconds[0])),
                index: int.parse(index!));
          }
          print("TRY dispose");
        } catch (e) {
          print("TRY cancel");

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
        if (e.premium == "free") {
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
}
