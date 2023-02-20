import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common_widgets/container/custom_color_container.dart';
import '../../../common_widgets/image/no_artist.dart';
import '../../../core/constants/constant.dart';
import '../../../core/enums/enums.dart';
import '../../../core/utils/url_generate.dart';
import '../../artist/provider/artist_provider.dart';
import '../../artist/widgets/artist_image_widget.dart';
import '../../home/screens/artist_view_all/artist_view_all_screen.dart';
import '../provider/search_provider.dart';
import '../screens/search_screen.dart';

class ArtistPrefereneSearchListView extends StatelessWidget {
  const ArtistPrefereneSearchListView({
    Key? key,
    required this.searchRequestModel,
    required this.pro,
  }) : super(key: key);
  final SearchProvider pro;
  final SearchRequestModel searchRequestModel;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: searchRequestModel.searchStatus == SearchStatus.artistPreference
            ? ListView.builder(
                itemCount: pro.artistModel.records.length,
                itemBuilder: (context, index) {
                  return Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: pro.artistModel.records[index].isImage == false
                              ? const CustomColorContainer(
                                  child: NoArtist(
                                    height: 80,
                                    width: 80,
                                  ),
                                )
                              : CustomColorContainer(
                                  child: ArtistImagesWidget(
                                    url: generateArtistImageUrl(pro
                                        .artistModel.records[index].artistId),
                                  ),
                                ),
                        ),
                        Expanded(
                          flex: 7,
                          child: Padding(
                            padding:
                                const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  pro.artistModel.records[index].artistName,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14),
                                ),
                                Row(
                                  children: [
                                    const Icon(Icons.people),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Text(
                                      pro.artistModel.records[index]
                                                  .followers !=
                                              null
                                          ? pro.artistModel.records[index]
                                              .followers
                                              .toString()
                                          : "0",
                                      style: TextStyle(
                                          color: CustomColor.subTitle,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Consumer<ArtistPreferenceProvider>(
                            builder: (context, artistProvider, _) {
                          return Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: artistProvider.userFollowedArtist
                                          .contains(pro.artistModel
                                              .records[index].artistId)
                                      ? 12
                                      : 16,
                                  vertical: 4),
                              child: InkWell(
                                onTap: () async {
                                  artistProvider.checkFollow(
                                      pro.artistModel.records[index],
                                      index,
                                      context);
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: artistProvider
                                              .userFollowedArtist
                                              .contains(pro.artistModel
                                                  .records[index].artistId)
                                          ? 12
                                          : 10,
                                      vertical: 4),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    color: artistProvider.userFollowedArtist
                                            .contains(pro.artistModel
                                                .records[index].artistId)
                                        ? CustomColor.followingColor
                                        : CustomColor.secondaryColor,
                                  ),
                                  child: Center(
                                    child: Text(
                                      artistProvider.userFollowedArtist
                                              .contains(pro.artistModel
                                                  .records[index].artistId)
                                          ? ConstantText.unFollow
                                          : ConstantText.follow,
                                      style: fontWeight400(),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  );
                },
              )
            : ArtistGridView(
                artistModel: pro.artistModel,
                isFromSearch: true,
              ));
  }
}
