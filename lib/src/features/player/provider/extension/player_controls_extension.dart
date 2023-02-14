// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musiq/src/features/player/provider/player_provider.dart';

import '../../../../core/utils/toast_message.dart';

extension PlayerControllerExtension on PlayerProvider {
  loopSongController() async {
    if (loopStatus == 0) {
      loopStatus = 1;
      await player.setLoopMode(LoopMode.all);
    } else if (loopStatus == 1) {
      loopStatus = 2;
      await player.setLoopMode(LoopMode.one);
    } else {
      loopStatus = 0;

      await player.setLoopMode(LoopMode.off);
    }
  }

  shuffleSongController(bool shuffleStatus) async {
    if (shuffleStatus) {
      await player.setShuffleModeEnabled(true);
    } else {
      await player.setShuffleModeEnabled(false);
    }
    // isShuffle = !isShuffle;
  }

  void deleteSongInQueue(int index) {
    playlist.removeAt(index);
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

  void playNext() {
    player.seekToNext();
  }

  void playPrev() {
    player.seekToPrevious();
  }
}
