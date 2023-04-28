// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musiq/src/core/constants/color.dart';
import 'package:musiq/src/core/extensions/context_extension.dart';
import 'package:musiq/src/core/local/model/favourite_model.dart';
import 'package:musiq/src/core/package/we_slide/we_slide.dart';
import 'package:musiq/src/features/home/provider/view_all_provider.dart';
import 'package:musiq/src/features/library/domain/models/favourite_model.dart';
import 'package:musiq/src/features/player/domain/model/player_song_list_model.dart';
import 'package:musiq/src/features/player/domain/model/song_info_model.dart';
import 'package:musiq/src/features/player/domain/repo/player_repo.dart';
import 'package:musiq/src/features/player/provider/extension/player_controls_extension.dart';
import 'package:musiq/src/features/player/screen/player_screen/player_screen.dart';
import 'package:provider/provider.dart';

import '../../../../main.dart';
import '../../../core/enums/enums.dart';
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
  const QueueState(
      this.queue, this.queueIndex, this.shuffleIndices, this.repeatMode);

  static const QueueState empty =
      QueueState([], 0, [], AudioServiceRepeatMode.none);

  final List<MediaItem> queue;
  final int? queueIndex;
  final AudioServiceRepeatMode repeatMode;
  final List<int>? shuffleIndices;

  bool get hasPrevious =>
      repeatMode != AudioServiceRepeatMode.none || (queueIndex ?? 0) > 0;

  bool get hasNext =>
      repeatMode != AudioServiceRepeatMode.none ||
      (queueIndex ?? 0) + 1 < queue.length;

  List<int> get indices =>
      shuffleIndices ?? List.generate(queue.length, (i) => i);
}

class PlayerProvider extends ChangeNotifier {
  var bufferDurationValue = 0;
  Stream<int>? currentIndex = const Stream.empty();
  List<int> favouritesList = [];
  int? globalIndex;
  List<MediaItem> globalQueue = [];
  bool inQueue = false;
  int index = 2;
  bool isPlay = false;
  bool isPlayListLoad = true;
  bool isPlaying = false;
  bool isPlayingLoad = false;
  bool isRecentlyAPICalled = false;
  bool isShuffle = false;
  bool isUpNextShow = false;
  bool issongInfoDetailsLoad = true;
  int loopStatus = 0;
  var header = {'icy-br': '10'};

  final WeSlideController controller = WeSlideController();

  Color miniPlayerBackground = CustomColor.miniPlayerBackgroundColors[0];
  PlayListModel playListModel = PlayListModel(
      success: false, message: "No records", records: [], totalRecords: 0);

  AudioPlayer player = AudioPlayer();
  PlayerRepo playerRepo = PlayerRepo();
  ConcatenatingAudioSource playlist = ConcatenatingAudioSource(children: []);
  Stream<Duration>? positionStream = const Stream.empty();
  var progressDurationValue = 0;
  List<int> queueIdList = [];
  FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  var selectedIndex = 0;
  SongInfoModel? songInfoModel;
  List songPosition = [];
  FlutterSecureStorage storage = const FlutterSecureStorage();
  var totalDurationValue = 0;

  AudioHandler? _audioHandler;

  void toggleUpNext() {
    isUpNextShow = !isUpNextShow;
    notifyListeners();
  }

  AudioHandler? get audioHandler => _audioHandler;

  iscurrentIndex() {
    return player.currentIndex.toString();
  }

//Add song to queue in play next
  void queuePlayNext(PlayerSongListModel playerSongListModel) {
    log("jilla");
    if (player.currentIndex != null) {
      log("thalaiva");

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
          AudioSource.uri(Uri.parse(item.id), tag: item, headers: header));
    }
  }

// Get favourite song list details
  getFavourites() async {
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
      {required bool isFromFav,
      required BuildContext ctx,
      required BuildContext mainContext}) async {
    Map params = {"song_id": id};

    var res = await playerRepo.deleteFavourite(params);

    if (res.statusCode == 200) {
      objectbox.removeFavourite(id);
      print("1");
      if (isFromFav) {
        print("2");

        if (ctx.mounted) {
          ctx.read<LibraryProvider>().getFavouritesList();
        }
        print("1");

        if (mainContext.mounted) {
          mainContext.read<LibraryProvider>().getFavouritesList();
        }
      }
      toastMessage(
          "Song removed from favorite list", Colors.grey, Colors.white);
    } else if (res.statusCode == 404) {
      //  loadFavourites();
      toastMessage("Favorites not found", Colors.grey, Colors.white);
    }
  }

// Add single song to queue
  void queueSong(PlayerSongListModel e) async {
    log("11111111111111111111111111111");
    log("222222222222222222222222222");
    log("11111111111111111111111111111");
    log("11111111111111111111111111111");
    log("11111111111111111111111111111");
    log("11111111111111111111111111111");
    log("11111111111111111111111111111");
    log("11111111111111111111111111111");
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
    } catch (e) {
      debugPrint(e.toString());
    }
  }

