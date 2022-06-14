import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:musiq/src/helpers/constants/color.dart';
import 'package:musiq/src/helpers/constants/images.dart';
import 'package:musiq/src/view/pages/home/components/pages/search_screen.dart';
import 'package:musiq/src/view/pages/home/components/widget/artist_list_view.dart';
import 'package:musiq/src/view/pages/home/components/widget/horizontal_list_view.dart';
import 'package:musiq/src/view/pages/home/components/widget/trending_hits.dart';
import 'package:musiq/src/view/pages/home/components/widget/vertical_list_view.dart';
import 'package:musiq/src/view/widgets/custom_color_container.dart';

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
                      child: SearchTextWidget(
                        isReadOnly: true,
                        onTap: () {
                          print("DATA");
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => SearchScreen()));
                        },
                        hint: "Search Music and Podcasts",
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    CustomColorContainer(
                      bgColor: CustomColor.textfieldBg,
                      left: 12,
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
                actionTitle: "View All",
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
                title: "New Releases",
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

class SearchTextWidget extends StatelessWidget {
  SearchTextWidget({
    Key? key,
    required this.hint,
    this.isReadOnly = false,
    required this.onTap,
  }) : super(key: key);
  final String hint;
  bool isReadOnly;

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return CustomColorContainer(
      left: 1,
      verticalPadding: 2,
      bgColor: CustomColor.textfieldBg,
      child: ConstrainedBox(
        constraints: BoxConstraints.expand(height: 40, width: double.maxFinite),
        child: TextField(
          onTap: onTap,
          readOnly: isReadOnly,
          onChanged: (val) {},
          cursorColor: Colors.white,
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
              hintText: hint),
        ),
      ),
    );
  }
}
