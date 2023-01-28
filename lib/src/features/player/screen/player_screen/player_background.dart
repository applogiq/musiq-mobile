import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/package/miniplayer/miniplayer.dart';
import '../../../../routing/route_name.dart';
import '../../../../utils/navigation.dart';
import '../../../home/provider/artist_view_all_provider.dart';
import '../../domain/model/player_song_list_model.dart';
import '../../provider/player_provider.dart';

class PlayerBackground extends StatelessWidget {
  const PlayerBackground({
    super.key,
  });
  // final PlayerModel playerModel;
  PopupMenuItem _buildPopupMenuItem(String title, String routeName,
      BuildContext context, PlayerSongListModel playerSongListModel) {
    return PopupMenuItem(
      // onTap: () async {
      // await Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => const SongInfoScreen()),
      // );
      // },
      child: InkWell(
          onTap: () async {
            if (routeName == RouteName.songInfo) {
              Navigator.pop(context);
              Navigation.navigateToScreen(context, routeName,
                  args: playerSongListModel);
              // await Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //       builder: (context) => SongInfoScreen(
              //             playerSongListModel: playerSongListModel,
              //           )),
              // );
            } else if (routeName == "share") {
              Share.share(
                  'check out MusiQ app\n https://play.google.com/store/apps/details?id=app.gotoz.parent');
            }
          },
          child: Text(title)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: 6,
        child: Consumer<ArtistViewAllProvider>(builder: (context, pro, _) {
          return Consumer<PlayerProvider>(
              builder: (context, playerProvider, _) {
            return StreamBuilder<SequenceState?>(
                stream: playerProvider.player.sequenceStateStream,
                builder: (context, snapshot) {
                  final state = snapshot.data;
                  if (state?.sequence.isEmpty ?? true) {
                    return const ColoredBox(
                      color: Colors.black,
                    );
                  }
                  final metadata =
                      state!.currentSource!.tag as PlayerSongListModel;
                  return Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(metadata.imageUrl),
                            fit: BoxFit.cover)),
                    child: Stack(children: [
                      Container(
                        decoration: const BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                stops: [
                              0.6,
                              0.99
                            ],
                                colors: [
                              Color.fromRGBO(22, 21, 28, 0),
                              Color.fromRGBO(22, 21, 28, 1),
                            ])),
                      ),
                      Column(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      //     stops: [
                                      //   0.4,
                                      //   0.01,
                                      // ],
                                      colors: [
                                    Color.fromRGBO(22, 21, 28, 0.3),
                                    Color.fromRGBO(22, 21, 28, 0),
                                  ])),
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
                                  bool canPop = Navigator.of(context).canPop();
                                  debugPrint(canPop.toString());
                                  if (!canPop) {
                                    if (context
                                        .read<PlayerProvider>()
                                        .isPlaying) {
                                      context
                                          .read<PlayerProvider>()
                                          .controller
                                          .animateToHeight(
                                              state: PanelState.MIN);
                                    }
                                  } else {
                                    Navigator.of(context).pop();
                                  }
                                },
                                child: const Icon(
                                    Icons.arrow_back_ios_new_rounded)),
                            PopupMenuButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              padding: const EdgeInsets.all(0.0),
                              itemBuilder: (ctx) => [
                                _buildPopupMenuItem(
                                    'Share', 'share', context, metadata),
                                _buildPopupMenuItem('Song Info',
                                    RouteName.songInfo, context, metadata),
                                // _buildPopupMenuItem(
                                //     'Show Lyrics', "hide", context, metadata),
                              ],
                            )
                          ],
                        ),
                      ),
                    ]),
                  );
                });
          });
        }));
  }
}
