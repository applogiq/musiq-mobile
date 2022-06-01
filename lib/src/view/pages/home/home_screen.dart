import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:musiq/src/helpers/constants/color.dart';
import 'package:musiq/src/helpers/constants/images.dart';
import 'package:musiq/src/view/widgets/custom_color_container.dart';

import 'components/artist_list_view.dart';
import 'components/horizontal_list_view.dart';
import 'components/vertical_list_view.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);
  Images images = Images();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ListView(
          shrinkWrap: true,
          children: [
            SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: CustomColorContainer(
                        horizontalPadding: 1,
                        verticalPadding: 2,
                        bgColor: CustomColor.textfieldBg,
                        child: ConstrainedBox(
                          constraints: BoxConstraints.expand(
                              height: 40, width: double.maxFinite),
                          child: TextField(
                            decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.search_sharp,
                                  size: 30,
                                ),
                                border: InputBorder.none,
                                hintStyle: TextStyle(fontSize: 14),
                                hintText: "Search Music and Podcasts"),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    CustomColorContainer(
                      bgColor: CustomColor.textfieldBg,
                      horizontalPadding: 12,
                      verticalPadding: 6,
                      child: Center(
                        child: Stack(
                          children: [
                            Icon(Icons.notifications),
                            Positioned(
                              right: 2,
                              child: new Container(
                                padding: EdgeInsets.all(4.5),
                                decoration: new BoxDecoration(
                                  color: CustomColor.secondaryColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            HorizonalListViewWidget(
                title: "Recently Played",
                actionTitle: "",
                listWidget: Container(
                    alignment: Alignment.center,
                    child: CustomHorizontalListview(
                        images: images.recentlyPlayed))),
            TrendingHitsWidget(),
            HorizonalListViewWidget(
                title: "Recommended songs",
                actionTitle: "",
                listWidget:
                    CustomHorizontalListview(images: images.recommendedSong)),
            ArtistListView(images: images.artistList),
            HorizonalListViewWidget(
                title: "Top Podcasts",
                actionTitle: "",
                listWidget: CustomHorizontalListview(
                  images: images.podcastList,
                )),
            Container(
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: [
                  ListHeaderWidget(
                      title: "Based on your Interest", actionTitle: "View All"),
                  Container(
                      margin: EdgeInsets.only(top: 6),
                      child: CustomSongVerticalList(
                          images: images.basedOnYourInterestList))
                ],
              ),
            ),
            HorizonalListViewWidget(
              title: "Current Mood",
              actionTitle: "",
              listWidget: CustomHorizontalListview(
                shape: BoxShape.circle,
                alignText: TextAlign.center,
                images: images.currentMoodList,
              ),
            ),
            HorizonalListViewWidget(
                title: "Top Albums",
                actionTitle: "",
                listWidget: CustomHorizontalListview(
                  images: images.topAlbumList,
                )),
          ],
        ),
      ),
    );
  }
}

class TrendingHitsWidget extends StatelessWidget {
  const TrendingHitsWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
      child: Column(
        children: [
          ListHeaderWidget(
            title: "Trending Hits",
            actionTitle: "View All",
          ),
          Container(
            padding: EdgeInsets.only(top: 16),
            height: 240,
            child: IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 3,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: AssetImage("assets/images/t1.png"),
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
                    width: 12,
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              image: DecorationImage(
                                image: AssetImage("assets/images/t2.png"),
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
                              image: AssetImage("assets/images/t3.png"),
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

class PlayButtonWidget extends StatelessWidget {
  const PlayButtonWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.all(6),
      decoration:
          BoxDecoration(color: CustomColor.playIconBg, shape: BoxShape.circle),
      child: Icon(
        Icons.play_arrow_rounded,
        size: 20,
        color: CustomColor.secondaryColor,
      ),
    );
  }
}
