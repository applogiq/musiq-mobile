import 'package:flutter/material.dart';

import '../../../../helpers/constants/color.dart';
import '../../../widgets/custom_color_container.dart';

class CustomSongVerticalList extends StatelessWidget {
  const CustomSongVerticalList({
    Key? key,
    required this.images,
  }) : super(key: key);

  final List images;

  @override
  Widget build(BuildContext context) {
    return Column(
        children: List.generate(
      images.length,
      (index) => Container(
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: CustomColorContainer(
                // bgColor: Colors.green,
                child: Image.asset(images[index].imageURL, height: 60),
              ),
            ),
            Expanded(
                flex: 4,
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
            Expanded(child: Icon(Icons.play_arrow_rounded)),
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
