import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart';

class PlayerProvider extends ChangeNotifier {
  bool isPlay = false;
  late AudioPlayer player;
  var selectedIndex = 0;

  void playOrPause() {
    if (!isPlay) {
      player.play();
      isPlay = true;
    } else {
      player.stop();
      isPlay = false;
    }
    notifyListeners();
  }

  loadSong() async {
    player = AudioPlayer();

    // if(player.playing){
    //   player.stop();
    // }
//    if(isPlaying==player.playerState.playing){
// print("ALREADY PLAYING");
//    }
//    else{
    await player.setAudioSource(
      ConcatenatingAudioSource(
        useLazyPreparation: true,
        children: List.generate(
            10,
            (index) => AudioSource.uri(Uri.parse(
                "https://api-musiq.applogiq.org/api/v1/audio?song_id=${index + 1}"))),
      ),
      initialIndex: selectedIndex,
      initialPosition: Duration.zero,
    );
//     selectedIndex.value = index;
// update();
    //  }
    notifyListeners();
  }

  void playNext() {
    player.seekToNext();
  }

  void playPrev() {
    player.seekToPrevious();
  }
}
