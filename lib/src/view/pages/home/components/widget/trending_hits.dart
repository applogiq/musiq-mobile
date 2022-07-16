import 'package:flutter/material.dart';
import 'package:musiq/src/helpers/constants/string.dart';
import 'package:musiq/src/helpers/utils/image_url_generate.dart';
import 'package:musiq/src/model/api_model/trending_hits_model.dart';
import 'package:musiq/src/view/pages/home/components/pages/trending_hits_view_all_screen.dart';
import 'package:musiq/src/view/pages/home/components/pages/view_all/view_all_songs_list.dart';
import 'package:musiq/src/view/pages/home/components/widget/play_button_widget.dart';

import '../../../../../helpers/constants/api.dart';
import '../../../../../helpers/constants/color.dart';
import '../../../../../logic/services/api_route.dart';
import '../../../../../model/ui_model/play_screen_model.dart';
import '../../../../../model/ui_model/view_all_song_list_model.dart';
import '../../../play/play_screen_new.dart';
import 'horizontal_list_view.dart';

class TrendingHitsWidget extends StatelessWidget {
  TrendingHitsWidget({
    Key? key,
    required this.trendingHitsModel,
  }) : super(key: key);
  final TrendingHitsModel trendingHitsModel;
  late TrendingHitsModel trendingHitsModels;
  APIRoute apiRoute = APIRoute();
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.fromLTRB(12.0, 12, 12.0, 0),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                ConstantText.trendingHitsText,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              Spacer(),
              InkWell(
                onTap: () async {
                  trendingHitsModels = await apiRoute.getTrendingHits();
                  // print(songList.records.length);
                  List<ViewAllSongList> viewAllSongListModel = [];
                  for (int i = 0; i < trendingHitsModels.records.length; i++) {
                    viewAllSongListModel.add(ViewAllSongList(
                        trendingHitsModels.records[i].id.toString(),
                        generateSongImageUrl(
                            trendingHitsModels.records[i].albumName,
                            trendingHitsModels.records[i].albumId),
                        trendingHitsModels.records[i].songName,
                        trendingHitsModels.records[i].musicDirectorName[0],
                        trendingHitsModels.records[i].albumName,
                        trendingHitsModels.records[i].albumId));
                  }
                  ViewAllBanner banner = ViewAllBanner(
                    bannerId: trendingHitsModels.records[0].albumId,
                    bannerImageUrl: generateSongImageUrl(
                        trendingHitsModels.records[0].albumName,
                        trendingHitsModels.records[0].albumId),
                    bannerTitle: "Trending Hits",
                  );

                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ViewAllScreenSongList(
                          banner: banner,
                          view_all_song_list_model: viewAllSongListModel)));

//             Navigator.of(context).push(MaterialPageRoute(
//                 builder: (context) =>  TrendingHitsViewAll(
//                   title: ConstantText.trendingHitsText,
// ),),);
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

