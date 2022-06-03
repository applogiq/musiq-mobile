import 'package:flutter/material.dart';
import 'package:musiq/src/helpers/constants/images.dart';
import 'package:musiq/src/view/pages/home/components/pages/artist_view_all_screen.dart';
import 'package:musiq/src/view/pages/home/components/pages/view_all_screen.dart';
import 'package:musiq/src/view/widgets/custom_color_container.dart';

import '../../../../../helpers/constants/color.dart';

class CustomHorizontalListview extends StatelessWidget {
  CustomHorizontalListview(
      {Key? key,
      required this.images,
      this.shape = BoxShape.rectangle,
      this.alignText = TextAlign.left})
      : super(key: key);

  final List images;
  var shape;
  var alignText;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 8),
      height: alignText == TextAlign.center ? 180 : 200,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          itemCount: images.length,
          itemBuilder: (context, index) => Row(
                children: [
                  index == 0
                      ? SizedBox(
                          width: 10,
                        )
                      : SizedBox(),
                  Container(
                    padding: EdgeInsets.fromLTRB(6, 8, 6, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: alignText == TextAlign.center
                          ? CrossAxisAlignment.center
                          : CrossAxisAlignment.start,
                      children: [
                        CustomColorContainer(
                          shape: shape,
                          child: Image.asset(
                            images[index].imageURL,
                            height: 125,
                            width: 125,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Text(
                          images[index].title,
                          style: TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 12),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        images[index].subTitle == ""
                            ? SizedBox(
                                height: 0,
                              )
                            : Text(images[index].subTitle,
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12,
                                    color: CustomColor.subTitle))
                      ],
                    ),
                  ),
                ],
              )),
    );
  }
}

class HorizonalListViewWidget extends StatelessWidget {
  const HorizonalListViewWidget({
    Key? key,
    required this.title,
    required this.actionTitle,
    required this.listWidget,
  }) : super(key: key);
  final String title;
  final String actionTitle;
  final Widget listWidget;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(12.0, 20.0, 12.0, 0.0),
          child: ListHeaderWidget(title: title, actionTitle: actionTitle),
        ),
        listWidget
      ],
    );
  }
}

class ListHeaderWidget extends StatelessWidget {
  ListHeaderWidget(
      {Key? key,
      required this.title,
      required this.actionTitle,
      this.isArtist = false})
      : super(key: key);

  final String title;
  final String actionTitle;
  bool isArtist;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        Spacer(),
        InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => isArtist
                    ? ArtistListViewAll()
                    : ViewAllScreen(title: title)));
          },
          child: Text(
            actionTitle,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: CustomColor.secondaryColor),
          ),
        )
      ],
    );
  }
}
