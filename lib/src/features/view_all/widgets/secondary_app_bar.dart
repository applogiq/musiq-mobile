import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants/color.dart';
import '../../../utils/image_url_generate.dart';
import '../../home/provider/artist_view_all_provider.dart';
import '../../player/domain/model/player_song_list_model.dart';
import '../../player/provider/player_provider.dart';
import '../../player/screen/player_screen/player_controller.dart';

class FixedAppBar extends StatelessWidget {
  const FixedAppBar({
    Key? key,
    required this.titleOpacity,
    required this.title,
    required this.size,
  }) : super(key: key);

  final double size;
  final String title;
  final double titleOpacity;

  PopupMenuItem _buildPopupMenuItem(String title, String routeName) {
    return PopupMenuItem(
      onTap: () {
        if (routeName == "hide") {
          // setState(() {
          //   hideLyrics;
          // });
        } else {}
      },
      child: Text(title),
    );
  }

  @override
  Widget build(BuildContext context) {
    return titleOpacity < 0.5
        ? Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: const Icon(
                    Icons.arrow_back_ios_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            ],
          )
        : AnimatedOpacity(
            opacity: size > 0.3 ? titleOpacity.clamp(size, 1) : 1,
            duration: const Duration(milliseconds: 100),
            child: ColoredBox(
              color: Colors.black,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 0.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: const Icon(
                        Icons.arrow_back_ios_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                  // Text("Trending hits"), Spacer(),

                  const SizedBox(width: 10),

                  Expanded(
                    child: AnimatedOpacity(
                      opacity: size,
                      duration: const Duration(milliseconds: 100),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 0.0),
                        child: Text(title,
                            maxLines: 1,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                            )),
                      ),
                    ),
                  ),
                  // const Spacer(),
                  Consumer<ArtistViewAllProvider>(builder: (context, pro, _) {
                    return InkWell(
                      onTap: () {
                        List<PlayerSongListModel> playerSongList = [];

                        for (var record in pro.collectionViewAllModel.records) {
                          playerSongList.add(PlayerSongListModel(
                              id: record!.id,
                              albumName: record.albumName.toString(),
                              title: record.songName.toString(),
                              imageUrl: generateSongImageUrl(
                                  record.albumName, record.albumId),
                              musicDirectorName:
                                  record.musicDirectorName![0].toString()));
                        }
                        context
                            .read<PlayerProvider>()
                            .goToPlayer(context, playerSongList, 0);
                      },
                      child: PlayButtonWidget(
                        bgColor: CustomColor.secondaryColor,
                        iconColor: CustomColor.playIconBg,
                      ),
                    );
                  }),
                  AnimatedOpacity(
                    opacity: titleOpacity.clamp(0, 1),
                    duration: const Duration(milliseconds: 100),
                    child: PopupMenuButton(
                        color: CustomColor.appBarColor,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(8.0),
                            bottomRight: Radius.circular(8.0),
                            topLeft: Radius.circular(8.0),
                            topRight: Radius.circular(8.0),
                          ),
                        ),
                        padding: const EdgeInsets.all(0.0),
                        itemBuilder: (ctx) => [
                              _buildPopupMenuItem('Add to queue', 'share'),
                              _buildPopupMenuItem(
                                  'Add to playlist', "song_info"),
                            ]),
                  ),
                ],
              ),
            ),
          );
  }
}
