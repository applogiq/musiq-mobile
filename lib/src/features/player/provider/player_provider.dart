import 'dart:convert';
import 'dart:developer';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musiq/src/core/extensions/context_extension.dart';
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
import '../../auth/provider/login_provider.dart';
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
  bool isRecentlyAPICalled = false;
  void toggleUpNext() {
    isUpNextShow = !isUpNextShow;
    notifyListeners();
  }

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

//Add song to queue in play next
  void queuePlayNext(PlayerSongListModel playerSongListModel) {
    if (player.currentIndex != null) {
      final item = MediaItem(
          id: generateSongUrl(playerSongListModel.id),
          album: playerSongListModel.albumName,
          title: playerSongListModel.title,
          artist: playerSongListModel.musicDirectorName,
          duration: Duration(
              milliseconds: totalDuration(playerSongListModel.duration)),
          artUri: Uri.parse(playerSongListModel.imageUrl),
          extras: {
            "song_id": playerSongListModel.id,
            "isImage": playerSongListModel.isImage
          });
      playlist.insert(player.currentIndex! + 1,
          AudioSource.uri(Uri.parse(item.id), tag: item));
    }
  }

// Get favourite song list details
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

// Delete favourite song
  void deleteFavourite(int id,
      {required bool isFromFav, required BuildContext ctx}) async {
    Map params = {"song_id": id};

    var res = await playerRepo.deleteFavourite(params);

    if (res.statusCode == 200) {
      objectbox.removeFavourite(id);
      if (isFromFav) {
        if (ctx.mounted) {
          ctx.read<LibraryProvider>().getFavouritesList();
        }
      }
      toastMessage(
          "Song removed from favourite list", Colors.grey, Colors.white);
    } else if (res.statusCode == 404) {
      //  loadFavourites();
      toastMessage("Favourites not found", Colors.grey, Colors.white);
    }
  }

// Add single song to queue
  void queueSong(PlayerSongListModel e) async {
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
    } catch (e) {
      debugPrint(e.toString());
    }
  }

// Add song to favourite
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

