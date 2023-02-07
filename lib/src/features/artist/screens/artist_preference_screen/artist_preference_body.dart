import 'package:flutter/material.dart';
import 'package:musiq/src/core/utils/url_generate.dart';
import 'package:provider/provider.dart';

import '../../../../common_widgets/container/custom_color_container.dart';
import '../../../../common_widgets/image/no_artist.dart';
import '../../provider/artist_provider.dart';
import '../../widgets/artist_follow_unfollow_button.dart';
import '../../widgets/artist_image_widget.dart';
import '../../widgets/artist_info_widget.dart';

class ArtistPreferenceScreenBody extends StatelessWidget {
  const ArtistPreferenceScreenBody({Key? key, required this.artistList})
      : super(key: key);

  final List? artistList;

  @override
  Widget build(BuildContext context) {
    return Consumer<ArtistPreferenceProvider>(
      builder: (context, provider, _) {
        return ListView.builder(
          itemCount: provider.artistModel!.records.length,
          itemBuilder: (_, index) {
            return Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: CustomColorContainer(
                      child:
                          provider.artistModel!.records[index].isImage == false
                              ? const NoArtist(
                                  height: 80,
                                  width: 80,
                                )
                              : ArtistImagesWidget(
                                  url: generateArtistImageUrl(provider
                                      .artistModel!.records[index].artistId),
                                ),
                    ),
                  ),
                  ArtistInfo(provider: provider, index: index),
                  FollowAndUnfollowButton(
                    provider: provider,
                    index: index,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
