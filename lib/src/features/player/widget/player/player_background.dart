import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:musiq/src/common_widgets/loader.dart';
import 'package:musiq/src/features/player/widget/player/player_pop_up_menu.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/constant.dart';
import '../../../home/provider/artist_view_all_provider.dart';
import '../../domain/model/player_song_list_model.dart';
import '../../provider/player_provider.dart';

class PlayerBackground extends StatelessWidget {
  const PlayerBackground({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 6,
      child: Consumer<ArtistViewAllProvider>(
        builder: (context, pro, _) {
          return Consumer<PlayerProvider>(
            builder: (context, playerProvider, _) {
              return StreamBuilder<MediaItem?>(
                stream: context.read<PlayerProvider>().audioHandler!.mediaItem,
                builder: (context, snapshot) {
                  MediaItem? mediaItem = snapshot.data;

                  if (mediaItem == null) {
                    return const LoaderScreen();
                  }
                  PlayerSongListModel playerSongListModel = PlayerSongListModel(
                      id: mediaItem.extras!["song_id"],
                      duration: mediaItem.duration.toString(),
                      albumName: mediaItem.album.toString(),
                      title: mediaItem.title,
                      imageUrl: mediaItem.artUri.toString(),
                      musicDirectorName: mediaItem.artist!);
                  return Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(
                              mediaItem.artUri.toString(),
                            ),
                            fit: BoxFit.cover)),
                    child: Stack(
                      children: [
                        Container(
                          decoration: playerDownImageDecoration(),
                        ),
                        Column(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: playerUpImageDecoration(),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () {
                                  checkBackNavigation(context);
                                },
                                child: const RotatedBox(
                                  quarterTurns: 3,
                                  child: Icon(Icons.arrow_back_ios_new_rounded),
                                ),
                              ),
                              PlayerPopUpMenu(metadata: playerSongListModel)
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  checkBackNavigation(BuildContext context) {
    bool canPop = Navigator.of(context).canPop();

    if (!canPop) {
      // if (context.read<PlayerProvider>().isPlaying) {
      //   context
      //       .read<PlayerProvider>()
      //       .controller
      //       .animateToHeight(state: PanelState.MIN);
      // }
    } else {
      Navigator.of(context).pop();
    }
  }
}
