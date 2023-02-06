import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../common_widgets/container/custom_color_container.dart';
import '../../../../../core/constants/constant.dart';
import '../../../../../core/routing/route_name.dart';
import '../../../../../core/utils/navigation.dart';
import '../../../../player/domain/model/player_song_list_model.dart';
import '../../../../player/provider/player_provider.dart';

class SongListTile extends StatelessWidget {
  const SongListTile({
    super.key,
    required this.imageUrl,
    required this.songName,
    required this.musicDirectorName,
    required this.songId,
    required this.albumName,
    required this.duration,
  });

  final String albumName;
  final String imageUrl;
  final String musicDirectorName;
  final int songId;
  final String songName;
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
                )),
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
                    case 1:
                      context.read<PlayerProvider>().addFavourite(songId);
                      break;
                    case 2:
                      Navigation.navigateToScreen(
                          context, RouteName.addPlaylist,
                          args: songId.toString());
                      break;

                    case 3:
                      PlayerSongListModel playerSongListModel =
                          PlayerSongListModel(
                              id: songId,
                              albumName: albumName,
                              title: songName,
                              imageUrl: imageUrl,
                              musicDirectorName: musicDirectorName,
                              duration: duration);
                      context
                          .read<PlayerProvider>()
                          .queuePlayNext(playerSongListModel);
                      break;
                    case 4:
                      PlayerSongListModel playerSongListModel =
                          PlayerSongListModel(
                              id: songId,
                              albumName: albumName,
                              title: songName,
                              imageUrl: imageUrl,
                              musicDirectorName: musicDirectorName,
                              duration: duration);
                      Navigation.navigateToScreen(context, RouteName.songInfo,
                          args: playerSongListModel);
                      break;
                    case 5:
                      PlayerSongListModel playerSongListModel =
                          PlayerSongListModel(
                              id: songId,
                              albumName: albumName,
                              title: songName,
                              imageUrl: imageUrl,
                              musicDirectorName: musicDirectorName,
                              duration: duration);
                      // Navigation.navigateToScreen(context, RouteName.songInfo,
                      //     args: playerSongListModel);
                      context.read<PlayerProvider>().addQueueToLocalDb(
                            playerSongListModel,
                          );
                      break;
                  }
                },
                itemBuilder: (BuildContext context) {
                  return [
                    const PopupMenuItem(
                      value: 1,
                      child: Text('Add to Favourites'),
                    ),
                    const PopupMenuItem(
                      value: 2,
                      child: Text('Add to Playlist'),
                    ),
                    const PopupMenuItem(
                      value: 5,
                      child: Text('Add to Queue'),
                    ),
                    const PopupMenuItem(
                      value: 3,
                      child: Text('Play next'),
                    ),
                    const PopupMenuItem(
                      value: 4,
                      child: Text('Song info'),
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
