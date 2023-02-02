import 'package:flutter/material.dart';
import 'package:musiq/src/features/player/domain/model/player_song_list_model.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

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

  addToQueue(PlayerSongListModel playerSongListModel, BuildContext context) {
    context.read<PlayerProvider>().queueSong(playerSongListModel);
  }

  addListToQueue() {}

  goToAlbumInfo() {}

  share() {
    Share.share(
        'check out MusiQ app\n https://play.google.com/store/apps/details?id=app.gotoz.parent');
  }

  playNext(PlayerSongListModel playerSongListModel, BuildContext context) {
    context.read<PlayerProvider>().queuePlayNext(playerSongListModel);
  }

  removeFromFavourites(int id, BuildContext context) {
    context
        .read<PlayerProvider>()
        .deleteFavourite(id, isFromFav: true, ctx: context);
  }

  deletePlaylist(int id, BuildContext context) {
    context
        .read<PlayerProvider>()
        .deleteFavourite(id, isFromFav: true, ctx: context);
  }

  renamePlaylist() {}

  playAll() {}

  addSong() {}

  removeSongFromPlaylist() {}
}
