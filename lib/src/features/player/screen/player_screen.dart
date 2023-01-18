import 'package:flutter/material.dart';
import 'package:musiq/src/common_widgets/box/vertical_box.dart';
import 'package:musiq/src/features/home/provider/artist_view_all_provider.dart';
import 'package:musiq/src/features/player/provider/extension/player_controller_extension.dart';
import 'package:musiq/src/features/player/provider/player_provider.dart';
import 'package:musiq/src/features/player/screen/reorder_list_tile.dart';
import 'package:musiq/src/features/view_all/domain/model/player_model.dart';
import 'package:provider/provider.dart';

import '../../../common_widgets/container/empty_box.dart';
import '../../../constants/color.dart';
import '../../../constants/style.dart';
import '../../../core/package/audio_progress_bar.dart';
import '../../../utils/image_url_generate.dart';

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({super.key, required this.playerModel});
  final PlayerModel playerModel;

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      context.read<PlayerProvider>().loadSong(widget.playerModel.songList);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Stack(
      alignment: Alignment.bottomCenter,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              PlayerBackground(playerModel: widget.playerModel),
              const PlayerController(),
              Consumer<ArtistViewAllProvider>(builder: (context, pro, _) {
                return pro.isUpNextShow
                    ? const SizedBox.shrink()
                    : Container(
                        decoration: const BoxDecoration(
                            color: Color.fromRGBO(33, 33, 44, 1),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30))),
                        child: ListTile(
                          onTap: () {
                            context
                                .read<ArtistViewAllProvider>()
                                .toggleUpNext();
                          },
                          title: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const UpNext(),
                              Text(
                                widget.playerModel.collectionViewAllModel
                                    .records[1]!.songName
                                    .toString(),
                                style: fontWeight400(size: 14.0),
                              )
                            ],
                          ),
                          trailing: const Icon(Icons.keyboard_arrow_up),
                        ),
                      );
              }),
            ],
          ),
        ),
        Consumer<ArtistViewAllProvider>(builder: (context, pro, _) {
          return SizedBox(
            child: pro.isUpNextShow
                ? UpNextExpandable(
                    playerModel: widget.playerModel,
                  )
                : const EmptyBox(),
          );
        })
      ],
    )));
  }
}

class UpNextExpandable extends StatelessWidget {
  const UpNextExpandable({
    Key? key,
    required this.playerModel,
  }) : super(key: key);
  final PlayerModel playerModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height - 40,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
      decoration: const BoxDecoration(
        color: Color.fromRGBO(33, 33, 44, 1),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          ListTile(
            title: const UpNext(),
            trailing: InkWell(
                onTap: () {
                  context.read<ArtistViewAllProvider>().toggleUpNext();
                  // songController.isBottomSheetView.toggle();
                },
                child: const Icon(Icons.keyboard_arrow_down_rounded)),
          ),
          ReorderListUpNextSongTile(
              playScreenModel: playerModel.collectionViewAllModel, index: 0)
        ],
      ),
    );
  }
}

class UpNext extends StatelessWidget {
  const UpNext({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      "Up next",
      style: fontWeight500(size: 16.0),
    );
  }
}

class PlayerController extends StatelessWidget {
  const PlayerController({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 5,
      child: Column(
        children: [
          const VerticalBox(height: 18),
          Consumer<ArtistViewAllProvider>(
            builder: (context, pro, _) {
              return Column(
                children: [
                  Text(
                      pro.collectionViewAllModel.records[0]!.songName
                          .toString(),
                      style: fontWeight500(size: 16.0)),
                  Text(
                    pro.collectionViewAllModel.records[0]!.musicDirectorName![0]
                        .toString(),
                    style:
                        fontWeight400(size: 14.0, color: CustomColor.subTitle),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                            onTap: () async {
                              // songController.shuffleSong();
                            },
                            child: const Icon(
                              Icons.shuffle_rounded,
                              color: Colors.white,
                            )),
                        InkWell(
                            onTap: () {
                              // print(playScreenModel[index].id);
                              // songController.checkFav();
                            },
                            child: const Icon(
                              Icons.favorite_rounded,
                              color: Colors.white,
                            )),
                      ],
                    ),
                  ),
                  const ProgressBarWidget(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const InkWell(
                          child: Icon(Icons.playlist_add_rounded, size: 34)),
                      PlayNextPrev(
                        onTap: () {
                          context.read<PlayerProvider>().playPrev();
                        },
                        iconData: Icons.skip_previous_rounded,
                      ),
                      const PlayPauseController(),
                      PlayNextPrev(
                        onTap: () {
                          context.read<PlayerProvider>().playNext();
                        },
                        iconData: Icons.skip_next_rounded,
                      ),
                      InkWell(
                          onTap: () async {},
                          child: const Icon(
                            Icons.repeat_rounded,
                            size: 34,
                            color: Colors.white,
                          ))
                    ],
                  )
                ],
              );
            },
          )
        ],
      ),
    );
  }
}

