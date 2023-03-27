import 'package:flutter/material.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/constant.dart';
import '../../../common/provider/pop_up_provider.dart';

class ReorderableSongListPopUpMenu extends StatelessWidget {
  const ReorderableSongListPopUpMenu({
    Key? key,
    required this.metadata,
    required this.index,
    required this.curentindex,
  }) : super(key: key);

  final MediaItem metadata;
  final int index;
  final int curentindex;

  @override
  Widget build(BuildContext context) {
    return index != curentindex
        ? Expanded(
            flex: 1,
            child: PopupMenuButton(
              color: CustomColor.appBarColor,
              shape: popUpDecorationContainer(),
              padding: const EdgeInsets.all(0.0),
              onSelected: (value) {
                switch (value) {
                  case PopUpConstants.deleteInQueue:
                    context.read<PopUpProvider>().deleteInQueue(index, context);
                    break;
                  case PopUpConstants.addToFavourites:
                    context.read<PopUpProvider>().addToFavourites(
                        int.parse(metadata.extras!["song_id"].toString()),
                        context);
                    break;
                  case PopUpConstants.addToPlaylist:
                    context.read<PopUpProvider>().goToPlaylist(
                        int.parse(metadata.extras!["song_id"].toString()),
                        context);

                    break;
                  case PopUpConstants.songInfo:
                    print(metadata.extras!["song_id"]);
                    context.read<PopUpProvider>().goToSongInfo(
                        int.parse(metadata.extras!["song_id"].toString()),
                        context);

                    break;
                }
              },
              itemBuilder: (ctx) => [
                const PopupMenuItem(
                  value: PopUpConstants.addToFavourites,
                  child: Text(ConstantText.addFavourites),
                ),
                const PopupMenuItem(
                  value: PopUpConstants.addToPlaylist,
                  child: Text(ConstantText.addPlaylist),
                ),
                const PopupMenuItem(
                  value: PopUpConstants.deleteInQueue,
                  child: Text(ConstantText.deleteInQueue),
                ),
                const PopupMenuItem(
                  value: PopUpConstants.songInfo,
                  child: Text(ConstantText.songInfo),
                ),
              ],
            ),
          )
        : Expanded(
            flex: 1,
            child: PopupMenuButton(
              color: CustomColor.appBarColor,
              shape: popUpDecorationContainer(),
              padding: const EdgeInsets.all(0.0),
              onSelected: (value) {
                switch (value) {
                  case PopUpConstants.deleteInQueue:
                    context.read<PopUpProvider>().deleteInQueue(index, context);
                    break;
                  case PopUpConstants.addToFavourites:
                    context.read<PopUpProvider>().addToFavourites(
                        int.parse(metadata.extras!["song_id"].toString()),
                        context);
                    break;
                  case PopUpConstants.addToPlaylist:
                    context.read<PopUpProvider>().goToPlaylist(
                        int.parse(metadata.extras!["song_id"].toString()),
                        context);

                    break;
                  case PopUpConstants.songInfo:
                    print(metadata.extras!["song_id"]);
                    context.read<PopUpProvider>().goToSongInfo(
                        int.parse(metadata.extras!["song_id"].toString()),
                        context);

                    break;
                }
              },
              itemBuilder: (ctx) => [
                const PopupMenuItem(
                  value: PopUpConstants.addToFavourites,
                  child: Text(ConstantText.addFavourites),
                ),
                const PopupMenuItem(
                  value: PopUpConstants.addToPlaylist,
                  child: Text(ConstantText.addPlaylist),
                ),
                const PopupMenuItem(
                  value: PopUpConstants.songInfo,
                  child: Text(ConstantText.songInfo),
                ),
              ],
            ),
          );
  }
}
