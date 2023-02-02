import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';

import '../../../common/screen/offline_screen.dart';
import '../../widget/player/player_controller.dart';
import '../../widget/player/player_widgets.dart';

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
                      children: const [
                        PlayerBackground(),
                        PlayerController(),
                        UpNextController()
                      ],
                    ),
                  ),
                  UpNextExpandableWidget(widget: widget)
                ],
              ),
            ),
          );
  }
}
