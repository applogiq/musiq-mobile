import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../common_widgets/container/custom_color_container.dart';
import '../../../../common_widgets/image/no_artist.dart';
import '../../../../constants/color.dart';
import '../../../../constants/images.dart';
import '../../../../constants/style.dart';
import '../../../../utils/image_url_generate.dart';
import '../../provider/artist_provider.dart';

class ArtistPreferenceScreenBody extends StatelessWidget {
  ArtistPreferenceScreenBody({Key? key, required this.artist_list})
      : super(key: key);
  List? artist_list = [];

  @override
  Widget build(BuildContext context) {
    // artistPreferenceController.loadData(artist_list!);
    return Consumer<ArtistPreferenceProvider>(builder: (context, provider, _) {
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
                              ? NoArtist(
                                  height: 80,
                                  width: 80,
                                )
                              : ArtistImagesWidget(
                                  artistPreferenceController: provider,
                                  index: index,
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
                                    // artistPreferenceController.artistModel!
                                    //             .records[index].followers !=
                                    //         null
                                    //     ? artistPreferenceController
                                    //         .artistModel!
                                    //         .records[index]
                                    //         .followers
                                    //         .toString()
                                    //     : "0",
                                    style: TextStyle(
                                        color: CustomColor.subTitle,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14),
                                  );
                                })

                                // GetBuilder<ArtistPreferenceController>(
                                //   init: ArtistPreferenceController(),
                                //   initState: (_) {},
                                //   builder: (_) {
                                //     return Text(
                                //       artistPreferenceController.artistModel!
                                //                   .records[index].followers !=
                                //               null
                                //           ? artistPreferenceController
                                //               .artistModel!
                                //               .records[index]
                                //               .followers
                                //               .toString()
                                //           : "0",
                                //       // artistPreferenceController.artistModel!
                                //       //             .records[index].followers !=
                                //       //         null
                                //       //     ? artistPreferenceController
                                //       //         .artistModel!
                                //       //         .records[index]
                                //       //         .followers
                                //       //         .toString()
                                //       //     : "0",
                                //       style: TextStyle(
                                //           color: CustomColor.subTitle,
                                //           fontWeight: FontWeight.w400,
                                //           fontSize: 14),
                                //     );
                                //   },
                                // ),
                              ],
                            ),
                          ],
                        ),
                      )),
                  Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: provider.userFollowedArtist.contains(
                                    provider
                                        .artistModel!.records[index].artistId)
                                ? 12
                                : 16,
                            vertical: 4),
                        child: InkWell(
                          onTap: () async {
                            provider.checkFollow(
                                provider.artistModel!.records[index], index);
                            // artistPreferenceController.followAndUnfollow(artistPreferenceController.artistModel!.records[index].id);
                            // print();
                            // followAndUnfollow(
                            //     artistPreferenceController.artistModel!.records,
                            //     index);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: provider.userFollowedArtist
                                        .contains(provider.artistModel!
                                            .records[index].artistId)
                                    ? 12
                                    : 10,
                                vertical: 4),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: provider.userFollowedArtist.contains(
                                      provider
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
                      )),
                ],
              ),
            );
          });
    });
  }

//   void followAndUnfollow(List<Record> records, int index) {
//     if (artist_list!.contains(records[index].artistId)) {
//       Map<String, dynamic> params = {
//         "artist_id": records[index].artistId,
//         "follow": false
//       };
//       artistPreferenceController.followAndUnfollow(params);

// // print("object");
//     } else {
//       // records[index].followers=(records[index].followers! +1);
//       artist_list!.add(records[index].artistId);
// //
//       Map<String, dynamic> params = {
//         "artist_id": records[index].artistId,
//         "follow": true
//       };
//       artistPreferenceController.followAndUnfollow(params);
//       // print("data");
//     }
//   }
}

class ArtistImagesWidget extends StatelessWidget {
  const ArtistImagesWidget({
    Key? key,
    required this.artistPreferenceController,
    required this.index,
  }) : super(key: key);

  final ArtistPreferenceProvider artistPreferenceController;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      generateArtistImageUrl(
          artistPreferenceController.artistModel!.records[index].artistId),
      width: 80,
      height: 80,
      fit: BoxFit.fill,
    );
  }
}

class NoArtistImage extends StatelessWidget {
  const NoArtistImage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      Images.noArtist,
      width: 70,
      height: 70,
      fit: BoxFit.contain,
    );
  }
}
