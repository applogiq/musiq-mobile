// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musiq/src/features/library/domain/models/favourite_model.dart';
import 'package:musiq/src/features/library/provider/library_provider.dart';
import 'package:musiq/src/features/player/domain/model/player_song_list_model.dart';
import 'package:musiq/src/features/player/domain/model/song_info_model.dart';
import 'package:musiq/src/features/player/domain/repo/player_repo.dart';
import 'package:musiq/src/features/view_all/domain/model/player_model.dart';
import 'package:musiq/src/local/model/favourite_model.dart';
import 'package:musiq/src/local/model/queue_model.dart';
import 'package:musiq/src/routing/route_name.dart';
import 'package:musiq/src/utils/image_url_generate.dart';
import 'package:musiq/src/utils/navigation.dart';
import 'package:musiq/src/utils/toast_message.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../../../../objectbox.g.dart';
import '../../../core/package/miniplayer/miniplayer.dart';
import '../../library/domain/library_repo.dart';
import '../../library/domain/models/playlist_model.dart';

class PlayerProvider extends ChangeNotifier {
  final MiniplayerController controller = MiniplayerController();
  bool isPlay = false;
  bool isPlaying = false;
  bool isShuffle = false;
  bool issongInfoDetailsLoad = true;
  int loopStatus = 0;
  bool inQueue = false;

  late Store store;
  List<int> favouritesList = [];
  List<int> queueIdList = [];
  late ConcatenatingAudioSource playlist;

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

  removeAllData() async {
    await getApplicationDocumentsDirectory().then((Directory dir) {
      store = Store(getObjectBoxModel(), directory: '${dir.path}/musiq');
      final favouriteBox = store.box<FavouriteSong>();
      final queueBox = store.box<SongListModel>();
      favouriteBox.removeAll();
      queueBox.removeAll();
      store.close();
    });
  }

  addNewQueueSongList(List<PlayerSongListModel> playerSongListModel) async {
    await getApplicationDocumentsDirectory().then((Directory dir) {
      store = Store(getObjectBoxModel(), directory: '${dir.path}/musiq');
      final queueBox = store.box<SongListModel>();

      queueBox.removeAll();
      List<SongListModel> songlist = [];
      for (var e in playerSongListModel) {
        songlist.add(SongListModel(
            songId: e.id,
            albumName: e.albumName,
            title: e.title,
            musicDirectorName: e.musicDirectorName,
            imageUrl: e.imageUrl,
            songUrl:
                "https://api-musiq.applogiq.org/api/v1/audio?song_id=${e.id.toString()}"));
      }
      queueBox.putMany(songlist);

      store.close();
      getQueueSongList();
    });
  }

