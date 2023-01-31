import 'package:flutter/material.dart';
import 'package:musiq/src/routing/route_name.dart';
import 'package:musiq/src/utils/navigation.dart';
import 'package:provider/provider.dart';

import '../../../common_widgets/container/custom_color_container.dart';
import '../../../constants/color.dart';
import '../../../constants/images.dart';
import '../../../constants/style.dart';
import '../../../utils/image_url_generate.dart';
import '../../artist/domain/models/artist_model.dart';
import '../provider/view_all_provider.dart';
import '../screens/sliver_app_bar/view_all_screen.dart';
import '../view_all_status.dart';

class ArtistListView extends StatelessWidget {
  const ArtistListView({
    Key? key,
    required this.artist,
  }) : super(key: key);

  final ArtistModel artist;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
            padding: const EdgeInsets.fromLTRB(12.0, 24.0, 12.0, 0.0),
            child: Row(
              children: [
                const Text(
                  "Artists",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                InkWell(
                  onTap: () {
                    Navigation.navigateToScreen(
                        context, RouteName.artistViewAllScreen);
                    // Navigator.of(context).push(MaterialPageRoute(
                    //     builder: (context) => ArtistListViewAll()));
                  },
                  child: Text(
                    "View All",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: CustomColor.secondaryColor),
                  ),
                )
              ],
            )),
        Container(
          padding: const EdgeInsets.only(top: 4),
          height: 300,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: artist.records.length,
              itemBuilder: (context, index) => Row(
                    children: [
                      index == 0
                          ? const SizedBox(
                              width: 12,
                            )
                          : const SizedBox(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: InkWell(
                          onTap: () {
                            context.read<ViewAllProvider>().loaderEnable();
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ViewAllScreen(
                                      status: ViewAllStatus.artist,
                                      id: artist.records[index].id,
                                      auraId: artist.records[index].artistId,
                                      title: artist.records[index].artistName
                                          .toString(),
                                      isImage: artist.records[index].isImage,
                                    )));

                            // Navigation.navigateToScreen(
                            //     context, RouteName.artistViewAllSongListScreen,
                            //     args: ArtistViewAllModel(
                            //         id: artist.records[index].id.toString(),
                            //         artistId: artist.records[index].artistId
                            //             .toString(),
                            // artistName: artist.records[index].artistName
                            //     .toString(),
                            //         isImage: artist.records[index].isImage));
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              artist.records[index].isImage == false
                                  ? const NoArtist()
                                  : CustomColorContainer(
                                      child: Image.network(
                                        generateArtistImageUrl(
                                            artist.records[index].artistId),
                                        height: 240,
                                        width: 200,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                              const SizedBox(
                                height: 6,
                              ),
                              Text(
                                artist.records[index].artistName,
                                style: fontWeight400(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )),
        )
      ],
    );
  }
}

class NoArtist extends StatelessWidget {
  const NoArtist({Key? key, this.height = 240, this.width = 200})
      : super(key: key);
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: CustomColor.defaultCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: CustomColor.defaultCardBorder, width: 2.0)),
      child: Center(
          child: Image.asset(
        Images.noArtist,
        width: 113,
        height: 118,
      )),
    );
  }
}
