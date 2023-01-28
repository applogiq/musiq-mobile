import 'package:flutter/material.dart';
import 'package:musiq/src/features/home/provider/artist_view_all_provider.dart';
import 'package:provider/provider.dart';

import '../../../../../common_widgets/buttons/custom_button.dart';
import '../../../../../constants/color.dart';
import '../../../../../constants/style.dart';

class AppBarOverlayContent extends StatelessWidget {
  const AppBarOverlayContent(
      {Key? key,
      required this.title,
      required this.count,
      required this.callback,
      required this.size})
      : super(key: key);

  final String title;
  final int count;
  final VoidCallback callback;
  final double size;
  PopupMenuItem _buildPopupMenuItem(String title, String routeName) {
    return PopupMenuItem(
      onTap: () {
        if (routeName == "hide") {
          // setState(() {
          //   hideLyrics;
          // });
        } else {
          debugPrint(routeName);
        }
      },
      child: Text(title),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Spacer(),
            AnimatedOpacity(
              opacity: (size - 1.0).abs(),
              duration: const Duration(milliseconds: 100),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: fontWeight600(
                          size: size < 0.3
                              ? 22.0
                              : size > 0.48
                                  ? 0.0
                                  : 18.0),
                    ),
                  ),
                  count <= 0
                      ? const SizedBox.shrink()
                      : size < 0.6
                          ? PopupMenuButton(
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
                                    _buildPopupMenuItem(
                                        'Add to queue', 'share'),
                                    _buildPopupMenuItem(
                                        'Add to playlist', "song_info"),
                                  ])
                          : const SizedBox.shrink()
                ],
              ),
            ),
            Text(
              "$count Songs",
              //  "",
              style: fontWeight400(
                size: size < 0.3
                    ? 22.0
                    : size > 0.48
                        ? 0.0
                        : 18.0,
                color: CustomColor.subTitle2,
              ),
            ),
            count <= 0
                ? const SizedBox.shrink()
                : AnimatedOpacity(
                    opacity: (size - 1.0).abs(),
                    duration: const Duration(milliseconds: 100),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 24),
                      child: Consumer<ArtistViewAllProvider>(
                          builder: (context, pro, _) {
                        return InkWell(
                          onTap: () {
                            callback();
                          },
                          // onTap: () {
                          //   List songId = [];
                          //   for (var record
                          //       in pro.collectionViewAllModel.records) {
                          //     songId.add(record!.id.toString());
                          //   }

                          //   debugPrint(songId.toString());
                          //   Navigation.navigateToScreen(
                          //       context, RouteName.player,
                          //       args: PlayerModel(
                          //           collectionViewAllModel:
                          //               pro.collectionViewAllModel,
                          //           songList: songId,
                          //           selectedSongIndex: 0));
                          // },
                          child: CustomButton(
                              isIcon: true,
                              label: "Play All",
                              horizontalMargin: 0.0,
                              height: size < 0.3
                                  ? 52
                                  : size < 0.4
                                      ? 48
                                      : size < 0.6
                                          ? 38
                                          : size < 0.65
                                              ? 36
                                              : 0,
                              verticalMargin: 0.0),
                        );
                      }),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