// Add song to favourite
  void addFavourite(int id) async {
    Map params = {"song_id": id};
    var res = await playerRepo.addToFavourite(params);

    if (res.statusCode == 200) {
      toastMessage("Song added to favorite list", Colors.grey, Colors.white);
      objectbox.addFavouritesSong(FavouriteSong(songUniqueId: id));
    } else if (res.statusCode == 400) {
      // loadFavourites();

      toastMessage("Song already in favorite list", Colors.grey, Colors.white);
    }
  }

// Load queue from local db
  loadQueueSong(BuildContext context) async {
    if (!inQueue) {
      await getFavourites();
      var index = await secureStorage.read(key: "currentIndex");
      print(index);
      print("currentIndex");
      print("😍😍😍😍😍😍😍");

      print(index);
      print("😍😍😍😍😍😍😍");

      var songPosition = await secureStorage.read(key: "lastPosition");
      isPlaying = false;
      notifyListeners();
      print("🤣🤣🤣🤣🤣🤣🤣🤣🤣🤣🤣🤣");
      print(songPosition);
      print("🤣🤣🤣🤣🤣🤣🤣🤣🤣🤣🤣🤣");

      List songPositionList = [];
      List songPositionSeconds = [];
      if (songPosition != null) {
        songPositionList = songPosition.toString().split(":");
        print(songPositionSeconds);
        if (songPositionList.isNotEmpty) {
          songPositionSeconds = songPositionList[2].toString().split(".");
        }
      }
      var res = objectbox.getAllQueueSong();
      print("........................");
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
                tag: item,
                headers: header),
          );
        }
        player.setAudioSource(playlist);
        try {
          print("TRY init");
          print(songPositionList);
          print(songPositionSeconds);
          if (songPositionList.isNotEmpty) {
            player.seek(
                Duration(
                    hours: int.parse(songPositionList[0]),
                    minutes: int.parse(songPositionList[1]),
                    seconds: songPositionSeconds.isEmpty
                        ? 0
                        : int.parse(songPositionSeconds[0])),
                index: int.parse(index!));
          } else {
            player.seek(Duration.zero, index: int.parse(index!));
          }
        } catch (e) {
          debugPrint(e.toString());
          player.seek(Duration.zero, index: int.parse(index!));
        }

        if (context.mounted) {
          await play(context);
          await player.pause();
          // await player.stop();
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
      if (player.playing) {
        await player.stop();
      }

      isPlayingLoad = true;
      notifyListeners();
      playlist = ConcatenatingAudioSource(children: []);

      List<SongListModel> songListModels = [];
      // // removePlaylist();
      // // for (var e in playerSongList) {
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
                tag: item,
                headers: header),
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
                tag: item,
                headers: header),
          );
        } else {
          if (i <= index) {
            index--;
          }
        }
      }
      print(songListModels.map((e) => e.title));
      objectbox.removeAllQueueSong();
      objectbox.addSongListQueue(songListModels);
      await player.setAudioSource(playlist);

      await player.seek(Duration.zero, index: index);
      if (context.mounted) {
        play(context);
      }
      // player.play();
      isPlayingLoad = false;
      isPlaying = true;
      notifyListeners();
    } catch (e) {
      print("error");
      debugPrint(e.toString());
    }
  }

