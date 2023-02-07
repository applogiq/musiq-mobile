// ignore_for_file: use_build_context_synchronously
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musiq/main.dart';
import 'package:musiq/src/core/local/model/favourite_model.dart';
import 'package:musiq/src/core/local/model/queue_model.dart';
import 'package:musiq/src/core/routing/route_name.dart';
import 'package:musiq/src/core/utils/navigation.dart';
import 'package:musiq/src/core/utils/toast_message.dart';
import 'package:musiq/src/core/utils/url_generate.dart';
import 'package:musiq/src/features/library/domain/models/favourite_model.dart';
import 'package:musiq/src/features/library/provider/library_provider.dart';
import 'package:musiq/src/features/player/domain/model/player_song_list_model.dart';
import 'package:musiq/src/features/player/domain/model/song_info_model.dart';
import 'package:musiq/src/features/player/domain/repo/player_repo.dart';
import 'package:musiq/src/features/player/provider/player_provider.dart';
import 'package:musiq/src/features/view_all/domain/model/player_model.dart';
import 'package:provider/provider.dart';

import '../../../core/package/miniplayer/miniplayer.dart';
import '../../home/provider/home_provider.dart';
import '../../library/domain/library_repo.dart';
import '../../library/domain/models/playlist_model.dart';

export "extension/player_controls_extension.dart";
export "extension/player_local_db_controller_extension.dart";

class PlayerProvider extends ChangeNotifier {
  final MiniplayerController controller = MiniplayerController();
  // AudioPlayerHandler audioPlayerHandler = AudioPlayerHandler();
  bool isPlay = false;
  bool isPlaying = false;
  bool isShuffle = false;
  bool issongInfoDetailsLoad = true;
  int loopStatus = 0;
  bool inQueue = false;
  bool isUpNextShow = false;
  void toggleUpNext() {
    isUpNextShow = !isUpNextShow;
    notifyListeners();
  }

  // late Store store;
  List<int> favouritesList = [];
  List<int> queueIdList = [];
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

  // This function controller repeated queue, repeated specific song multiple times and cancel repeation
  loopSong() async {
    await loopSongController();
    notifyListeners();
  }