class PlayerBackground extends StatelessWidget {
  const PlayerBackground({super.key, required this.playerModel});
  final PlayerModel playerModel;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: 6,
        child: Consumer<ArtistViewAllProvider>(builder: (context, pro, _) {
          return Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(generateSongImageUrl(
                      playerModel.collectionViewAllModel.records[0]!.albumName
                          .toString(),
                      playerModel.collectionViewAllModel.records[0]!.albumId
                          .toString(),
                    )
                        // playScreenModel[index].
                        // "https://mir-s3-cdn-cf.behance.net/project_modules/fs/fe529a64193929.5aca8500ba9ab.jpg",
                        // "${APIConstants.SONG_BASE_URL}public/music/tamil/${ playScreenModel[index].albumName[0].toUpperCase()}/${ playScreenModel[index].albumName}/image/${ playScreenModel[index].albumId}.png"
                        ),
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
              Container(
                child: Column(
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
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                        onTap: () {
                          // songController.player.stop();
                          Navigator.of(context).pop();
                        },
                        child: const Icon(Icons.arrow_back_ios_new_rounded)),
                    PopupMenuButton(
                      shape: const RoundedRectangleBorder(),
                      padding: const EdgeInsets.all(0.0),
                      itemBuilder: (ctx) => [
                        //   _buildPopupMenuItem(
                        //       'Share', 'share'),
                        //   _buildPopupMenuItem(
                        //       'Song Info', "song_info"),
                        //   _buildPopupMenuItem(
                        //       songController
                        //               .isLyricsHide.value
                        //           ? 'Show Lyrics'
                        //           : 'Hide Lyrics',
                        //       "hide"),
                      ],
                    )
                  ],
                ),
              ),
            ]),
          );
        }));
  }
}

class PlayNextPrev extends StatelessWidget {
  const PlayNextPrev({
    Key? key,
    required this.onTap,
    required this.iconData,
  }) : super(key: key);
  final Function onTap;
  final IconData iconData;
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          onTap();
        },
        child: Icon(
          iconData,
          size: 34,
        ));
  }
}

class ProgressBarWidget extends StatelessWidget {
  const ProgressBarWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ProgressBar(
        progress: const Duration(milliseconds: 5000),
        buffered: const Duration(milliseconds: 20003),
        total: const Duration(milliseconds: 125500),
        progressBarColor: CustomColor.secondaryColor,
        baseBarColor: Colors.white.withOpacity(0.24),
        bufferedBarColor: Colors.white.withOpacity(0.24),
        thumbColor: Colors.white,
        barHeight: 6.0,
        thumbRadius: 6.0,
        onSeek: (duration) {
          // songController.seekDuration(duration);
        },
      ),
    );
  }
}

class PlayPauseController extends StatelessWidget {
  const PlayPauseController({
    Key? key,
  }) : super(key: key);

  // final SongController songController;

  @override
  Widget build(BuildContext context) {
    return Consumer<PlayerProvider>(builder: (context, pro, _) {
      return InkWell(
        onTap: () {
          pro.playOrPause();
        },
        child: pro.isPlay
            ? PlayButtonWidget(
                bgColor: CustomColor.secondaryColor,
                iconColor: Colors.white,
                size: 34.0,
                padding: 14.0,
                icon: Icons.pause_rounded,
              )
            : PlayButtonWidget(
                bgColor: CustomColor.secondaryColor,
                iconColor: Colors.white,
                size: 34.0,
                padding: 14.0,
              ),
      );
    });
  }
}

class PlayButtonWidget extends StatelessWidget {
  PlayButtonWidget(
      {Key? key,
      this.bgColor = const Color.fromRGBO(255, 255, 255, 0.8),
      this.iconColor = const Color.fromRGBO(254, 86, 49, 1),
      this.size = 20.0,
      this.padding = 6.0,
      this.icon = Icons.play_arrow})
      : super(key: key);
  var bgColor;
  var iconColor;
  var size;
  var padding;
  var icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
      child: Icon(
        icon,
        size: size,
        color: iconColor,
      ),
    );
  }
}
