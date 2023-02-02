import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../common_widgets/container/custom_color_container.dart';
import '../../../../common_widgets/image/no_artist.dart';
import '../../../../constants/constant.dart';
import '../../../../utils/image_url_generate.dart';
import '../../provider/player_provider.dart';

class SongInfoArtistListView extends StatelessWidget {
  const SongInfoArtistListView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 4),
      height: 300,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        itemCount: context
            .read<PlayerProvider>()
            .songInfoModel!
            .records
            .artistDetails
            .length,
        itemBuilder: (context, index) => Row(
          children: [
            index == 0
                ? const SizedBox(
                    width: 12,
                  )
                : const SizedBox(),
            Container(
              padding: const EdgeInsets.only(right: 12),
              child: InkWell(
                onTap: () {
                  // Navigation.navigateToScreen(
                  //     context, RouteName.artistViewAllSongListScreen,
                  //     args: ArtistViewAllModel(
                  //         id: artist.records[index].id.toString(),
                  //         artistId: artist.records[index].artistId
                  //             .toString(),
                  //         artistName: artist.records[index].artistName
                  //             .toString(),
                  //         isImage: artist.records[index].isImage));
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    context
                                .read<PlayerProvider>()
                                .songInfoModel!
                                .records
                                .artistDetails[index]
                                .isImage ==
                            false
                        ? const NoArtist()
                        : CustomColorContainer(
                            child: Image.network(
                              generateArtistImageUrl(context
                                  .read<PlayerProvider>()
                                  .songInfoModel!
                                  .records
                                  .artistDetails[index]
                                  .artistId),
                              height: 240,
                              width: 200,
                              fit: BoxFit.cover,
                            ),
                          ),
                    const SizedBox(
                      height: 6,
                    ),
                    Text(
                      context
                          .read<PlayerProvider>()
                          .songInfoModel!
                          .records
                          .artistDetails[index]
                          .artistName,
                      style: fontWeight400(size: 16.0),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
