import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

import '../../../common_widgets/bottom_navigation_bar/bottom_navigation_bar.dart';
import '../../../common_widgets/box/horizontal_box.dart';
import '../../../common_widgets/box/vertical_box.dart';
import '../../player/domain/model/player_song_list_model.dart';
import '../../player/provider/player_provider.dart';
import '../../player/widget/player/player_widgets.dart';
import '../provider/bottom_navigation_bar_provider.dart';
import 'offline_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();
    // context.read<PlayerProvider>().loadSingleQueueSong();
  }

  @override
  void dispose() {
    BottomNavigationBarProvider()
        .pages[BottomNavigationBarProvider().selectedBottomIndex];

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Provider.of<InternetConnectionStatus>(context) ==
                    InternetConnectionStatus.disconnected
                ? const OfflineScreen()
                : Column(
                    children: [
                      Expanded(
                        child: Consumer<BottomNavigationBarProvider>(
                            builder: (context, provider, _) {
                          return provider.pages[provider.selectedBottomIndex];
                        }),
                      ),
                      Consumer<PlayerProvider>(
                          builder: (context, playProvider, _) {
                        return playProvider.isPlaying
                            ? const VerticalBox(height: 60)
                            : const SizedBox.shrink();
                      })
                    ],
                  ),
            SizedBox(
              height: 60,
              child: StreamBuilder<SequenceState?>(
                  stream:
                      context.read<PlayerProvider>().player.sequenceStateStream,
                  builder: (context, snapshot) {
                    final state = snapshot.data;
                    if (state?.sequence.isEmpty ?? true) {
                      return const ColoredBox(
                        color: Colors.black,
                      );
                    }
                    final metadata =
                        state!.currentSource!.tag as PlayerSongListModel;
                    return Row(
                      children: [
                        SizedBox(
                          height: 60,
                          width: 60,
                          child: Image.network(
                            metadata.imageUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const HorizontalBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(metadata.title),
                              Text(metadata.albumName),
                            ],
                          ),
                        ),
                        IconButton(
                          padding: const EdgeInsets.all(0),
                          onPressed: () {
                            context.read<PlayerProvider>().playPrev();
                          },
                          icon: const Icon(Icons.skip_previous_rounded),
                        ),
                        InkWell(
                          onTap: () {
                            context.read<PlayerProvider>().playOrPause();
                          },
                          child: PlayButtonWidget(
                            size: 24.0,
                            padding: 4.0,
                            iconColor: const Color.fromRGBO(255, 255, 255, 0.8),
                            bgColor: const Color.fromRGBO(254, 86, 49, 1),
                            icon: !context.read<PlayerProvider>().isPlay
                                ? Icons.play_arrow
                                : Icons.pause_circle_filled_rounded,
                          ),
                        ),
                        IconButton(
                          padding: const EdgeInsets.all(0),
                          onPressed: () {
                            context.read<PlayerProvider>().playNext();
                          },
                          icon: const Icon(Icons.skip_next_rounded),
                        ),
                      ],
                    );
                  }),
            )
            // Consumer<PlayerProvider>(builder: (context, provider, _) {
            //   return provider.isPlaying
            //       ? Miniplayer(
            //           controller: context.read<PlayerProvider>().controller,
            //           minHeight: 60.0,
            //           maxHeight: MediaQuery.of(context).size.height,
            //           builder: (h, p) => h > 120
            //               ? const PlayerScreen()
            //               : StreamBuilder<SequenceState?>(
            //                   stream: context
            //                       .read<PlayerProvider>()
            //                       .player
            //                       .sequenceStateStream,
            //                   builder: (context, snapshot) {
            //                     final state = snapshot.data;
            //                     if (state?.sequence.isEmpty ?? true) {
            //                       return const ColoredBox(
            //                         color: Colors.black,
            //                       );
            //                     }
            //                     final metadata = state!.currentSource!.tag
            //                         as PlayerSongListModel;
            //                     return Row(
            //                       children: [
            //                         SizedBox(
            //                           height: 60,
            //                           width: 60,
            //                           child: Image.network(
            //                             metadata.imageUrl,
            //                             fit: BoxFit.cover,
            //                           ),
            //                         ),
            //                         const HorizontalBox(width: 10),
            //                         Expanded(
            //                           child: Column(
            //                             crossAxisAlignment:
            //                                 CrossAxisAlignment.start,
            //                             mainAxisAlignment:
            //                                 MainAxisAlignment.center,
            //                             children: [
            //                               Text(metadata.title),
            //                               Text(metadata.albumName),
            //                             ],
            //                           ),
            //                         ),
            //                         IconButton(
            //                           padding: const EdgeInsets.all(0),
            //                           onPressed: () {
            //                             context
            //                                 .read<PlayerProvider>()
            //                                 .playPrev();
            //                           },
            //                           icon: const Icon(
            //                               Icons.skip_previous_rounded),
            //                         ),
            //                         InkWell(
            //                           onTap: () {
            //                             context
            //                                 .read<PlayerProvider>()
            //                                 .playOrPause();
            //                           },
            //                           child: PlayButtonWidget(
            //                             size: 24.0,
            //                             padding: 4.0,
            //                             iconColor: const Color.fromRGBO(
            //                                 255, 255, 255, 0.8),
            //                             bgColor: const Color.fromRGBO(
            //                                 254, 86, 49, 1),
            //                             icon: !context
            //                                     .read<PlayerProvider>()
            //                                     .isPlay
            //                                 ? Icons.play_arrow
            //                                 : Icons.pause_circle_filled_rounded,
            //                           ),
            //                         ),
            //                         IconButton(
            //                           padding: const EdgeInsets.all(0),
            //                           onPressed: () {
            //                             context
            //                                 .read<PlayerProvider>()
            //                                 .playNext();
            //                           },
            //                           icon: const Icon(Icons.skip_next_rounded),
            //                         ),
            //                       ],
            //                     );
            //                   }))
            //       : const SizedBox.shrink();
            // }),
          ],
        ),
        bottomNavigationBar: BottomNavigationBarWidget(
          width: width,
        ),
      ),
    );
  }
}
