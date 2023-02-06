import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../common_widgets/container/custom_color_container.dart';
import '../../../../../core/constants/constant.dart';
import '../../../../common/provider/pop_up_provider.dart';
import '../../../../player/domain/model/player_song_list_model.dart';

class PlaylistSongListTile extends StatelessWidget {
  const PlaylistSongListTile({
    super.key,
    required this.imageUrl,
    required this.songName,
    required this.musicDirectorName,
    required this.songId,
    required this.albumName,
    required this.playlistSongId,
    required this.playlistId,
    required this.duration,
  });

  final String albumName;
  final String imageUrl;
  final String musicDirectorName;
  final int songId;
  final String songName;
  final int playlistSongId;
  final int playlistId;
  final String duration;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: CustomColor.bg,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: CustomColorContainer(
                child: Image.network(
                  imageUrl,
                  height: 70,
                  width: 70,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              flex: 8,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      songName,
                      style: fontWeight400(),
                    ),
                    Text(
                      musicDirectorName,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: fontWeight400(
                          size: 12.0, color: CustomColor.subTitle),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: PopupMenuButton<int>(
                color: CustomColor.appBarColor,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(8.0),
                    bottomRight: Radius.circular(8.0),
                    topLeft: Radius.circular(8.0),
                    topRight: Radius.circular(8.0),
                  ),
                ),
                onSelected: (value) {
                  switch (value) {
                    case PopUpConstants.addToFavourites:
                      context
                          .read<PopUpProvider>()
                          .addToFavourites(songId, context);
                      break;
                    case PopUpConstants.playNext:
                      PlayerSongListModel playerSongListModel =
                          PlayerSongListModel(
                              id: songId,
                              albumName: albumName,
                              title: songName,
                              imageUrl: imageUrl,
                              musicDirectorName: musicDirectorName,
                              duration: '');
                      context
                          .read<PopUpProvider>()
                          .playNext(playerSongListModel, context);
                      break;
                    case PopUpConstants.addToQueue:
                      PlayerSongListModel playerSongListModel =
                          PlayerSongListModel(
                              id: songId,
                              albumName: albumName,
                              title: songName,
                              imageUrl: imageUrl,
                              musicDirectorName: musicDirectorName,
                              duration: duration);
                      context
                          .read<PopUpProvider>()
                          .addToQueue(playerSongListModel, context);
                      break;
                    case PopUpConstants.removePlaylist:
                      context.read<PopUpProvider>().removeSongFromPlaylist(
                          playlistSongId, context, playlistId);
                      break;
                    case PopUpConstants.songInfo:
                      context
                          .read<PopUpProvider>()
                          .goToSongInfo(songId, context);
                      break;
                  }
                },
                itemBuilder: (BuildContext context) {
                  return [
                    const PopupMenuItem(
                      value: PopUpConstants.addToFavourites,
                      child: Text(ConstantText.addFavourites),
                    ),
                    const PopupMenuItem(
                      value: PopUpConstants.playNext,
                      child: Text(ConstantText.playNext),
                    ),
                    const PopupMenuItem(
                      value: PopUpConstants.addToQueue,
                      child: Text(ConstantText.addToQueue),
                    ),
                    const PopupMenuItem(
                      value: PopUpConstants.removePlaylist,
                      child: Text(ConstantText.remove),
                    ),
                    const PopupMenuItem(
                      value: PopUpConstants.songInfo,
                      child: Text(ConstantText.songInfo),
                    ),
                  ];
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
