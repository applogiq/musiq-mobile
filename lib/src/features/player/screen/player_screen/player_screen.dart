import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musiq/src/common_widgets/buttons/custom_button.dart';
import 'package:musiq/src/core/package/we_slide/src/weslide_controller.dart';
import 'package:musiq/src/core/utils/size_config.dart';
import 'package:musiq/src/features/player/provider/player_provider.dart';
import 'package:provider/provider.dart';

import '../../../common/screen/offline_screen.dart';
import '../../widget/player/player_controller.dart';
import '../../widget/player/player_widgets.dart';

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({
    super.key,
    required this.onTap,
  });
  final Function onTap;

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen>
    with WidgetsBindingObserver {
  final WeSlideController controller = WeSlideController();
  AudioPlayer player = AudioPlayer();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // context.read<PlayerProvider>().loadSong(widget.playerModel);
    });
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    player.pause();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // log(controller.toString());

    return Provider.of<InternetConnectionStatus>(context) ==
            InternetConnectionStatus.disconnected
        ? const OfflineScreen()
        : SafeArea(
            child: Scaffold(
              body: Consumer<PlayerProvider>(
                builder: (context, value, child) => StreamBuilder<
                        SequenceState?>(
                    stream: context
                        .read<PlayerProvider>()
                        .player
                        .sequenceStateStream,
                    builder: (context, snapshot) {
                      final state = snapshot.data;
                      if (state?.sequence.isEmpty ?? true) {
                        log("0object");
                        return Center(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          // crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset("assets/images/default/no_song.png"),
                            SizedBox(
                              height: getProportionateScreenHeight(20),
                            ),
                            const Text(
                              "No songs here...",
                              style: TextStyle(fontSize: 20),
                            ),
                            SizedBox(
                              height: getProportionateScreenHeight(20),
                            ),
                            controller.isOpened
                                ? InkWell(
                                    onTap: () {
                                      widget.onTap;
                                      controller.hide();
                                    },
                                    child: const SizedBox.shrink()
                                    //  const Padding(
                                    //   padding: EdgeInsets.all(20.0),
                                    //   child:
                                    //       CustomButton(label: "Back to home screen"),
                                    // ),
                                    )
                                : InkWell(
                                    onTap: () {
                                      // print("111111111111111111111111");
                                      Navigator.pop(context);
                                    },
                                    child: const Padding(
                                      padding: EdgeInsets.all(20.0),
                                      child: CustomButton(
                                          label: "Back to home screen"),
                                    ),
                                  )
                          ],
                        ));
                      }
                      return SingleChildScrollView(
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height - 30,
                              child: Column(
                                children: [
                                  PlayerBackground(
                                    onTapped: widget.onTap,
                                  ),
                                  const PlayerController(),
                                  const UpNextController()
                                ],
                              ),
                            ),
                            UpNextExpandableWidget(widget: widget)
                          ],
                        ),
                      );
                    }),
              ),
            ),
          );
  }
}
