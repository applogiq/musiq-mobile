import 'package:flutter/material.dart';
import 'package:musiq/src/features/home/domain/model/aura_model.dart';

import '../../../common_widgets/container/custom_color_container.dart';
import '../../../common_widgets/list/horizontal_list_view.dart';
import '../../../utils/image_url_generate.dart';

class CurrentMood extends StatelessWidget {
  const CurrentMood({super.key, required this.auraModel});
  final AuraModel auraModel;

  @override
  Widget build(BuildContext context) {
    return HorizonalListViewWidget(
      title: "Current Mood",
      actionTitle: "",
      listWidget: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(top: 8),
        height: 180,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemCount: auraModel.records.length,
            itemBuilder: (context, index) => Row(
                  children: [
                    index == 0
                        ? const SizedBox(
                            width: 10,
                          )
                        : const SizedBox(),
                    Container(
                      padding: const EdgeInsets.fromLTRB(6, 8, 6, 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(
                            // onTap: () async {
                            //   ViewAllBanner banner = ViewAllBanner(
                            //       bannerId: auraModel.records[index].auraId,
                            //       bannerImageUrl: APIConstants.SONG_BASE_URL +
                            //           APIConstants.AURA +
                            //           auraModel.records[index].auraId +
                            //           ".png",
                            //       bannerTitle:
                            //           auraModel.records[index].auraName);
                            //   print(banner.bannerImageUrl.toString());
                            //   AuraSongModel auraSongModel =
                            //       await apiRoute.getSpecificAuraSongs(
                            //           id: auraModel.records[index].id);
                            //   List<ViewAllSongList> viewAllSongListModel = [];
                            //   for (int i = 0;
                            //       i < auraSongModel.records.length;
                            //       i++) {
                            //     viewAllSongListModel.add(ViewAllSongList(
                            //         auraSongModel.records[i].auraSongs.id
                            //             .toString(),
                            //         generateSongImageUrl(
                            //             auraSongModel.records[i].albumName,
                            //             auraSongModel.records[i].albumId),
                            //         auraSongModel.records[i].songName,
                            //         auraSongModel
                            //             .records[i].musicDirectorName[0],
                            //         auraSongModel.records[i].albumName,
                            //         auraSongModel.records[i].albumId));
                            //   }

                            //   Navigator.of(context).push(MaterialPageRoute(
                            //       builder: (context) => ViewAllScreenSongList(
                            //           banner: banner,
                            //           view_all_song_list_model:
                            //               viewAllSongListModel)));
                            // },

                            child: CustomColorContainer(
                              shape: BoxShape.circle,
                              child: Image.network(
                                generateAuraImageUrl(
                                    auraModel.records[index].auraId),
                                height: 125,
                                width: 125,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          Text(
                            auraModel.records[index].auraName,
                            style: const TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 12),
                          ),
                          const SizedBox(
                            height: 2,
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
      ),
    );
  }
}
