

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:musiq/src/helpers/utils/image_url_generate.dart';
import 'package:musiq/src/logic/services/api_route.dart';
import 'package:musiq/src/model/api_model/album_model.dart';
import 'package:musiq/src/model/api_model/aura_model.dart';
import 'package:musiq/src/model/api_model/aura_song_model.dart';
import 'package:musiq/src/model/api_model/trending_hits_model.dart';
import 'package:musiq/src/model/ui_model/play_screen_model.dart';
import 'package:musiq/src/model/ui_model/view_all_song_list_model.dart';
import 'package:musiq/src/view/pages/home/components/pages/view_all/view_all_songs_list.dart';
import 'package:musiq/src/view/pages/home/components/widget/artist_list_view.dart';
import 'package:musiq/src/view/pages/home/components/widget/loader.dart';
import 'package:musiq/src/view/pages/home/components/widget/trending_hits.dart';
import 'package:musiq/src/view/pages/play/play_screen_new.dart';


import '../../../constants/api.dart';
import '../../../constants/color.dart';
import '../../../constants/images.dart';
import '../../../constants/style.dart';
import '../../../model/api_model/recent_song_model.dart';
import '../../../model/api_model/song_list_model.dart';
import '../../../widgets/custom_color_container.dart';
import '../../../widgets/empty_box.dart';
import 'components/home_components/based_on_your_interest.dart';
import 'components/home_components/current_mood.dart';
import 'components/home_components/new_release.dart';
import 'components/home_components/recommended_songs.dart';
import 'components/home_components/search_notifications.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Images images = Images();
  var storage = const FlutterSecureStorage();
  APIRoute apiRoute = APIRoute();
  var artistData;
  late RecentlyPlayed recentlyPlayed;
  late Album album;
  late AuraModel auraModel;
  late AuraSongModel auraSongModel;
  late SongList songList;
  late TrendingHitsModel trendingHitsModel;
  late TrendingHitsModel newRelease;
  bool isLoad = false;

  // Api
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() async {
    isLoad = false;
    setState(() {
      isLoad;
    });
    artistData = await apiRoute.getArtist(limit: 10);
    recentlyPlayed = await apiRoute.getRecentlyPlayed();
    album = await apiRoute.getAlbum(limit: 10);
    auraModel = await apiRoute.getAura();
    trendingHitsModel = await apiRoute.getTrendingHits(limit: 10);
    newRelease = await apiRoute.getNewRelease(limit: 10);
    isLoad = true;
    if (mounted) {
      setState(() {
        isLoad;
      });
    }
  }
  // Future<RecentlyPlayed> getRecent()async{
  // await Future.delayed(Duration(seconds: 2),(){});
  //   var token=await storage.read(key: "access_token");
  //   var url=Uri.parse(APIConstants.RECENT_PLAYED,);
  //   var header={ 'Content-type': 'application/json',
  //             'Accept': 'application/json',
  //             "Authorization": "Bearer $token"
  //             };
  //   print(url);
  //   var res=await http.get(url,headers: header);

  //     var data=jsonDecode(res.body);
  //     print(data.toString());

  //      RecentlyPlayed RecentlyPlayed=RecentlyPlayed.fromMap(data);
  //      print(RecentlyPlayed.toMap());

  //   return RecentlyPlayed;

  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: isLoad == false
            ? LoaderScreen()
            : ListView(
                shrinkWrap: true,
                children: [
                  SizedBox(
                    height: 8,
                  ),
                  SearchAndNotifications(),

                  recentlyPlayed.success == false
                      ? EmptyBox()
                      : Container(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  children: [
                                    Text(
                                      "Recently Played",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Spacer(),
                                    InkWell(
                                      onTap: () async {
                                        // print(recentlyPlayed.records[index].id);

                                        recentlyPlayed =
                                            await apiRoute.getRecentlyPlayed();
                                        // print(songList.records.length);
                                        List<ViewAllSongList>
                                            viewAllSongListModel = [];
                                        for (int i = 0;
                                            i < recentlyPlayed.records.length;
                                            i++) {
                                          viewAllSongListModel.add(
                                              ViewAllSongList(
                                                  recentlyPlayed
                                                      .records[i][0].id
                                                      .toString(),
                                                  generateSongImageUrl(
                                                      recentlyPlayed
                                                          .records[i][0]
                                                          .albumName,
                                                      recentlyPlayed
                                                          .records[i][0]
                                                          .albumId),
                                                  recentlyPlayed
                                                      .records[i][0].songName,
                                                  recentlyPlayed.records[i][0]
                                                      .musicDirectorName[0],
                                                  recentlyPlayed
                                                      .records[i][0].albumName,
                                                  recentlyPlayed
                                                      .records[i][0].albumId));
                                        }
                                        ViewAllBanner banner = ViewAllBanner(
                                          bannerId: recentlyPlayed
                                              .records[0][0].albumId,
                                          bannerImageUrl:
                                              "${APIConstants.SONG_BASE_URL}public/music/tamil/${recentlyPlayed.records[0][0].albumName[0].toUpperCase()}/${recentlyPlayed.records[0][0].albumName}/image/${recentlyPlayed.records[0][0].albumId.toString()}.png",
                                          bannerTitle: "Recently Played",
                                        );

                                        Navigator.of(context).push(MaterialPageRoute(
                                            builder: (context) =>
                                                ViewAllScreenSongList(
                                                    banner: banner,
                                                    view_all_song_list_model:
                                                        viewAllSongListModel)));

//             Navigator.of(context).push(MaterialPageRoute(
//                 builder: (context) =>  RecentlyPlayedViewAll(songList: recentlyPlayed, title: 'Recently Played',
//                 imageURL:
//                   "${APIConstants.SONG_BASE_URL}public/music/tamil/${recentlyPlayed.records[recentlyPlayed.records.length-1].albumName[0].toUpperCase()}/${recentlyPlayed.records[recentlyPlayed.records.length-1].albumName}/image/${recentlyPlayed.records[recentlyPlayed.records.length-1].albumId.toString()}.png",
// )));
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
                                padding: EdgeInsets.only(top: 8),
                                height: 200,
                                child: ListView.builder(

                                    // reverse: true,

                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    physics: BouncingScrollPhysics(),
                                    itemCount: recentlyPlayed.records.length,
                                    itemBuilder: (context, index) => Row(
                                          children: [
                                            index == 0
                                                ? SizedBox(
                                                    width: 10,
                                                  )
                                                : SizedBox(),
                                            InkWell(
                                              onTap: () {
                                                List<PlayScreenModel>
                                                    playScreenModel = [];
                                                print(recentlyPlayed
                                                    .records[index][0].id);
                                                for (int i = 0;
                                                    i <
                                                        recentlyPlayed
                                                            .records.length;
                                                    i++) {
                                                  playScreenModel.add(PlayScreenModel(
                                                      id: recentlyPlayed
                                                          .records[i][0].id,
                                                      songName: recentlyPlayed
                                                          .records[i][0]
                                                          .songName,
                                                      musicDirectorName:
                                                          recentlyPlayed
                                                                  .records[i][0]
                                                                  .musicDirectorName[
                                                              0],
                                                      albumId: recentlyPlayed
                                                          .records[i][0]
                                                          .albumId,
                                                      albumName: recentlyPlayed
                                                          .records[i][0]
                                                          .albumName));
                                                }
                                                print(playScreenModel.length);
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            MainPlayScreen(
                                                                playScreenModel:
                                                                    playScreenModel,
                                                                index: index)));
                                              },
                                              child: Container(
                                                padding: EdgeInsets.fromLTRB(
                                                    6, 8, 6, 0),
                                                width: 135,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    CustomColorContainer(
                                                      child: Image.network(
                                                        "${APIConstants.SONG_BASE_URL}public/music/tamil/${recentlyPlayed.records[index][0].albumName[0].toUpperCase()}/${recentlyPlayed.records[index][0].albumName}/image/${recentlyPlayed.records[index][0].albumId.toString()}.png",
                                                        height: 125,
                                                        width: 135,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 6,
                                                    ),
                                                    Text(
                                                      recentlyPlayed
                                                          .records[index][0]
                                                          .songName
                                                          .toString(),
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontSize: 12),
                                                    ),
                                                    SizedBox(
                                                      height: 2,
                                                    ),
                                                    Text(
                                                        recentlyPlayed
                                                                .records[index]
                                                                    [0]
                                                                .albumName
                                                                .toString() +
                                                            "-" +
                                                            recentlyPlayed
                                                                .records[index]
                                                                    [0]
                                                                .musicDirectorName[
                                                                    0]
                                                                .toString(),
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontSize: 12,
                                                            color: CustomColor
                                                                .subTitle))
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        )),
                              ),
                            ],
                          ),
                        ),

                  //     HorizonalListViewWidget(
                  //             title: "Recently Played",
                  //             actionTitle: "View All",
                  //             listWidget: Container(
                  //                 alignment: Alignment.center,
                  //                 child: Container(
                  //   padding: EdgeInsets.only(top: 8),
                  //   height: 200,
                  //   child: ListView.builder(
                  //     reverse: true,
                  //       scrollDirection: Axis.horizontal,
                  //       shrinkWrap: true,
                  //       physics: BouncingScrollPhysics(),
                  //       itemCount: recentlyPlayed.records.length,
                  //       itemBuilder: (context, index) => Row(
                  //             children: [
                  //               index == 0
                  //                   ? SizedBox(
                  //                       width: 10,
                  //                     )
                  //                   : SizedBox(),
                  //               Container(
                  //                 padding: EdgeInsets.fromLTRB(6, 8, 6, 0),
                  //                   width: 135,
                  //                 child: Column(
                  //                   mainAxisAlignment: MainAxisAlignment.start,
                  //                   crossAxisAlignment:
                  //                        CrossAxisAlignment.start,
                  //                   children: [
                  //                     CustomColorContainer(

                  //                       child: Image.network(
                  //                          "${APIConstants.SONG_BASE_URL}public/music/tamil/${recentlyPlayed.records[index].name[0].toUpperCase()}/${recentlyPlayed.records[index].name}/image/${recentlyPlayed.records[index].albumId.toString()}.png",

                  //                         height: 125,
                  //                         width: 135,
                  //                         fit: BoxFit.cover,
                  //                       ),
                  //                     ),
                  //                     SizedBox(
                  //                       height: 6,
                  //                     ),
                  //                     Text(
                  //                     recentlyPlayed.records[index].songs!.name.toString(),
                  //                       style: TextStyle(
                  //                           fontWeight: FontWeight.w400, fontSize: 12),
                  //                     ),
                  //                     SizedBox(
                  //                       height: 2,
                  //                     ),
                  //                    Text( recentlyPlayed.records[index].name.toString()+"-"+recentlyPlayed.records[index].musicDirectorName[0].toString(),
                  //                    maxLines: 1,
                  // overflow: TextOverflow.ellipsis,

                  //                             style: TextStyle(
                  //                                 fontWeight: FontWeight.w400,
                  //                                 fontSize: 12,
                  //                                 color: CustomColor.subTitle))
                  //                   ],
                  //                 ),
                  //               ),
                  //             ],
                  //           )),
                  // ),
                  // ),
                  // ),

                  TrendingHitsWidget(
                    trendingHitsModel: trendingHitsModel,
                  ),
                  RecommendedSongs(images: images),
                  ArtistListView(artist: artistData),
                  NewRelease(new_release: newRelease),
                  BasedOnYourInterest(images: images),

                  CurrentMood(auraModel: auraModel),
                  //             Column(
                  //               children:[
                  //              Container(
                  //                 alignment: Alignment.center,
                  //                 child: Container(
                  //   padding: EdgeInsets.only(top: 8),
                  //   height: 200,
                  //   child: ListView.builder(
                  //       scrollDirection: Axis.horizontal,
                  //       shrinkWrap: true,
                  //       physics: BouncingScrollPhysics(),
                  //       itemCount: album.records.length,
                  //       itemBuilder: (context, index) => Row(
                  //             children: [
                  //               index == 0
                  //                   ? SizedBox(
                  //                       width: 10,
                  //                     )
                  //                   : SizedBox(),
                  //               Container(
                  //                 padding: EdgeInsets.fromLTRB(6, 8, 6, 0),
                  //                   width: 135,
                  //                 child: Column(
                  //                   mainAxisAlignment: MainAxisAlignment.start,
                  //                   crossAxisAlignment:
                  //                        CrossAxisAlignment.start,
                  //                   children: [
                  //                     CustomColorContainer(

                  //                       child: Image.network(
                  //                          "${APIConstants.SONG_BASE_URL}public/music/tamil/${album.records[index].albumName[0].toUpperCase()}/${album.records[index].albumName}/image/${album.records[index].albumId.toString()}.png",

                  //                         height: 125,
                  //                         width: 135,
                  //                         fit: BoxFit.cover,
                  //                       ),
                  //                     ),
                  //                     SizedBox(
                  //                       height: 6,
                  //                     ),
                  //                     Text(
                  //                     album.records[index].albumName,
                  //                       style: TextStyle(
                  //                           fontWeight: FontWeight.w400, fontSize: 12),
                  //                     ),
                  //                     SizedBox(
                  //                       height: 2,
                  //                     ),
                  //                    Text( album.records[index].musicDirectorName[0].toString(),
                  //                    maxLines: 1,
                  // overflow: TextOverflow.ellipsis,

                  //                             style: TextStyle(
                  //                                 fontWeight: FontWeight.w400,
                  //                                 fontSize: 12,
                  //                                 color: CustomColor.subTitle))

                  //                   ],
                  //                 ),
                  //               ),
                  //             ],
                  //           )),
                  // ))]),
                  // HorizonalListViewWidget(
                  //     title: "Top Albums",
                  //     actionTitle: "",
                  //     listWidget: CustomHorizontalListview(
                  //       images: images.topAlbumList,
                  //     )),
                  Container(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              Text(
                                "Top Albums",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
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
                          padding: EdgeInsets.only(top: 8),
                          height: 200,
                          child: ListView.builder(
                              // reverse: true,
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              physics: BouncingScrollPhysics(),
                              itemCount: album.records.length,
                              itemBuilder: (context, index) => Row(
                                    children: [
                                      index == 0
                                          ? SizedBox(
                                              width: 10,
                                            )
                                          : SizedBox(),
                                      Container(
                                        padding:
                                            EdgeInsets.fromLTRB(6, 8, 6, 0),
                                        width: 135,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            InkWell(
                                              onTap: () async {
                                                print(album.records[index].id);
                                                ViewAllBanner banner =
                                                    ViewAllBanner(
                                                  bannerId: album
                                                      .records[index].id
                                                      .toString(),
                                                  bannerImageUrl:
                                                      "${APIConstants.SONG_BASE_URL}public/music/tamil/${album.records[index].albumName[0].toUpperCase()}/${album.records[index].albumName}/image/${album.records[index].albumId.toString()}.png",
                                                  bannerTitle: album
                                                      .records[index].albumName
                                                      .toString(),
                                                );
                                                print(banner.bannerImageUrl
                                                    .toString());
                                                songList = await apiRoute
                                                    .getSpecificAlbumSong(
                                                        id: album
                                                            .records[index].id);
                                                print(songList.records.length);
                                                List<ViewAllSongList>
                                                    viewAllSongListModel = [];
                                                for (int i = 0;
                                                    i < songList.records.length;
                                                    i++) {
                                                  viewAllSongListModel.add(
                                                      ViewAllSongList(
                                                          songList.records[i].id
                                                              .toString(),
                                                          generateSongImageUrl(
                                                              songList
                                                                  .records[i]
                                                                  .albumName,
                                                              songList
                                                                  .records[i]
                                                                  .albumId),
                                                          songList.records[i]
                                                              .songName,
                                                          songList.records[i]
                                                                  .musicDirectorName[
                                                              0],
                                                          songList.records[i]
                                                              .albumName,
                                                          songList.records[i]
                                                              .albumId));
                                                }

                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            ViewAllScreenSongList(
                                                                banner: banner,
                                                                view_all_song_list_model:
                                                                    viewAllSongListModel)));
                                              },
                                              child: CustomColorContainer(
                                                child: Image.network(
                                                  generateSongImageUrl(
                                                      album.records[index]
                                                          .albumName,
                                                      album.records[index]
                                                          .albumId),
                                                  height: 125,
                                                  width: 135,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 6,
                                            ),
                                            Text(
                                              album.records[index].albumName
                                                  .toString(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 12),
                                            ),
                                            SizedBox(
                                              height: 2,
                                            ),
                                            Text(
                                                album.records[index]
                                                    .musicDirectorName[0]
                                                    .toString(),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: fontWeight400(
                                                    size: 12.0,
                                                    color:
                                                        CustomColor.subTitle))
                                          ],
                                        ),
                                      ),
                                    ],
                                  )),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
