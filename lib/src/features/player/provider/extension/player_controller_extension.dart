import 'package:flutter/cupertino.dart';

import '../player_provider.dart';

extension PlayerControllerExtension on PlayerProvider {
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
}
