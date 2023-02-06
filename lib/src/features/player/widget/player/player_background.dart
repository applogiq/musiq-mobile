import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musiq/src/common_widgets/loader.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/constant.dart';
import '../../../../core/package/miniplayer/miniplayer.dart';
import '../../../home/provider/artist_view_all_provider.dart';
import '../../domain/model/player_song_list_model.dart';
import '../../provider/player_provider.dart';
import 'player_widgets.dart';

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
              return StreamBuilder<SequenceState?>(
                stream: playerProvider.player.sequenceStateStream,
                builder: (context, snapshot) {
                  final state = snapshot.data;
                  if (state?.sequence.isEmpty ?? true) {
                    return const LoaderScreen();
                  }
                  final metadata =
                      state!.currentSource!.tag as PlayerSongListModel;
                  return Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(metadata.imageUrl),
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
                                child: const Icon(
                                    Icons.arrow_back_ios_new_rounded),
                              ),
                              PlayerPopUpMenu(metadata: metadata)
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
      if (context.read<PlayerProvider>().isPlaying) {
        context
            .read<PlayerProvider>()
            .controller
            .animateToHeight(state: PanelState.MIN);
      }
    } else {
      Navigator.of(context).pop();
    }
  }
}
