import 'package:flutter/material.dart';
import 'package:musiq/src/helpers/constants/color.dart';
import 'package:musiq/src/view/widgets/custom_color_container.dart';

class CustomSongVerticalList extends StatelessWidget {
  CustomSongVerticalList(
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
              flex: 3,
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
                flex: 9,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        images[index].title,
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 14),
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
                )),
            Expanded(
                child: playButton
                    ? Align(
                        alignment: Alignment.centerRight,
                        child: Icon(Icons.play_arrow_rounded),
                      )
                    : Container()),
            Expanded(
                child: Align(
                    alignment: Alignment.centerRight,
                    child: Icon(Icons.more_vert_rounded)))
          ],
        ),
      ),
    ));
  }
}
