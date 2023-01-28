import 'package:flutter/material.dart';
import 'package:musiq/src/features/home/provider/view_all_provider.dart';
import 'package:musiq/src/features/home/view_all_status.dart';
import 'package:provider/provider.dart';

import '../../../constants/color.dart';
import '../../../constants/string.dart';
import '../../../utils/image_url_generate.dart';
import '../../player/screen/player_screen/player_controller.dart';
import '../domain/model/trending_hits_model.dart';
import '../screens/sliver_app_bar/view_all_screen.dart';

class TrendingHitsWidget extends StatelessWidget {
  const TrendingHitsWidget({
    Key? key,
    required this.trendingHitsModel,
  }) : super(key: key);
  final TrendingHitsModel trendingHitsModel;
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.fromLTRB(12.0, 12, 12.0, 0),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                ConstantText.trendingHitsText,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const ViewAllScreen(
                            status: ViewAllStatus.trendingHits,
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
          Container(
            padding: const EdgeInsets.only(top: 16, right: 12, left: 12),
            height: 240,
            child: IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: InkWell(
                      // onTap: () {
                      //   List<PlayScreenModel> playScreenModel = [];
                      //   print(trendingHitsModel.records[0].id);
                      //   for (int i = 0;
                      //       i < trendingHitsModel.records.length;
                      //       i++) {
                      //     playScreenModel.add(PlayScreenModel(
                      //         id: trendingHitsModel.records[i].id,
                      //         songName: trendingHitsModel.records[i].songName,
                      //         musicDirectorName: trendingHitsModel
                      //             .records[i].musicDirectorName[0],
                      //         albumId: trendingHitsModel.records[i].albumId,
                      //         albumName:
                      //             trendingHitsModel.records[i].albumName));
                      //   }
                      //   print(playScreenModel.length);
                      //   Navigator.of(context).push(MaterialPageRoute(
                      //       builder: (context) => MainPlayScreen(
                      //           playScreenModel: playScreenModel, index: 0)));
                      //   //  playScreenModel.add(PlayScreenModel(id: t, songName: songName, musicDirectorName: musicDirectorName, albumId: albumId, albumName: albumName))
                      //   // print(recentlyPlayed.records[index].id);
                      //   // for(int i=0;i<recentlyPlayed.records.length;i++){
                      //   //   playScreenModel.add(PlayScreenModel(id: recentlyPlayed.records[i].id, songName: recentlyPlayed.records[i].songName, musicDirectorName: recentlyPlayed.records[i].musicDirectorName[0], albumId: recentlyPlayed.records[i].albumId,albumName:recentlyPlayed.records[i].albumName));
                      //   // }
                      //   // print(playScreenModel.length);
                      //   // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MainPlayScreen(playScreenModel: playScreenModel, index: index)));
                      // },

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
                          child: InkWell(
                              onTap: () {
                                context.read<ViewAllProvider>().getViewAll(
                                    ViewAllStatus.trendingHits,
                                    context: context,
                                    goToNextfunction: true,
                                    index: 0);
                              },
                              child: PlayButtonWidget()),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        TrendingHitsHomeContainer(
                          trendingHitsModel: trendingHitsModel,
                          index: 1,
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        TrendingHitsHomeContainer(
                          trendingHitsModel: trendingHitsModel,
                          index: 2,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class TrendingHitsHomeContainer extends StatelessWidget {
  const TrendingHitsHomeContainer({
    Key? key,
    required this.trendingHitsModel,
    required this.index,
  }) : super(key: key);

  final TrendingHitsModel trendingHitsModel;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            image: DecorationImage(
              image: NetworkImage(generateSongImageUrl(
                  trendingHitsModel.records[index].albumName,
                  trendingHitsModel.records[index].albumId)),
              fit: BoxFit.fill,
            ),
          ),
          child: InkWell(
            onTap: () {
              context.read<ViewAllProvider>().getViewAll(
                  ViewAllStatus.trendingHits,
                  context: context,
                  goToNextfunction: true,
                  index: index);
            },
            child: Align(
              alignment: Alignment.bottomRight,
              child: PlayButtonWidget(),
            ),
          ),
        ),
      ),
    );
  }
}
