import 'package:flutter/material.dart';
import 'package:musiq/src/features/library/domain/models/favourite_model.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/constant.dart';
import '../../../../core/utils/url_generate.dart';
import '../../../auth/provider/login_provider.dart';
import '../../../common/provider/pop_up_provider.dart';
import '../../../payment/screen/subscription_screen.dart';
import '../../../player/domain/model/player_song_list_model.dart';
import '../../../player/provider/player_provider.dart';

class FavouritesPopUpMenuButton extends StatelessWidget {
  const FavouritesPopUpMenuButton({
    Key? key,
    required this.record,
    required this.index,
  }) : super(key: key);

  final List<Record> record;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Padding(
      padding: const EdgeInsets.only(right: 0.0),
      child: Align(
        // alignment: Alignment.centerRight,
        child: PopupMenuButton(
          color: CustomColor.appBarColor,
          shape: popUpDecorationContainer(),
          onSelected: (value) {
            PlayerSongListModel playerSongListModel = PlayerSongListModel(
                id: record[index].id,
                albumName: record[index].albumName,
                title: record[index].songName,
                imageUrl: generateSongImageUrl(
                    record[index].albumName, record[index].albumId),
                musicDirectorName: record[index].musicDirectorName[0],
                duration: record[index].duration,
                premium: record[index].premiumStatus);
            switch (value) {
              case PopUpConstants.playNext:
                if (record[index].premiumStatus == "premium" &&
                    context
                            .read<LoginProvider>()
                            .userModel!
                            .records
                            .premiumStatus ==
                        "free") {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SubscriptionsScreen()));
                } else {
                  context
                      .read<PopUpProvider>()
                      .playNext(playerSongListModel, context);
                }
                break;
              case PopUpConstants.addToQueue:
                if (record[index].premiumStatus == "premium" &&
                    context
                            .read<LoginProvider>()
                            .userModel!
                            .records
                            .premiumStatus ==
                        "free") {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SubscriptionsScreen()));
                } else {
                  context
                      .read<PopUpProvider>()
                      .addToQueue(playerSongListModel, context);
                }
                break;

              case PopUpConstants.removeFavourite:
                if (record[index].premiumStatus == "premium" &&
                    context
                            .read<LoginProvider>()
                            .userModel!
                            .records
                            .premiumStatus ==
                        "free") {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SubscriptionsScreen()));
                } else {
                  context
                      .read<PopUpProvider>()
                      .removeFromFavourites(playerSongListModel.id, context);
                }
                break;
              case PopUpConstants.songInfo:
                if (record[index].premiumStatus == "premium" &&
                    context
                            .read<LoginProvider>()
                            .userModel!
                            .records
                            .premiumStatus ==
                        "free") {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SubscriptionsScreen()));
                } else {
                  context
                      .read<PopUpProvider>()
                      .goToSongInfo(playerSongListModel.id, context);
                }
                break;
            }
          },
          itemBuilder: (ctx) {
            return [
              PopupMenuItem(
                value: PopUpConstants.playNext,
                enabled: context.read<PlayerProvider>().isPlaying,
                child: const Text(ConstantText.playNext),
              ),
              PopupMenuItem(
                value: PopUpConstants.addToQueue,
                enabled: context.read<PlayerProvider>().isPlaying,
                child: const Text(ConstantText.addToQueue),
              ),
              const PopupMenuItem(
                value: PopUpConstants.removeFavourite,
                child: Text(ConstantText.remove),
              ),
              const PopupMenuItem(
                value: PopUpConstants.songInfo,
                child: Text(ConstantText.songInfo),
              ),
            ];
          },
        ),
      ),
    ));
  }
}
