import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/constant.dart';
import '../../provider/player_provider.dart';
import 'player_widgets.dart';

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