// Load queue from local db
  loadQueueSong() async {
    if (!inQueue) {
      await getFavourites();
      var index = await secureStorage.read(key: "currentIndex");
      var songPosition = await secureStorage.read(key: "lastPosition");
      isPlaying = false;
      notifyListeners();
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
              premium: '',
              isImage: e.isImage));
          final item = MediaItem(
              id: generateSongUrl(e.songId),
              album: e.albumName,
              title: e.title,
              artist: e.musicDirectorName,
              duration: Duration(milliseconds: totalDuration(e.duration)),
              artUri: Uri.parse(e.imageUrl),
              extras: {"song_id": e.songId, "isImage": e.isImage});
          playlist.add(
            AudioSource.uri(
                Uri.parse(
                  generateSongUrl(e.songId),
                ),
                tag: item),
          );
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
        } catch (e) {
          debugPrint(e.toString());
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
    try {
      player.stop();
      playlist = ConcatenatingAudioSource(children: []);

      List<SongListModel> songListModels = [];
      // removePlaylist();
      // for (var e in playerSongList) {
      for (int i = 0; i < playerSongList.length; i++) {
        var e = playerSongList[i];
        if (e.premium == "free") {
          songListModels.add(SongListModel(
              songId: e.id,
              albumName: e.albumName,
              title: e.title,
              musicDirectorName: e.musicDirectorName,
              imageUrl: e.imageUrl,
              songUrl: generateSongUrl(e.id),
              duration: e.duration,
              isImage: e.isImage));
          final item = MediaItem(
              id: generateSongUrl(e.id),
              album: e.albumName,
              title: e.title,
              artist: e.musicDirectorName,
              duration: Duration(milliseconds: totalDuration(e.duration)),
              artUri: Uri.parse(e.imageUrl),
              extras: {"song_id": e.id, "isImage": e.isImage});
          playlist.add(
            AudioSource.uri(
                Uri.parse(
                  generateSongUrl(e.id),
                ),
                tag: item),
          );
        } else if (context
                .read<LoginProvider>()
                .userModel!
                .records
                .premiumStatus !=
            "free") {
          songListModels.add(
            SongListModel(
                songId: e.id,
                albumName: e.albumName,
                title: e.title,
                musicDirectorName: e.musicDirectorName,
                imageUrl: e.imageUrl,
                songUrl: generateSongUrl(e.id),
                duration: e.duration,
                isImage: e.isImage),
          );
          final item = MediaItem(
            id: generateSongUrl(e.id),
            album: e.albumName,
            title: e.title,
            artist: e.musicDirectorName,
            duration: Duration(
              milliseconds: totalDuration(e.duration),
            ),
            artUri: Uri.parse(e.imageUrl),
            extras: {"song_id": e.id, "isImage": e.isImage},
          );
          playlist.add(
            AudioSource.uri(
                Uri.parse(
                  generateSongUrl(e.id),
                ),
                tag: item),
          );
        } else {
          if (i <= index) {
            index--;
          }
        }
      }

      objectbox.removeAllQueueSong();
      objectbox.addSongListQueue(songListModels);
      player.setAudioSource(playlist);
      player.seek(Duration.zero, index: index);

      isPlaying = true;
      notifyListeners();
      play(context);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

// Play method for playing current playlist song
  play(BuildContext context) {
    try {
      player.play();
      // player.playbackEventStream.listen((event) async {
      //   if (event.processingState == ProcessingState.ready) {
      //     var metaData = player.sequenceState!
      //         .effectiveSequence[player.currentIndex!].tag as MediaItem;
      //     if (isRecentlyAPICalled == false) {
      //       isRecentlyAPICalled = true;
      //       notifyListeners();

      //       print(
      //           "33333333333fdffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff333333");
      //       print(
      //           "333f888888888888888888888888888888888****************************************************dgghfhgfj33333333333333");
      //       Map params = {"song_id": metaData.extras!["song_id"]};
      //       var res = await PlayerRepo().recentList(params);
      //       isRecentlyAPICalled = false;
      //       notifyListeners();
      //       if (res.statusCode == 200) {
      //         if (context.mounted) {
      //           context.read<HomeProvider>().recentSongList();
      //         }
      //       }
      //     }
      //   }
      // });
      player.positionStream.listen((event) {
        progressDurationValue = event.inMilliseconds;
        notifyListeners();
      });
      player.durationStream.listen((event) {
        try {
          totalDurationValue = event!.inMilliseconds;
        } catch (e) {
          debugPrint(e.toString());
        }
        notifyListeners();
      });
      player.bufferedPositionStream.listen((event) {
        bufferDurationValue = event.inMilliseconds;
      });
      player.currentIndexStream.listen((event) async {
        print("_______________________________");
        print(event.toString());
        var metaData = player.sequenceState!
            .effectiveSequence[player.currentIndex!].tag as MediaItem;

        Map params = {"song_id": metaData.extras!["song_id"]};
        var res = await PlayerRepo().recentList(params);
        print(res.body);
        if (res.statusCode == 200) {
          if (context.mounted) {
            context.read<HomeProvider>().recentSongList();
          }
        }
        await storage.write(key: "currentIndex", value: event.toString());
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
          print("33333333333333333");
          print("333fdgghfhgfj33333333333333");
          Map params = {"song_id": metaData.extras!["song_id"]};
          var res = await PlayerRepo().recentList(params);

          if (res.statusCode == 200) {
            if (context.mounted) {
              context.read<HomeProvider>().recentSongList();
            }
          }
        }
      });
    } catch (e) {
      print("SSSSSSSSSSSSSSSSSSSSfffffffffff");
      debugPrint(e.toString());
    }
  }

  void addSongToQueueSongList(
      List<PlayerSongListModel> playerSongList, BuildContext context) async {
    print(playerSongList.length);
    try {
      List<SongListModel> songListModels = [];

      for (var e in playerSongList) {
        if (e.premium == "premium" &&
            context.read<LoginProvider>().userModel!.records.premiumStatus ==
                "free") {
        } else {
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
        }
      }

      objectbox.addSongListQueue(songListModels);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

//  Pause the playing song
  pause() async {
    await storage.write(
        key: "currentIndex", value: player.currentIndex.toString());
    await storage.write(
        key: "lastPosition", value: player.position.inSeconds.toString());
    player.pause();
  }

// Play and pause player
  void playOrPause(PlayerState playerState, BuildContext context) {
    if (playerState.playing == false) {
      play(context);
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

// Player song shuffle enable or disable
  void shuffleSong(bool isEnable) async {
    print(isEnable);
    shuffleSongController(isEnable);
    notifyListeners();
  }

// Seek song duration
  void seekDuration(Duration duration) {
    player.seek(duration);
  }

// Play tapped song in search screen
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

    play(context);
  }

// Get song info details
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

// Play specific song
  void seekToIndex(int index) {
    player.seek(Duration.zero, index: index);
  }

  void addQueueToLocalDb(PlayerSongListModel playerSongListModel) {}
}
