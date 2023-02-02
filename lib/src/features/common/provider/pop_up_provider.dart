import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../routing/route_name.dart';
import '../../../utils/navigation.dart';
import '../../player/provider/player_provider.dart';

class PopUpProvider extends ChangeNotifier {
  deleteInQueue(int index, BuildContext context) {
    context.read<PlayerProvider>().deleteSongInQueue(index);
  }

  addToFavourites(int songId, BuildContext context) async {
    context.read<PlayerProvider>().addFavourite(songId);
  }

  goToPlaylist(int songId, BuildContext context) {
    Navigation.navigateToScreen(context, RouteName.addPlaylist,
        args: songId.toString());
  }

  goToSongInfo(int songId, BuildContext context) {
    Navigation.navigateToScreen(context, RouteName.songInfo, args: songId);
  }

  addToQueue() {}

  addListToQueue() {}

  goToAlbumInfo() {}

  share() {}

  playNext() {}

  removeFromFavourites() {}

  deletePlaylist() {}

  renamePlaylist() {}

  playAll() {}

  addSong() {}

  removeSongFromPlaylist() {}
}
