import 'package:flutter/material.dart';
import 'package:musiq/src/view/pages/home/home_screen.dart';

import '../../../widgets/custom_color_container.dart';
import 'horizontal_list_view.dart';

class ArtistListView extends StatelessWidget {
  const ArtistListView({
    Key? key,
    required this.images,
  }) : super(key: key);

  final List images;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 0.0),
          child: ListHeaderWidget(
            title: "Artists",
            actionTitle: "View All",
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 4),
          height: 300,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              itemCount: images.length,
              itemBuilder: (context, index) => Row(
                    children: [
                      index == 0
                          ? SizedBox(
                              width: 12,
                            )
                          : SizedBox(),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 6),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomColorContainer(
                              child: Image.asset(
                                images[index].imageURL,
                                height: 240,
                                width: 200,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Text(
                              images[index].title,
                              style: TextStyle(
                                  fontWeight: FontWeight.w400, fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )),
        )
      ],
    );
  }
}
