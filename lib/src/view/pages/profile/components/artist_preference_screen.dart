import 'package:flutter/material.dart';
import 'package:musiq/src/helpers/constants/images.dart';
import 'package:musiq/src/helpers/constants/style.dart';

import '../../../../helpers/constants/color.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/custom_color_container.dart';

class ArtistPreferenceScreen extends StatelessWidget {
  const ArtistPreferenceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(double.maxFinite, 50),
        child: CustomAppBarWidget(
          title: "Artist Preference",
        ),
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          SizedBox(
            height: 12,
          ),
          CustomArtistVerticalList(images: Images().artistPrefList),
        ],
      ),
    );
  }
}

class CustomArtistVerticalList extends StatelessWidget {
  CustomArtistVerticalList(
      {Key? key, required this.images, this.playButton = true})
      : super(key: key);

  final List images;
  bool playButton;

  @override
  Widget build(BuildContext context) {
    return Column(
        children: List.generate(
      images.length,
      (index) => Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.all(8),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.centerLeft,
                child: CustomColorContainer(
                  child: Image.asset(
                    images[index].imageURL,
                    height: 70,
                    width: 70,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            Expanded(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(4.0, 8.0, 8.0, 8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        images[index].title,
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 14),
                      ),
                      Row(
                        children: [
                          Icon(Icons.people),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            images[index].subTitle,
                            style: TextStyle(
                                color: CustomColor.subTitle,
                                fontWeight: FontWeight.w400,
                                fontSize: 14),
                          ),
                        ],
                      ),
                    ],
                  ),
                )),
            Expanded(
                flex: 3,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: images[index].isFollowing ? 8 : 16,
                      vertical: 4),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: images[index].isFollowing ? 8 : 16,
                        vertical: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: images[index].isFollowing
                          ? CustomColor.followingColor
                          : CustomColor.secondaryColor,
                    ),
                    child: Center(
                      child: Text(
                        images[index].isFollowing ? "Following" : "Follow",
                        style: fontWeight400(),
                      ),
                    ),
                  ),
                ))
          ],
        ),
      ),
    ));
  }
}
