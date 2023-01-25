import 'package:flutter/material.dart';
import 'package:musiq/src/features/home/domain/model/album_model.dart';

import '../../../common_widgets/container/custom_color_container.dart';
import '../../../constants/color.dart';
import '../../../constants/style.dart';
import '../../../utils/image_url_generate.dart';
import '../screens/sliver_demo/view_all_screen.dart';
import '../view_all_status.dart';

class TopAlbum extends StatelessWidget {
  const TopAlbum({super.key, required this.album});
  final Album album;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: const [
              Text(
                "Top Albums",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              Spacer(),
//         InkWell(
//           onTap: () {
//             Navigator.of(context).push(MaterialPageRoute(
//                 builder: (context) =>  RecentlyPlayedViewAll(songList: recentlyPlayed, title: 'Recently Played',
//                 imageURL:  "${APIConstants.SONG_BASE_URL}public/music/tamil/${recentlyPlayed.records[recentlyPlayed.records.length-1].albumName[0].toUpperCase()}/${recentlyPlayed.records[recentlyPlayed.records.length-1].albumName}/image/${recentlyPlayed.records[recentlyPlayed.records.length-1].albumId.toString()}.png",
// )));
//           },
//           child: Text(
//             "View All",
//             style: TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w400,
//                 color: CustomColor.secondaryColor),
//           ),
//         )
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
                                print(album.records[index].id);
                                print(album.records[index].albumName);
                                print(
                                  generateSongImageUrl(
                                      album.records[index].albumName,
                                      album.records[index].albumId),
                                );
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => ViewAllScreen(
                                          status: ViewAllStatus.album,
                                          id: album.records[index].id,
                                        )));
                              },
                              // onTap: () async {
                              //   print(album.records[index].id);
                              //   ViewAllBanner banner = ViewAllBanner(
                              //     bannerId:
                              //         album.records[index].id.toString(),
                              //     bannerImageUrl:
                              //         "${APIConstants.SONG_BASE_URL}public/music/tamil/${album.records[index].albumName[0].toUpperCase()}/${album.records[index].albumName}/image/${album.records[index].albumId.toString()}.png",
                              //     bannerTitle: album.records[index].albumName
                              //         .toString(),
                              //   );
                              //   print(banner.bannerImageUrl.toString());
                              //   songList =
                              //       await apiRoute.getSpecificAlbumSong(
                              //           id: album.records[index].id);
                              //   print(songList.records.length);
                              //   List<ViewAllSongList> viewAllSongListModel =
                              //       [];
                              //   for (int i = 0;
                              //       i < songList.records.length;
                              //       i++) {
                              //     viewAllSongListModel.add(ViewAllSongList(
                              //         songList.records[i].id.toString(),
                              //         generateSongImageUrl(
                              //             songList.records[i].albumName,
                              //             songList.records[i].albumId),
                              //         songList.records[i].songName,
                              //         songList
                              //             .records[i].musicDirectorName[0],
                              //         songList.records[i].albumName,
                              //         songList.records[i].albumId));
                              //   }

                              //   Navigator.of(context).push(MaterialPageRoute(
                              //       builder: (context) =>
                              //           ViewAllScreenSongList(
                              //               banner: banner,
                              //               view_all_song_list_model:
                              //                   viewAllSongListModel)));
                              // },
                              child: CustomColorContainer(
                                child: Image.network(
                                  generateSongImageUrl(
                                      album.records[index].albumName,
                                      album.records[index].albumId),
                                  height: 125,
                                  width: 135,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            Text(
                              album.records[index].albumName.toString(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.w400, fontSize: 12),
                            ),
                            const SizedBox(
                              height: 2,
                            ),
                            Text(
                                album.records[index].musicDirectorName[0]
                                    .toString(),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: fontWeight400(
                                    size: 12.0, color: CustomColor.subTitle))
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
