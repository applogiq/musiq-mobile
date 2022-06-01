import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:musiq/src/helpers/constants/color.dart';
import 'package:musiq/src/helpers/constants/images.dart';
import 'package:musiq/src/view/widgets/custom_color_container.dart';

import 'components/artist_list_view.dart';
import 'components/horizontal_list_view.dart';
import 'components/trending_hits.dart';
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
                                prefixIcon: Container(
                                  padding: EdgeInsets.all(12),
                                  child: Image.asset(
                                    "assets/icons/search.png",
                                    height: 16,
                                    width: 16,
                                    color: Colors.white,
                                  ),
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
                      margin: EdgeInsets.only(top: 10),
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
