import 'package:flutter/material.dart';
import 'package:musiq/src/helpers/constants/images.dart';
import 'package:musiq/src/helpers/constants/style.dart';
import 'package:musiq/src/model/Image_model.dart';

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

class CustomArtistVerticalList extends StatefulWidget {
  CustomArtistVerticalList(
      {Key? key, required this.images, this.playButton = true})
      : super(key: key);

  final List images;
  bool playButton;

  @override
  State<CustomArtistVerticalList> createState() =>
      _CustomArtistVerticalListState();
}

class _CustomArtistVerticalListState extends State<CustomArtistVerticalList> {
  @override
  Widget build(BuildContext context) {
    return Column(
        children: List.generate(
      widget.images.length,
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
                    widget.images[index].imageURL,
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
                        widget.images[index].title,
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
                            widget.images[index].subTitle,
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
                      horizontal: widget.images[index].isFollowing ? 8 : 16,
                      vertical: 4),
                  child: InkWell(
                    onTap: () {
                      var temp1 = widget.images[index].isFollowing;
                      var temp2 = widget.images[index].subTitle;
                      var temp3 = widget.images[index].title;
                      var temp4 = widget.images[index].imageURL;
                      print(temp1);
                      print(temp2);
                      print(temp3);
                      // String imageUrl=widget.images[index].

                      widget.images.removeAt(index);
                      widget.images.insert(
                          index,
                          ArtistImageModel(
                              imageURL: temp4,
                              title: temp3,
                              subTitle: temp2,
                              isFollowing: temp1 != temp1));
                      print(widget.images[index].isFollowing);
                      setState(() {
                        widget.images[index].isFollowing !=
                            widget.images[index].isFollowing;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: widget.images[index].isFollowing ? 8 : 16,
                          vertical: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: widget.images[index].isFollowing
                            ? CustomColor.followingColor
                            : CustomColor.secondaryColor,
                      ),
                      child: Center(
                        child: Text(
                          widget.images[index].isFollowing
                              ? "Following"
                              : "Follow",
                          style: fontWeight400(),
                        ),
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