// Play method for playing current playlist song
  play(BuildContext context) async {
    try {
      await player.play();

      player.positionStream.listen((event) {
        try {
          progressDurationValue = event.inMilliseconds;
          // log(progressDurationValue.to);
          notifyListeners();
        } catch (e) {
          print("position stream");
          debugPrint(e.toString());
        }
      });
      player.durationStream.listen((event) {
        if (event != null) {
          try {
            totalDurationValue = event.inMilliseconds;
            notifyListeners();
          } catch (e) {
            print("duration stream");

            debugPrint(e.toString());
          }
        }
      });
      player.bufferedPositionStream.listen((event) {
        try {
          bufferDurationValue = event.inMilliseconds;
        } catch (e) {
          print("buffered stream");
        }
      });
      player.currentIndexStream.listen((event) async {
        player.positionStream.listen((e) async {
          if (e.toString().trim() == " 0:00:05.000000".toString().trim()) {
            try {
              if (context.mounted) {
                if (player.currentIndex != null) {
                  try {
                    miniPlayerBackground =
                        CustomColor.miniPlayerBackgroundColors[
                            player.currentIndex! %
                                CustomColor.miniPlayerBackgroundColors.length];
                  } catch (e) {
                    miniPlayerBackground =
                        CustomColor.miniPlayerBackgroundColors[0];
                  }
                  notifyListeners();
                }
              }
              int index = player.shuffleModeEnabled
                  ? player.shuffleIndices!.indexOf(player.currentIndex!)
                  : player.currentIndex!;
              var metaData = player.sequenceState!.effectiveSequence[index].tag
                  as MediaItem;

              Map params = {"song_id": metaData.extras!["song_id"]};
              var res = await PlayerRepo().recentList(params);
              print(res.body);
              if (res.statusCode == 200) {
                log("EEEeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee");
                if (context.mounted) {
                  context.read<HomeProvider>().recentSongList();

                  log("mysong");
                }
                try {
                  print("SSS");
                  context
                      .read<ViewAllProvider>()
                      .getViewAll(ViewAllStatus.recentlyPlayed);
                  // ignore: empty_catches
                } catch (e) {}
              }
              await storage.write(key: "currentIndex", value: event.toString());
            } catch (e) {
              print("index stream");

              debugPrint(e.toString());
            }
          }
        });
      });
      player.positionStream.listen((event) async {
        try {
          print(player.currentIndex.toString());
          print("❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️");
          print(event.toString().trim() != "0:00:00.000000".toString().trim());
          if (event.toString().trim() != "0:00:00.000000".toString().trim()) {
            await storage.write(key: "lastPosition", value: event.toString());
            await storage.write(
                key: "currentIndex", value: player.currentIndex.toString());
          }
        } catch (e) {
          print("position2 stream");

          debugPrint(e.toString());
        }
      });
      bool apiCallMade = false;
      player.playerStateStream.listen((event) async {
        try {
          if (event.processingState == ProcessingState.ready && !apiCallMade) {
            var metaData = player.sequenceState!
                .effectiveSequence[player.currentIndex!].tag as MediaItem;

            Map params = {"song_id": metaData.extras!["song_id"]};
            var res = await PlayerRepo().recentList(params);

            if (res.statusCode == 200) {
              apiCallMade = true;
              notifyListeners();
              if (context.mounted) {
                log("ffffffffffffffffffffffffffffffffffffffffff");

                context.read<HomeProvider>().recentSongList();
              }
            }
          }
        } catch (e) {
          print("player stream");

          debugPrint(e.toString());
        }
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void addSongToQueueSongList(
      List<PlayerSongListModel> playerSongList, BuildContext context) async {
    print(playerSongList.length);
    var objectBoxSongs = objectbox.getAllQueueSong();
    List addSongIdList = [];
    for (var i in objectBoxSongs) {
      print(i.songId);
      addSongIdList.add(i.songId);
    }
    try {
      List<SongListModel> songListModels = [];

      for (var e in playerSongList) {
        if (e.premium == "premium" &&
            context.read<LoginProvider>().userModel!.records.premiumStatus ==
                "free") {
        } else {
          if (addSongIdList.contains(e.id)) {
            toastMessage("Playlist already added", Colors.white, Colors.black);
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
                tag: item,
                headers: header));
          }
        }
      }

      // objectbox.addSongListQueue(songListModels);
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
  playSingleSong(BuildContext context, PlayerSongListModel e) {
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
        extras: {"song_id": e.id, "isImage": e.isImage});
    playlist.add(AudioSource.uri(
        Uri.parse(
          generateSongUrl(e.id),
        ),
        tag: item,
        headers: header));
    player.setAudioSource(playlist);

    play(context);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PlayerScreen(onTap: () {
                  Navigator.pop(context);
                })));
    isPlayingLoad = false;
    isPlaying = true;
    notifyListeners();
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

  // Set addedSongs = {};
  addQueueToLocalDb(PlayerSongListModel e, BuildContext context) async {
    log("789");
    var objectBoxSongs = objectbox.getAllQueueSong();
    List addSongIdList = [];
    for (var i in objectBoxSongs) {
      print(i.songId);
      addSongIdList.add(i.songId);
    }
    print("🙌🙌🙌🙌");
    print(addSongIdList);
    print("😂😂😂😂");

    print(e.id);
    try {
      List<SongListModel> songListModels = [];
      List<PlayerSongListModel> addQueues = [];
      if (addSongIdList.contains(e.id)) {
        log("already added song");

        // Song already exists in the player queue
        toastMessage("Song already added", Colors.white, Colors.black);
      } else {
        log("already not added song");

        try {
          // addQueues.add(e);
          addSongIdList.add(e.id.toString());

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

          context
              .read<PlayerProvider>()
              .addSongToQueueSongList(addQueues, context);
          notifyListeners();
          log("879.......................");
        } catch (e) {
          log("10,11,12");

          debugPrint(e.toString());
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  deleteInQueue(int index, BuildContext context, PlayerSongListModel e) {
    context.read<PlayerProvider>().deleteSongInQueue(index);
    objectbox.removeQueueSong(e.id);
    notifyListeners();
  }

  // init() async {
  //   final session = await AudioSession.instance;
  //   await session.configure(const AudioSessionConfiguration.music());
  //   try {
  //     // var ram = AudioSource.uri(
  //     //   Uri.parse(
  //     //     generateSongUrl(9),
  //     //   ),
  //     // );
  //     // for (int i = 0; i <= player.androidAudioSessionId!; i++) {
  //     //   log(i.toString());

  //     // }
  //     // var item = MediaItem(id: generateSongUrl(e.id), title: e.title);
  //     // player.setAudioSource(item);
  //     // log(player.setAudioSource(playlist).toString());
  //     for (int i = 0;
  //         i <= await player.androidAudioSessionIdStream;
  //         i++) {
  //       var ram = AudioSource.uri(
  //         Uri.parse(
  //           generateSongUrl(i),
  //         ),
  //       );
  //       return await player.setAudioSource(ram);
  //     }
  //     // return
  //   } catch (e) {
  //     print("Error loading audio source: $e");
  //   }
  // }
}
