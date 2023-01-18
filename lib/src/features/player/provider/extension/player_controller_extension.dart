import '../player_provider.dart';

extension PlayerControllerExtension on PlayerProvider {
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
}