          Container(
            padding: EdgeInsets.only(top: 16, right: 12, left: 12),
            height: 240,
            child: IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        List<PlayScreenModel> playScreenModel = [];
                        //  playScreenModel.add(PlayScreenModel(id: t, songName: songName, musicDirectorName: musicDirectorName, albumId: albumId, albumName: albumName))
                        // print(recentlyPlayed.records[index].id);
                        // for(int i=0;i<recentlyPlayed.records.length;i++){
                        //   playScreenModel.add(PlayScreenModel(id: recentlyPlayed.records[i].id, songName: recentlyPlayed.records[i].songName, musicDirectorName: recentlyPlayed.records[i].musicDirectorName[0], albumId: recentlyPlayed.records[i].albumId,albumName:recentlyPlayed.records[i].albumName));
                        // }
                        // print(playScreenModel.length);
                        // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MainPlayScreen(playScreenModel: playScreenModel, index: index)));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: DecorationImage(
                            image: NetworkImage(generateSongImageUrl(
                                trendingHitsModel.records[0].albumName,
                                trendingHitsModel.records[0].albumId)),
                            fit: BoxFit.fill,
                          ),
                        ),
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: PlayButtonWidget(),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              image: DecorationImage(
                                image: NetworkImage(generateSongImageUrl(
                                    trendingHitsModel.records[1].albumName,
                                    trendingHitsModel.records[1].albumId)),
                                fit: BoxFit.fill,
                              ),
                            ),
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: PlayButtonWidget(),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Expanded(
                            child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: DecorationImage(
                              image: NetworkImage(generateSongImageUrl(
                                  trendingHitsModel.records[2].albumName,
                                  trendingHitsModel.records[2].albumId)),
                              fit: BoxFit.fill,
                            ),
                          ),
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: PlayButtonWidget(),
                          ),
                        )),
                      ],
                    ),
                  ),
                  // Expanded(
                  //   flex: 7,
                  //   child: Container(
                  //     alignment: Alignment.center,
                  //     child: CustomColorContainer(
                  //       child: Stack(
                  //         alignment: Alignment.bottomRight,
                  //         children: [
                  //           Image.asset(
                  //             "assets/images/homepage/th1.png",
                  //             // height: 280,
                  //             fit: BoxFit.cover,
                  //           ),
                  //           PlayButtonWidget()
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // Expanded(
                  //   flex: 4,
                  //   child: Align(
                  //     alignment: Alignment.centerRight,
                  //     child: IntrinsicWidth(
                  //       child: Column(
                  //         mainAxisAlignment: MainAxisAlignment.end,
                  //         crossAxisAlignment: CrossAxisAlignment.stretch,
                  //         children: [
                  //           Expanded(
                  //             child: Align(
                  //               alignment: Alignment.center,
                  //               child: Stack(
                  //                 alignment: Alignment.bottomRight,
                  //                 children: [
                  //                   CustomColorContainer(
                  //                     child: Image.asset(
                  //                       "assets/images/t2.png",
                  //                       fit: BoxFit.fitHeight,
                  //                     ),
                  //                   ),
                  //                   PlayButtonWidget()
                  //                 ],
                  //               ),
                  //             ),
                  //           ),
                  //           SizedBox(
                  //             height: 8,
                  //           ),
                  //           Expanded(
                  //             child: Align(
                  //               alignment: Alignment.center,
                  //               child: Stack(
                  //                 alignment: Alignment.bottomRight,
                  //                 children: [
                  //                   CustomColorContainer(
                  //                     child: Image.asset(
                  //                       "assets/images/t3.png",
                  //                       fit: BoxFit.fitWidth,
                  //                     ),
                  //                   ),
                  //                   PlayButtonWidget()
                  //                 ],
                  //               ),
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          )
          //Code ERROR
          // Container(
          //   padding: EdgeInsets.all(8),
          //   height: 240,
          //   child: Row(
          //     children: [
          //       IntrinsicHeight(
          //         child: Expanded(
          //             child: Stack(
          //           alignment: Alignment.bottomRight,
          //           children: [
          //             CustomColorContainer(
          //               child: Image.asset(
          //                 "assets/images/t1.png",
          //               ),
          //             ),
          // Container(
          //   margin: EdgeInsets.all(8),
          //   padding: EdgeInsets.all(12),
          //   decoration: BoxDecoration(
          //       color: CustomColor.playIconBg,
          //       shape: BoxShape.circle),
          //   child: Icon(
          //     Icons.play_arrow_rounded,
          //     size: 24,
          //     color: CustomColor.secondaryColor,
          //   ),
          // )
          //           ],
          //         )),
          //       ),
          //       Expanded(
          //           child: Column(
          //         mainAxisAlignment: MainAxisAlignment.center,
          //         crossAxisAlignment: CrossAxisAlignment.stretch,
          //         children: [
          //           Expanded(
          //               child: Stack(
          //             alignment: Alignment.bottomRight,
          //             children: [
          //               CustomColorContainer(
          //                 child: Image.asset(
          //                   "assets/images/t2.png",
          //                   height: 112,
          //                   width: 141,
          //                   fit: BoxFit.contain,
          //                 ),
          //               ),
          //               Container(
          //                 margin: EdgeInsets.all(8),
          //                 padding: EdgeInsets.all(8),
          //                 decoration: BoxDecoration(
          //                     color: CustomColor.playIconBg,
          //                     shape: BoxShape.circle),
          //                 child: Icon(
          //                   Icons.play_arrow_rounded,
          //                   size: 24,
          //                   color: CustomColor.secondaryColor,
          //                 ),
          //               )
          //             ],
          //           )),
          //           SizedBox(
          //             height: 4,
          //           ),
          //           Expanded(
          //               child: Stack(
          //             alignment: Alignment.bottomRight,
          //             children: [
          //               CustomColorContainer(
          //                 child: Image.asset(
          //                   "assets/images/t2.png",
          //                   height: 112,
          //                   width: 141,
          //                   fit: BoxFit.contain,
          //                 ),
          //               ),
          //               Container(
          //                 margin: EdgeInsets.all(8),
          //                 padding: EdgeInsets.all(8),
          //                 decoration: BoxDecoration(
          //                     color: CustomColor.playIconBg,
          //                     shape: BoxShape.circle),
          //                 child: Icon(
          //                   Icons.play_arrow_rounded,
          //                   size: 24,
          //                   color: CustomColor.secondaryColor,
          //                 ),
          //               )
          //             ],
          //           )),
          //         ],
          //       ))
          //     ],
          //   ),
          // )

          //Code ERROR
        ],
      ),
    );
  }
}
