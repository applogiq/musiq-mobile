import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common_widgets/container/custom_color_container.dart';
import '../../../core/constants/api.dart';
import '../../../core/constants/color.dart';
import '../../../core/constants/images.dart';
import '../../../core/enums/enums.dart';
import '../../payment/screen/subscription_screen.dart';
import '../domain/model/song_list_model.dart';
import '../provider/view_all_provider.dart';
import '../screens/sliver_app_bar/view_all_screen.dart';

class HomeScreenSongList extends StatelessWidget {
  const HomeScreenSongList(
      {super.key,
      required this.title,
      required this.isViewAll,
      required this.songList});

  final bool isViewAll;
  final List<SongListModel> songList;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Text(
                title,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              !isViewAll
                  ? const SizedBox.shrink()
                  : InkWell(
                      onTap: () {
                        context.read<ViewAllProvider>().loaderEnable();
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ViewAllScreen(
                                  status: title == "New Releases"
                                      ? ViewAllStatus.newRelease
                                      : ViewAllStatus.recentlyPlayed,
                                )));
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
          ),
        ),
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(top: 8),
          height: 200,
          child: ListView.builder(

              // reverse: true,

              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: songList.length,
              itemBuilder: (context, index) => Row(
                    children: [
                      index == 0
                          ? const SizedBox(
                              width: 10,
                            )
                          : const SizedBox(),
                      InkWell(
                        onTap: () {
                          if (songList[index].premiumStatus == "free") {
                            context.read<ViewAllProvider>().getViewAll(
                                title == "New Releases"
                                    ? ViewAllStatus.newRelease
                                    : ViewAllStatus.recentlyPlayed,
                                context: context,
                                goToNextfunction: true,
                                index: index);
                          } else {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    const SubscriptionsScreen()));
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(6, 8, 6, 0),
                          width: 135,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                alignment: Alignment.topRight,
                                children: [
                                  CustomColorContainer(
                                    child: Image.network(
                                      "${APIConstants.baseUrl}public/music/tamil/${songList[index].albumName[0].toUpperCase()}/${songList[index].albumName}/image/${songList[index].albumId.toString()}.png",
                                      height: 125,
                                      width: 135,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  (songList[index].premiumStatus != "free")
                                      ? Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: CircleAvatar(
                                            radius: 15,
                                            backgroundColor: CustomColor.bg,
                                            child: Image.asset(
                                              Images.crownImage,
                                              height: 21,
                                              width: 21,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        )
                                      : const SizedBox.shrink()
                                ],
                              ),
                              const SizedBox(
                                height: 6,
                              ),
                              Text(
                                songList[index].songName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w400, fontSize: 12),
                              ),
                              const SizedBox(
                                height: 2,
                              ),
                              Text(
                                "${songList[index].albumName}-${songList[index].musicDirectorName}",
                                maxLines: 1,
                                // overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w400, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )),
        ),
      ],
    );
  }
}
