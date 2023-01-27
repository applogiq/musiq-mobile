import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:musiq/src/features/home/provider/artist_view_all_provider.dart';
import 'package:musiq/src/features/player/screen/player_screen/player_background.dart';
import 'package:musiq/src/features/player/screen/player_screen/player_controller.dart';
import 'package:musiq/src/features/player/screen/player_screen/up_next.dart';
import 'package:provider/provider.dart';

import '../../../../common_widgets/container/empty_box.dart';
import '../../../common/screen/offline_screen.dart';

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
                                  children: const [
                                    UpNext(),
                                    // Text(
                                    //   widget.playerModel.collectionViewAllModel
                                    //       .records[1]!.songName
                                    //       .toString(),
                                    //   style: fontWeight400(size: 14.0),
                                    // )
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
