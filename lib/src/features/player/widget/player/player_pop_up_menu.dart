import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../constants/constant.dart';
import '../../../common/provider/pop_up_provider.dart';
import '../../domain/model/player_song_list_model.dart';

class PlayerPopUpMenu extends StatelessWidget {
  const PlayerPopUpMenu({
    Key? key,
    required this.metadata,
  }) : super(key: key);

  final PlayerSongListModel metadata;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.all(0.0),
      onSelected: (value) {
        switch (value) {
          case PopUpConstants.share:
            context.read<PopUpProvider>().share();
            break;
          case PopUpConstants.songInfo:
            context.read<PopUpProvider>().goToSongInfo(metadata.id, context);
            break;
        }
      },
      itemBuilder: (ctx) => [
        const PopupMenuItem(
          value: PopUpConstants.share,
          child: Text(ConstantText.share),
        ),
        const PopupMenuItem(
          value: PopUpConstants.songInfo,
          child: Text(ConstantText.songInfo),
        ),
      ],
    );
  }
}
