import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musiq/src/features/player/domain/model/player_song_list_model.dart';
import 'package:musiq/src/features/player/domain/repo/player_repo.dart';
import 'package:musiq/src/features/view_all/domain/model/player_model.dart';
import 'package:musiq/src/utils/image_url_generate.dart';

class PlayerProvider extends ChangeNotifier {
  bool isPlay = false;
  bool isShuffle = false;
  AudioPlayer player = AudioPlayer();
  var selectedIndex = 0;
  var progressDurationValue = 0;
  var totalDurationValue = 0;
  var bufferDurationValue = 0;
  PlayerRepo playerRepo = PlayerRepo();

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
      initialIndex: selectedIndex,
      initialPosition: Duration.zero,
    );
    notifyListeners();
  }

  void addFavourite(int songId) async {
    print(songId.toString());
    Map params = {"song_id": songId};
    var res = await playerRepo.addToFavourite(params);
    print(res.statusCode);
    print(res.body);
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
}
