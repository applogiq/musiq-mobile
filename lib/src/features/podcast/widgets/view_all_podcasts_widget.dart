import 'package:flutter/material.dart';
import 'package:musiq/src/common_widgets/container/custom_color_container.dart';
import 'package:musiq/src/core/constants/constant.dart';
import 'package:musiq/src/core/constants/images.dart';
import 'package:musiq/src/core/enums/enums.dart';
import 'package:musiq/src/core/extensions/string_extension.dart';
import 'package:musiq/src/core/utils/url_generate.dart';
import 'package:musiq/src/features/home/provider/view_all_provider.dart';
import 'package:musiq/src/features/home/screens/sliver_app_bar/view_all_screen.dart';
import 'package:musiq/src/features/podcast/domain/model/get_all_podcasts_model.dart';
import 'package:provider/provider.dart';

class GetAllPodcastWidget extends StatelessWidget {
  const GetAllPodcastWidget({super.key, required this.album});
  final GetAllPodcasts album;

  @override
  Widget build(BuildContext context) {
    return album.totalrecords == 0
        ? const SizedBox.shrink()
        : Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Row(
                  children: const [
                    Text(
                      "Top Podcasts",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    Spacer(),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 8),
                height: 200,
                child: ListView.builder(
                    // reverse: true,
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: album.records.length,
                    itemBuilder: (context, index) => Row(
                          children: [
                            index == 0
                                ? const SizedBox(
                                    width: 10,
                                  )
                                : const SizedBox(),
                            Container(
                              padding: const EdgeInsets.fromLTRB(6, 8, 6, 0),
                              width: 135,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      context
                                          .read<ViewAllProvider>()
                                          .loaderEnable();
                                      if (album.records[index].noOfEpisode ==
                                          0) {
                                      } else {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ViewAllScreen(
                                                      podcastSubtitle: album
                                                          .records[index]
                                                          .description!,
                                                      podcastAuthor: album
                                                          .records[index]
                                                          .authorsName[0],
                                                      title: album
                                                          .records[index].title,
                                                      artisttitle: album
                                                          .records[index].title,
                                                      artistId: album
                                                          .records[index].id
                                                          .toString(),
                                                      status: ViewAllStatus
                                                          .podCastAll,
                                                      id: album
                                                          .records[index].id,
                                                      isPremium: false,
                                                      istitleAndDescriptionVisible:
                                                          true,
                                                      // index == 1 ? true : false,
                                                    )));
                                      }
                                    },
                                    child: album.records[index].isImage == false
                                        ? CustomColorContainer(
                                            child: Image.asset(
                                              Images.noArtist,
                                              height: 125,
                                              width: 135,
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                        : Image.network(
                                            generatePodcastImageUrl(
                                                album.records[index].title
                                                    .toString(),
                                                album.records[index].id
                                                    .toString()),
                                            height: 125,
                                            width: 135,
                                            fit: BoxFit.fill,
                                          ),
                                  ),
                                  const SizedBox(
                                    height: 6,
                                  ),
                                  Text(
                                    album.records[index].title
                                        .toString()
                                        .capitalizeFirstLetter(),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12),
                                  ),
                                  const SizedBox(
                                    height: 2,
                                  ),
                                  Text(
                                      album.records[index].authorsName.isEmpty
                                          ? ""
                                          : album.records[index].authorsName[0]
                                              .toString()
                                              .capitalizeFirstLetter(),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: fontWeight400(
                                          size: 12.0,
                                          color: CustomColor.subTitle))
                                ],
                              ),
                            ),
                          ],
                        )),
              ),
            ],
          );
  }
}
