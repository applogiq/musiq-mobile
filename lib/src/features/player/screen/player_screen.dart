import 'package:flutter/material.dart';
import 'package:musiq/src/features/player/provider/player_provider.dart';
import 'package:provider/provider.dart';

import '../../../constants/color.dart';

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({super.key});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      context.read<PlayerProvider>().loadSong();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Theme(
            data: ThemeData(
                iconTheme: const IconThemeData(size: 32, color: Colors.white)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // InkWell(
                //     onTap: () {
                //       songController
                //           .songList[songController.player.currentIndex ?? 0].id;
                //       print(songController
                //           .songList[songController.player.currentIndex ?? 0].id);
                //       Navigator.of(context).push(MaterialPageRoute(
                //           builder: (context) => AddToPlaylist(
                //                 song_id: songController
                //                     .songList[
                //                         songController.player.currentIndex ?? 0]
                //                     .id,
                //               )));
                //     },
                //     child: Icon(Icons.playlist_add_rounded, size: 34)),
                // PlayPrevious(songController: songController),
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
                // RepeatSong(songController: songController),
              ],
            ),
          ),
        ),
      ),
    );
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


// class PlayPrevious extends StatelessWidget {
//   const PlayPrevious({
//     Key? key,
//     required this.songController,
//   }) : super(key = key);

//   final SongController songController;

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//         onTap: () {
//           songController.playPrev();
//         },
//         child: const Icon(
//           Icons.skip_previous_rounded,
//           size: 34,
//         ));
//   }
// }