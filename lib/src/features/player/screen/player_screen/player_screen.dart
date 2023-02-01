import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musiq/src/features/player/provider/player_provider.dart';
import 'package:provider/provider.dart';

import '../../../../common_widgets/container/empty_box.dart';
import '../../../../constants/style.dart';
import '../../../common/screen/offline_screen.dart';
import '../../../home/provider/artist_view_all_provider.dart';
import '../../domain/model/player_song_list_model.dart';
import 'player_background.dart';
import 'player_controller.dart';
import 'up_next.dart';

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({
    super.key,
  });

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // context.read<PlayerProvider>().loadSong(widget.playerModel);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Provider.of<InternetConnectionStatus>(context) ==
            InternetConnectionStatus.disconnected
        ? const OfflineScreen()
        : Scaffold(
            body: SingleChildScrollView(
                child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: [
                    const PlayerBackground(),
                    const PlayerController(),
                    Consumer<PlayerProvider>(builder: (context, pro, _) {
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
                                    Consumer<PlayerProvider>(
                                        builder: (context, playerProvider, _) {
                                      return StreamBuilder<SequenceState?>(
                                          stream: playerProvider
                                              .player.sequenceStateStream,
                                          builder: (context, snapshot) {
                                            final state = snapshot.data;
                                            if (state?.sequence.isEmpty ??
                                                true) {
                                              return const ColoredBox(
                                                color: Colors.black,
                                              );
                                            }
                                            PlayerSongListModel? metadata;
                                            try {
                                              metadata = state!
                                                  .effectiveSequence[
                                                      state.currentIndex + 1]
                                                  .tag as PlayerSongListModel;
                                            } catch (e) {
                                              metadata = null;
                                            }
                                            return Text(
                                              metadata != null
                                                  ? metadata.title.toString()
                                                  : "",
                                              style: fontWeight400(size: 14.0),
                                            );
                                          });
                                    })
                                  ],
                                ),
                                trailing: const Icon(Icons.keyboard_arrow_up),
                              ),
                            );
                    }),
                  ],
                ),
              ),
              UpNextExpandableWidget(widget: widget)
            ],
          )));
  }
}

class UpNextExpandableWidget extends StatelessWidget {
  const UpNextExpandableWidget({
    Key? key,
    required this.widget,
  }) : super(key: key);

  final PlayerScreen widget;

  @override
  Widget build(BuildContext context) {
    return Consumer<ArtistViewAllProvider>(builder: (context, pro, _) {
      return const SizedBox(
        child:
            //  pro.isUpNextShow
            //     ? UpNextExpandable(
            //         playerModel: widget.playerModel,
            //       )
            //     :
            EmptyBox(),
      );
    });
  }
}
