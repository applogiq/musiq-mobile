import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musiq/src/core/constants/images.dart';
import 'package:musiq/src/features/player/widget/player/player_pop_up_menu.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/constant.dart';
import '../../../home/provider/artist_view_all_provider.dart';
import '../../domain/model/player_song_list_model.dart';
import '../../provider/player_provider.dart';

class PlayerBackground extends StatelessWidget {
  const PlayerBackground({super.key, required this.onTapped});
  final Function onTapped;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 6,
      child: Consumer<ArtistViewAllProvider>(
        builder: (context, pro, _) {
          return Consumer<PlayerProvider>(
            builder: (context, playerProvider, _) {
              return StreamBuilder<SequenceState?>(
                stream:
                    context.read<PlayerProvider>().player.sequenceStateStream,
                builder: (context, snapshot) {
                  final state = snapshot.data;
                  if (state?.sequence.isEmpty ?? true) {
                    return const SizedBox();
                  }
                  final metadata = state!.currentSource!.tag as MediaItem;

                  PlayerSongListModel playerSongListModel = PlayerSongListModel(
                      id: metadata.extras!["song_id"],
                      duration: metadata.duration.toString(),
                      albumName: metadata.album.toString(),
                      title: metadata.title,
                      imageUrl: metadata.artUri.toString(),
                      musicDirectorName: metadata.artist!,
                      premium: 'free',
                      isImage: metadata.extras!["isImage"]);
                  return Container(
                    decoration: metadata.extras!["isImage"]
                        ? BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(
                                  metadata.artUri.toString(),
                                ),
                                fit: BoxFit.fill))
                        : BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(Images.noSong
                                    // metadata.artUri.toString(),
                                    ),
                                fit: BoxFit.fill)),
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
                          padding:
                              const EdgeInsets.fromLTRB(12.0, 12.0, 0.0, 0.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () {
                                  onTapped();
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