  fetchLocalFavourites() async {}
  getPlayListsList() async {
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

  void goToPlayer(BuildContext context,
      List<PlayerSongListModel> playerSongList, int index) async {
    try {
      await addNewQueueSongList(playerSongList);
      playlist = ConcatenatingAudioSource(
        useLazyPreparation: true,
        children: List.generate(
          playerSongList.length,
          (index) => AudioSource.uri(
              Uri.parse(
                  "https://api-musiq.applogiq.org/api/v1/audio?song_id=${playerSongList[index].id.toString()}"),
              tag: PlayerSongListModel(
                  id: playerSongList[index].id,
                  albumName: playerSongList[index].albumName,
                  title: playerSongList[index].title,
                  musicDirectorName:
                      playerSongList[index].musicDirectorName.toString(),
                  imageUrl: playerSongList[index].imageUrl,
                  duration: playerSongList[index].duration)),
        ),
      );
      await player.setAudioSource(
        playlist,
        initialIndex: index,
        initialPosition: Duration.zero,
      );
      player.stop();
      isPlay = false;
      isPlaying = true;
      playOrPause();
      // try {
      //   await clearFavouriteSong();
      //   await loadFavourites();
      // } catch (e) {
      //   debugPrint(e.toString());
      // }

      Navigation.navigateToScreen(context, RouteName.player);

      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  playSingleSong(
      BuildContext context, PlayerSongListModel playerSongList) async {
    playlist = ConcatenatingAudioSource(
      useLazyPreparation: true,
      children: List.generate(
        1,
        (index) => AudioSource.uri(
            Uri.parse(
                "https://api-musiq.applogiq.org/api/v1/audio?song_id=${playerSongList.id.toString()}"),
            tag: PlayerSongListModel(
                id: playerSongList.id,
                albumName: playerSongList.albumName,
                title: playerSongList.title,
                musicDirectorName: playerSongList.musicDirectorName.toString(),
                imageUrl: playerSongList.imageUrl,
                duration: playerSongList.duration)),
      ),
    );
    await player.setAudioSource(
      playlist,
      initialIndex: 0,
      initialPosition: Duration.zero,
    );
    player.stop();
    isPlay = false;
    isPlaying = true;
    playOrPause();
    // try {
    //   await clearFavouriteSong();
    //   await loadFavourites();
    // } catch (e) {
    //   debugPrint(e.toString());
    // }

    Navigation.navigateToScreen(context, RouteName.player);

    notifyListeners();
  }

  loadSong(PlayerModel playerModel) async {
    await player.setAudioSource(
      ConcatenatingAudioSource(
        useLazyPreparation: true,
        children: List.generate(
          playerModel.collectionViewAllModel.records.length,
          (index) => AudioSource.uri(
              Uri.parse(
                  "https://api-musiq.applogiq.org/api/v1/audio?song_id=${playerModel.collectionViewAllModel.records[index]!.id.toString()}"),
              tag: PlayerSongListModel(
                  id: playerModel.collectionViewAllModel.records[index]!.id,
                  albumName: playerModel
                      .collectionViewAllModel.records[index]!.albumName,
                  title: playerModel
                      .collectionViewAllModel.records[index]!.songName,
                  musicDirectorName: playerModel.collectionViewAllModel
                      .records[index]!.musicDirectorName![0]
                      .toString(),
                  imageUrl: generateSongImageUrl(
                      playerModel
                          .collectionViewAllModel.records[index]!.albumName,
                      playerModel
                          .collectionViewAllModel.records[index]!.albumId),
                  duration: playerModel
                      .collectionViewAllModel.records[index]!.duration)),
        ),
      ),
      initialIndex: playerModel.selectedSongIndex,
      initialPosition: Duration.zero,
    );
    player.stop();
    isPlay = false;
    playOrPause();
    // await clearFavouriteSong();
    await loadFavourites();
    notifyListeners();
  }

  loadFavourites() async {
    var id = await secureStorage.read(key: "id");
    LibraryRepository libraryRepository = LibraryRepository();
    var res = await libraryRepository.getFavouritesList(id!);
    if (res.statusCode == 200) {
      FavouriteModel favouriteModel =
          FavouriteModel.fromMap(jsonDecode(res.body.toString()));
      favouritesList.clear();
      for (var element in favouriteModel.records) {
        favouritesList.add(element.id);
      }
      notifyListeners();
    }
  }

  void playOrPause() {
    if (!isPlay) {
      play();
      isPlay = true;
    } else {
      player.stop();
      isPlay = false;
    }
    notifyListeners();
  }

  queuePlayNext(PlayerSongListModel playerSongListModel) {
    if (player.currentIndex != null) {
      playlist.insert(
          player.currentIndex! + 1,
          AudioSource.uri(
              Uri.parse(
                  "https://api-musiq.applogiq.org/api/v1/audio?song_id=${playerSongListModel.id.toString()}"),
              tag: PlayerSongListModel(
                  id: playerSongListModel.id,
                  albumName: playerSongListModel.albumName,
                  title: playerSongListModel.title,
                  musicDirectorName: playerSongListModel.musicDirectorName,
                  imageUrl: playerSongListModel.imageUrl,
                  duration: playerSongListModel.duration)));
    }
  }

  queueSong(PlayerSongListModel playerSongListModel) {
    playlist.add(
      AudioSource.uri(
        Uri.parse(
            "https://api-musiq.applogiq.org/api/v1/audio?song_id=${playerSongListModel.id.toString()}"),
        tag: PlayerSongListModel(
            id: playerSongListModel.id,
            albumName: playerSongListModel.albumName,
            title: playerSongListModel.title,
            musicDirectorName: playerSongListModel.musicDirectorName,
            imageUrl: playerSongListModel.imageUrl,
            duration: playerSongListModel.duration),
      ),
    );
  }

  void play() {
    if (player.playing) {
      player.stop();
      player.play();
    } else {
      player.play();
    }
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
    player.playerStateStream.listen((event) async {
      if (event.processingState == ProcessingState.ready) {
        var metaData = player.sequenceState!
            .effectiveSequence[player.currentIndex!].tag as PlayerSongListModel;
        Map params = {"song_id": metaData.id};
        var res = await PlayerRepo().recentList(params);

        if (res.statusCode == 200) {
          HomeProvider().recentSongList();
        }
      }
    });
    player.setPreferredPeakBitRate(360);
  }

  seekDuration(value) {
    player.seek(value);
  }

  void addFavourite(int songId) async {
    Map params = {"song_id": songId};
    var res = await playerRepo.addToFavourite(params);

    if (res.statusCode == 200) {
      toastMessage("Song added to favourite list", Colors.grey, Colors.white);
      addFavouriteSongToLocalDb(songId);
      // await favouriteSongBox.add(song);
    } else if (res.statusCode == 400) {
      loadFavourites();

      toastMessage("Song already in favourite list", Colors.grey, Colors.white);
    }
  }

  void deleteFavourite(int songId,
      {bool isFromFav = false, BuildContext? ctx}) async {
    Map params = {"song_id": songId};

    var res = await playerRepo.deleteFavourite(params);

    if (res.statusCode == 200) {
      // deleteFavouriteSongFormLocal(songId);
      if (isFromFav) {
        ctx!.read<LibraryProvider>().getFavouritesList();
      }
      toastMessage(
          "Song removed from favourite list", Colors.grey, Colors.white);
    } else if (res.statusCode == 404) {
      loadFavourites();
      toastMessage("Favourites not found", Colors.grey, Colors.white);
    }
  }

  // deleteFavouriteSongFormLocal(int uniqueId) async {
  //   await getApplicationDocumentsDirectory().then((Directory dir) {
  //     store = Store(getObjectBoxModel(), directory: '${dir.path}/musiq');
  //   });
  //   final box = store.box<FavouriteSong>();

  //   box.remove(uniqueId);

  //   store.close();
  //   getSongList();
  // }

  addQueueToLocalDb(
    PlayerSongListModel playerSongListModel,
  ) async {
    // await getApplicationDocumentsDirectory().then((Directory dir) {
    //   store = Store(getObjectBoxModel(), directory: '${dir.path}/musiq/db/1/');
    final SongListModel queueSongModel = SongListModel(
        songId: playerSongListModel.id,
        albumName: playerSongListModel.albumName,
        title: playerSongListModel.title,
        musicDirectorName: playerSongListModel.musicDirectorName,
        imageUrl: playerSongListModel.imageUrl,
        songUrl:
            "https://api-musiq.applogiq.org/api/v1/audio?song_id=${playerSongListModel.id.toString()}",
        duration: playerSongListModel.duration);

    // objectbox.addQueue(queueSongModel);

    var res = objectbox.getAllQueueSong();
    queueIdList.clear();
    for (var e in res) {
      queueIdList.add(e.songId);
    }
    if (queueIdList.contains(playerSongListModel.id)) {
      normalToastMessage("Song already in queue ");
    } else {
      queueSong(playerSongListModel);
      objectbox.addQueue(queueSongModel);
      normalToastMessage("Song added to queue ");
    }

    //   store.close();
    //   getQueueSongList();
    // });
  }

  // getQueueSongList() async {
  //   await getApplicationDocumentsDirectory().then((Directory dir) {
  //     store = Store(getObjectBoxModel(), directory: '${dir.path}/musiq/db/1/');
  //   });
  //   final box = store.box<SongListModel>();

  //   var res = box.getAll();
  //   queueIdList.clear();
  //   for (var e in res) {
  //     queueIdList.add(e.songId);
  //   }
  //   notifyListeners();

  //   store.close();
  // }

  addFavouriteSongToLocalDb(int songId) async {
    final song = FavouriteSong(songUniqueId: songId);
    objectbox.saveFavourite(song);
    // await getApplicationDocumentsDirectory().then((Directory dir) {
    //   store = Store(getObjectBoxModel(), directory: '${dir.path}/musiq/db/1/');
    // });
    // final box = store.box<FavouriteSong>();
    // box.put(song);

    // store.close();
    // getSongList();
  }

  // clearFavouriteSong() async {
  //   await getApplicationDocumentsDirectory().then((Directory dir) {
  //     store = Store(getObjectBoxModel(), directory: '${dir.path}/musiq/db/1/');
  //   });
  //   final box = store.box<FavouriteSong>();
  //   box.removeAll();

  //   store.close();
  //   getSongList();
  // }

  // getSongList() async {
  //   await getApplicationDocumentsDirectory().then((Directory dir) {
  //     store = Store(getObjectBoxModel(), directory: '${dir.path}/musiq/db/1/');
  //     final box = store.box<FavouriteSong>();

  //     var res = box.getAll();
  //     favouritesList.clear();
  //     for (var e in res) {
  //       favouritesList.add(e.songUniqueId);
  //     }
  //     store.close();
  //   });

  //   notifyListeners();
  // }

  shuffleSong() async {
    await shuffleSongController();
    notifyListeners();
  }

  songInfo(String songId) async {
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

  addNewQueueSongList(List<PlayerSongListModel> playerSongListModel) async {
    // await getApplicationDocumentsDirectory().then((Directory dir) {
    //   store = Store(getObjectBoxModel(), directory: '${dir.path}/musiq/db/1/');
    //   final queueBox = store.box<SongListModel>();

    //   queueBox.removeAll();
    List<SongListModel> songlist = [];
    for (var e in playerSongListModel) {
      songlist.add(SongListModel(
          duration: e.duration,
          songId: e.id,
          albumName: e.albumName,
          title: e.title,
          musicDirectorName: e.musicDirectorName,
          imageUrl: e.imageUrl,
          songUrl:
              "https://api-musiq.applogiq.org/api/v1/audio?song_id=${e.id.toString()}"));
    }
    objectbox.addNewSongListQueue(songlist);
    //     queueBox.putMany(songlist);

    //     store.close();
    //     getQueueSongList();
    //   });
  }

  addSongToQueueSongList(List<PlayerSongListModel> playerSongListModel) async {
    List<SongListModel> songlist = [];
    for (var e in playerSongListModel) {
      playlist.add(AudioSource.uri(
          Uri.parse(
              "https://api-musiq.applogiq.org/api/v1/audio?song_id=${e.id.toString()}"),
          tag: PlayerSongListModel(
              id: e.id,
              albumName: e.albumName,
              title: e.title,
              musicDirectorName: e.musicDirectorName,
              imageUrl: e.imageUrl,
              duration: e.duration)));
      songlist.add(SongListModel(
          songId: e.id,
          albumName: e.albumName,
          title: e.title,
          musicDirectorName: e.musicDirectorName,
          imageUrl: e.imageUrl,
          songUrl:
              "https://api-musiq.applogiq.org/api/v1/audio?song_id=${e.id.toString()}",
          duration: e.duration));
    }
    objectbox.addSongListQueue(songlist);
  }

  loadQueueSong() async {
    if (!inQueue) {
      try {
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
          }
          // playlist = ConcatenatingAudioSource(
          //   useLazyPreparation: true,
          //   children: List.generate(
          //     playerSongList.length,
          //     (index) => AudioSource.uri(
          //         Uri.parse(
          //             "https://api-musiq.applogiq.org/api/v1/audio?song_id=${playerSongList[index].id.toString()}"),
          //         tag: PlayerSongListModel(
          //             id: playerSongList[index].id,
          //             albumName: playerSongList[index].albumName,
          //             title: playerSongList[index].title,
          //             musicDirectorName:
          //                 playerSongList[index].musicDirectorName.toString(),
          //             imageUrl: playerSongList[index].imageUrl,
          //             duration: playerSongList[index].duration)),
          //   ),
          // );
          // AudioPlayerHandler audioPlayerHandler = AudioPlayerHandler();
          // audioPlayerHandler.getDataFromPlayerProvider(playerSongList);
          // await player.setAudioSource(
          //   playlist,
          //   initialIndex: 0,
          //   initialPosition: Duration.zero,
          // );
          // player.stop();
          // isPlay = true;
          // isPlaying = true;

          // playOrPause();
          // // store.close();
        }
        inQueue = true;
        // init();
        // notifyListeners();
      } catch (e) {
        debugPrint(e.toString());
      }
    }
  }

  loadSingleQueueSong() async {
    // AudioPlayerHandler().load();
    // if (!inQueue) {
    //   // try {
    //   // await getApplicationDocumentsDirectory().then((Directory dir) async {
    //   //   store =
    //   //       Store(getObjectBoxModel(), directory: '${dir.path}/musiq/db/1/');
    //   //   final box = store.box<SongListModel>();

    var res = objectbox.getAllQueueSong();
    log("SFDgfg --- ${res.length}");

    if (res.isNotEmpty) {
      queueIdList.clear();
      List<PlayerSongListModel> playerSongList = [];
      var e = res.first;
      // for (var e in res) {
      playerSongList.add(PlayerSongListModel(
          id: e.songId,
          albumName: e.albumName,
          title: e.title,
          imageUrl: e.imageUrl,
          musicDirectorName: e.musicDirectorName,
          duration: e.duration));
      // AudioPlayerHandler playerHandler = AudioPlayerHandler();
      // playerHandler.setSongToPlayer(playerSongList.first);
    }
    //     // AudioPlayerHandler().setSongToPlayer(playerSongList.first);
    //     // }
    //     // playlist = ConcatenatingAudioSource(
    //     //   useLazyPreparation: true,
    //     //   children: List.generate(
    //     //     playerSongList.length,
    //     //     (index) => AudioSource.uri(
    //     //         Uri.parse(
    //     //             "https://api-musiq.applogiq.org/api/v1/audio?song_id=${playerSongList[index].id.toString()}"),
    //     //         tag: PlayerSongListModel(
    //     //             id: playerSongList[index].id,
    //     //             albumName: playerSongList[index].albumName,
    //     //             title: playerSongList[index].title,
    //     //             musicDirectorName:
    //     //                 playerSongList[index].musicDirectorName.toString(),
    //     //             imageUrl: playerSongList[index].imageUrl)),
    //     //   ),
    //     // );
    //     // await player.setAudioSource(
    //     //   playlist,
    //     //   initialIndex: 0,
    //     //   initialPosition: Duration.zero,
    //     // );
    //     // player.stop();
    //     // isPlay = true;
    //     // isPlaying = true;

    //     // playOrPause();
    //     // store.close();
    //     //     }
    //     //   });

    //     //   // try {
    //     //   //   await clearFavouriteSong();
    //     //   //   await loadFavourites();
    //     //   // } catch (e) {
    //     //   //   store.close();
    //     //   // }
    //     //   // inQueue = true;
    //     //   // notifyListeners();
    //     // } catch (e) {
    //     //   store.close();
    //     //   debugPrint(e.toString());
    //     // }
    //   }
    // }

    // loadAudioHandler() async {
    //   if (!inQueue) {
    //     await getApplicationDocumentsDirectory().then((Directory dir) async {
    //       store = Store(getObjectBoxModel(), directory: '\$\{dir\.path\}/musiq/db/1');
    //       final box = store.box<SongListModel>();

    //       var res = box.getAll();
    //       log("SFDgfg --- ${res.length}");

    //       if (res.isNotEmpty) {
    //         final mediaItems = res
    //             .map((song) => MediaItem(
    //                   id: song.id.toString() ?? '',
    //                   album: song.albumName ?? '',
    //                   title: song.title ?? '',
    //                   extras: {'url': song.songUrl},
    //                 ))
    //             .toList();
    //         _audioHandler.addQueueItems(mediaItems);
    //         // playerSongList.add(PlayerSongListModel(
    //         //     id: e.songId,
    //         //     albumName: e.albumName,
    //         //     title: e.title,
    //         //     imageUrl: e.imageUrl,
    //         //     musicDirectorName: e.musicDirectorName));

    //       }

    //       // if (res.isNotEmpty) {
    //       //   queueIdList.clear();
    //       //   List<PlayerSongListModel> playerSongList = [];
    //       //   for (var e in res) {
    //       //     print(e.songId);
    //       //     playerSongList.add(PlayerSongListModel(
    //       //         id: e.songId,
    //       //         albumName: e.albumName,
    //       //         title: e.title,
    //       //         imageUrl: e.imageUrl,
    //       //         musicDirectorName: e.musicDirectorName));
    //       //   }
    //       //   playlist = ConcatenatingAudioSource(
    //       //     useLazyPreparation: true,
    //       //     children: List.generate(
    //       //       playerSongList.length,
    //       //       (index) => AudioSource.uri(
    //       //           Uri.parse(
    //       //               "https://api-musiq.applogiq.org/api/v1/audio?song_id=${playerSongList[index].id.toString()}"),
    //       //           tag: PlayerSongListModel(
    //       //               id: playerSongList[index].id,
    //       //               albumName: playerSongList[index].albumName,
    //       //               title: playerSongList[index].title,
    //       //               musicDirectorName:
    //       //                   playerSongList[index].musicDirectorName.toString(),
    //       //               imageUrl: playerSongList[index].imageUrl)),
    //       //     ),
    //       //   );
    //       //   await player.setAudioSource(
    //       //     playlist,
    //       //     initialIndex: 0,
    //       //     initialPosition: Duration.zero,
    //       //   );
    //       //   player.stop();
    //       //   isPlay = true;
    //       //   isPlaying = true;

    //       //   playOrPause();
    //       //   store.close();
    //       // }
    //     });

    //     inQueue = true;
    //     notifyListeners();
    //   }
    // }
  }
}
