import 'package:flutter/material.dart';
import 'package:musiq/src/core/utils/url_generate.dart';
import 'package:provider/provider.dart';

import '../../../../common_widgets/container/custom_color_container.dart';
import '../../../../common_widgets/image/no_artist.dart';
import '../../../../core/constants/color.dart';
import '../../../../core/constants/style.dart';
import '../../provider/artist_provider.dart';

class ArtistPreferenceScreenBody extends StatelessWidget {
  const ArtistPreferenceScreenBody({Key? key, required this.artistList})
      : super(key: key);

  final List? artistList;

  @override
  Widget build(BuildContext context) {
    // artistPreferenceController.loadData(artist_list!);
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
                  Expanded(
                    flex: 7,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            provider.artistModel!.records[index].artistName,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: const TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 14),
                          ),
                          Row(
                            children: [
                              const Icon(Icons.people),
                              const SizedBox(
                                width: 8,
                              ),
                              Consumer<ArtistPreferenceProvider>(
                                builder: (context, pro, _) {
                                  return Text(
                                    pro.artistModel!.records[index].followers !=
                                            null
                                        ? pro.artistModel!.records[index]
                                            .followers
                                            .toString()
                                        : "0",
                                    style: TextStyle(
                                        color: CustomColor.subTitle,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14),
                                  );
                                },
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: provider.userFollowedArtist.contains(
                                  provider.artistModel!.records[index].artistId)
                              ? 12
                              : 16,
                          vertical: 4),
                      child: InkWell(
                        onTap: () async {
                          provider.checkFollow(
                              provider.artistModel!.records[index],
                              index,
                              context);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: provider.userFollowedArtist.contains(
                                      provider
                                          .artistModel!.records[index].artistId)
                                  ? 12
                                  : 10,
                              vertical: 4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: provider.userFollowedArtist.contains(provider
                                    .artistModel!.records[index].artistId)
                                ? CustomColor.followingColor
                                : CustomColor.secondaryColor,
                          ),
                          child: Center(
                            child: Text(
                              provider.userFollowedArtist.contains(provider
                                      .artistModel!.records[index].artistId)
                                  ? "Unfollow"
                                  : "Follow",
                              style: fontWeight400(),
                            ),
                          ),
                        ),
                      ),
                    ),
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

class ArtistImagesWidget extends StatelessWidget {
  const ArtistImagesWidget({
    Key? key,
    required this.url,
  }) : super(key: key);

  final String url;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      width: 80,
      height: 80,
      fit: BoxFit.fill,
    );
  }
}
