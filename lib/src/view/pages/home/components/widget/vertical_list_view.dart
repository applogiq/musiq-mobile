import 'package:flutter/material.dart';
import 'package:musiq/src/helpers/constants/color.dart';
import 'package:musiq/src/helpers/constants/style.dart';
import 'package:musiq/src/view/pages/play/play_screen.dart';
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
        child: InkWell(
          onTap: () {
            print(index);
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => PlayScreen(
                  index: index,
                      imageURL: images[index].imageURL,
                      songName: images[index].title,
                      artistName: images[index].subTitle,
                    )));
          },
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
                          style: fontWeight400(),
                        ),
                        Text(
                          images[index].subTitle,
                          style: fontWeight400(size: 12.0,),
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
      ),
    ));
  }
}
