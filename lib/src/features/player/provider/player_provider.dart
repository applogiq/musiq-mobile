import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musiq/src/features/player/domain/model/player_song_list_model.dart';
import 'package:musiq/src/features/player/domain/model/song_info_model.dart';
import 'package:musiq/src/features/player/domain/repo/player_repo.dart';
import 'package:musiq/src/features/view_all/domain/model/player_model.dart';
import 'package:musiq/src/utils/image_url_generate.dart';
import 'package:musiq/src/utils/toast_message.dart';

import '../../library/domain/library_repo.dart';
import '../../library/domain/models/playlist_model.dart';

class PlayerProvider extends ChangeNotifier {
  bool isPlay = false;
  bool isShuffle = false;
  bool issongInfoDetailsLoad = true;
  int loopStatus = 0;

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
    notifyListeners();
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

  void play() {
    print("----->${player.playing}");
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
  }

  seekDuration(value) {
    player.seek(value);
  }

  void addFavourite(int songId) async {
    print(songId.toString());
    Map params = {"song_id": songId};
    var res = await playerRepo.addToFavourite(params);
    print(res.statusCode);
    print(res.body);
    if (res.statusCode == 200) {
      toastMessage("Song added to favourite list", Colors.grey, Colors.white);
    } else if (res.statusCode == 400) {
      toastMessage("Song already in favourite list", Colors.grey, Colors.white);
    }
  }

  void deleteFavourite(int songId) async {
    print(songId.toString());
    Map params = {"song_id": songId};
    print(params);
    var res = await playerRepo.deleteFavourite(params);
    print(res.statusCode);
    print(res.body);
    if (res.statusCode == 200) {
      toastMessage(
          "Song removed from favourite list", Colors.grey, Colors.white);
    } else if (res.statusCode == 404) {
      toastMessage("Favourites not found", Colors.grey, Colors.white);
    }
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
    print(res.statusCode);
    print(res.body);
    if (res.statusCode == 200) {
      songInfoModel = SongInfoModel.fromMap(jsonDecode(res.body));
    }
    issongInfoDetailsLoad = false;
    notifyListeners();
  }

  addToPlaylist(Map params, BuildContext context, String playListName) async {
    var res = await playerRepo.addToPlaylist(params);
    print(res.statusCode);
    print(res.body);
    Navigator.pop(context);

    if (res.statusCode == 200) {
      toastMessage("Added to $playListName", Colors.grey, Colors.white);
    } else if (res.statusCode == 400) {
      toastMessage("Song already in $playListName", Colors.grey, Colors.white);
    }
  }
}
