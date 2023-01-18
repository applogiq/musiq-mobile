import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart';

class PlayerProvider extends ChangeNotifier {
  bool isPlay = false;
  late AudioPlayer player;
  var selectedIndex = 0;

  loadSong(List songList) async {
    player = AudioPlayer();

    await player.setAudioSource(
      ConcatenatingAudioSource(
        useLazyPreparation: true,
        children: List.generate(
            songList.length,
            (index) => AudioSource.uri(Uri.parse(
                "https://api-musiq.applogiq.org/api/v1/audio?song_id=${songList[index]}"))),
      ),
      initialIndex: selectedIndex,
      initialPosition: Duration.zero,
    );
    notifyListeners();
  }

  void playNext() {
    player.seekToNext();
  }

  void playPrev() {
    player.seekToPrevious();
  }
}