  addSongToQueueSongList(List<PlayerSongListModel> playerSongListModel) async {
    print("SSS");
    await getApplicationDocumentsDirectory().then((Directory dir) {
      store = Store(getObjectBoxModel(), directory: '${dir.path}/musiq');
      final queueBox = store.box<SongListModel>();

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
                imageUrl: e.imageUrl)));
        songlist.add(SongListModel(
            songId: e.id,
            albumName: e.albumName,
            title: e.title,
            musicDirectorName: e.musicDirectorName,
            imageUrl: e.imageUrl,
            songUrl:
                "https://api-musiq.applogiq.org/api/v1/audio?song_id=${e.id.toString()}"));
      }
      print(songlist);
      queueBox.putMany(songlist);

      store.close();

      getQueueSongList();
    });
  }

  loadQueueSong() async {
    if (!inQueue) {
      await getApplicationDocumentsDirectory().then((Directory dir) async {
        store = Store(getObjectBoxModel(), directory: '${dir.path}/musiq');
        final box = store.box<SongListModel>();

        var res = box.getAll();
        log("SFDgfg --- ${res.length}");

        if (res.isNotEmpty) {
          queueIdList.clear();
          List<PlayerSongListModel> playerSongList = [];
          for (var e in res) {
            print(e.songId);
            playerSongList.add(PlayerSongListModel(
                id: e.songId,
                albumName: e.albumName,
                title: e.title,
                imageUrl: e.imageUrl,
                musicDirectorName: e.musicDirectorName));
          }
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
                      imageUrl: playerSongList[index].imageUrl)),
            ),
          );
          await player.setAudioSource(
            playlist,
            initialIndex: 0,
            initialPosition: Duration.zero,
          );
          player.stop();
          isPlay = true;
          isPlaying = true;

          playOrPause();
          store.close();
        }
      });

      try {
        await clearFavouriteSong();
        await loadFavourites();
      } catch (e) {
        store.close();
      }
      inQueue = true;
      notifyListeners();
    }
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

  loopSong() async {
    if (loopStatus == 0) {
      loopStatus = 1;
      await player.setLoopMode(LoopMode.all);
      // isRepeated.value = true;
    } else if (loopStatus == 1) {
      loopStatus = 2;
      await player.setLoopMode(LoopMode.one);
      // isRepeated.value = true;
    } else {
      loopStatus = 0;
      // isRepeated.value = false;
      await player.setLoopMode(LoopMode.off);
    }
    notifyListeners();
  }

  void goToPlayer(BuildContext context,
      List<PlayerSongListModel> playerSongList, int index) async {
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
                imageUrl: playerSongList[index].imageUrl)),
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
    try {
      await clearFavouriteSong();
      await loadFavourites();
    } catch (e) {}

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
                          .collectionViewAllModel.records[index]!.albumId))),
        ),
      ),
      initialIndex: playerModel.selectedSongIndex,
      initialPosition: Duration.zero,
    );
    player.stop();
    isPlay = false;
    playOrPause();
    await clearFavouriteSong();
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
                  imageUrl: playerSongListModel.imageUrl)));
    }
  }

  queueSong(PlayerSongListModel playerSongListModel) {
    playlist.add(AudioSource.uri(
        Uri.parse(
            "https://api-musiq.applogiq.org/api/v1/audio?song_id=${playerSongListModel.id.toString()}"),
        tag: PlayerSongListModel(
            id: playerSongListModel.id,
            albumName: playerSongListModel.albumName,
            title: playerSongListModel.title,
            musicDirectorName: playerSongListModel.musicDirectorName,
            imageUrl: playerSongListModel.imageUrl)));
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
      } catch (e) {}
      notifyListeners();
    });
    player.bufferedPositionStream.listen((event) {
      bufferDurationValue = event.inMilliseconds;
    });
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
      deleteFavouriteSongFormLocal(songId);
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

  deleteFavouriteSongFormLocal(int uniqueId) async {
    await getApplicationDocumentsDirectory().then((Directory dir) {
      store = Store(getObjectBoxModel(), directory: '${dir.path}/musiq');
    });
    final box = store.box<FavouriteSong>();

    var id = box.remove(uniqueId);

    store.close();
    getSongList();
  }

  addQueueToLocalDb(
    PlayerSongListModel playerSongListModel,
  ) async {
    await getApplicationDocumentsDirectory().then((Directory dir) {
      store = Store(getObjectBoxModel(), directory: '${dir.path}/musiq');
      final SongListModel queueSongModel = SongListModel(
          songId: playerSongListModel.id,
          albumName: playerSongListModel.albumName,
          title: playerSongListModel.title,
          musicDirectorName: playerSongListModel.musicDirectorName,
          imageUrl: playerSongListModel.imageUrl,
          songUrl:
              "https://api-musiq.applogiq.org/api/v1/audio?song_id=${playerSongListModel.id.toString()}");
      final box = store.box<SongListModel>();

      var res = box.getAll();
      queueIdList.clear();
      for (var e in res) {
        queueIdList.add(e.songId);
      }
      if (queueIdList.contains(playerSongListModel.id)) {
        normalToastMessage("Song already in queue ");
      } else {
        box.put(queueSongModel);
        normalToastMessage("Song added to queue ");
      }

      store.close();
      getQueueSongList();
    });
  }

  getQueueSongList() async {
    await getApplicationDocumentsDirectory().then((Directory dir) {
      store = Store(getObjectBoxModel(), directory: '${dir.path}/musiq');
    });
    final box = store.box<SongListModel>();

    var res = box.getAll();
    queueIdList.clear();
    for (var e in res) {
      queueIdList.add(e.songId);
    }
    notifyListeners();

    store.close();
  }

  addFavouriteSongToLocalDb(int songId) async {
    final song = FavouriteSong(songUniqueId: songId);
    await getApplicationDocumentsDirectory().then((Directory dir) {
      store = Store(getObjectBoxModel(), directory: '${dir.path}/musiq');
    });
    final box = store.box<FavouriteSong>();
    box.put(song);

    store.close();
    getSongList();
  }

  clearFavouriteSong() async {
    await getApplicationDocumentsDirectory().then((Directory dir) {
      store = Store(getObjectBoxModel(), directory: '${dir.path}/musiq');
    });
    final box = store.box<FavouriteSong>();
    box.removeAll();

    store.close();
    getSongList();
  }

  getSongList() async {
    await getApplicationDocumentsDirectory().then((Directory dir) {
      store = Store(getObjectBoxModel(), directory: '${dir.path}/musiq');
    });
    final box = store.box<FavouriteSong>();

    var res = box.getAll();
    favouritesList.clear();
    for (var e in res) {
      favouritesList.add(e.songUniqueId);
    }

    notifyListeners();

    store.close();
  }

  void playNext() {
    player.seekToNext();
  }

  void playPrev() {
    player.seekToPrevious();
  }

  shuffleSong() async {
    if (isShuffle == false) {
      await player.setShuffleModeEnabled(true);
    } else {
      await player.setShuffleModeEnabled(false);
    }
    isShuffle = !isShuffle;
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

  addToPlaylist(Map params, BuildContext context, String playListName) async {
    var res = await playerRepo.addToPlaylist(params);

    Navigator.pop(context);

    if (res.statusCode == 200) {
      toastMessage("Added to $playListName", Colors.grey, Colors.white);
    } else if (res.statusCode == 400) {
      toastMessage("Song already in $playListName", Colors.grey, Colors.white);
    }
  }
}
