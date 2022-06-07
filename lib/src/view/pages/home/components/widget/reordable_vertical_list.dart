import 'package:flutter/material.dart';
import 'package:musiq/src/helpers/constants/color.dart';
import 'package:musiq/src/helpers/constants/style.dart';
import 'package:musiq/src/view/pages/play/play_screen.dart';
import 'package:musiq/src/view/widgets/custom_color_container.dart';

import '../../../../../model/Image_model.dart';

class CustomReorderableVerticalList extends StatefulWidget {
  CustomReorderableVerticalList(
      {Key? key, required this.images, this.isFromUpNext=false,this.highlightindex=0})
      : super(key: key);

  final List images;
  bool isFromUpNext;
  int highlightindex;

  @override
  State<CustomReorderableVerticalList> createState() => _CustomReorderableVerticalListState();
}

class _CustomReorderableVerticalListState extends State<CustomReorderableVerticalList> {
  @override
  Widget build(BuildContext context) {
    return ReorderableListView.builder(shrinkWrap: true,itemBuilder: (context,index){
      return 

Container(
  key: Key(index.toString()),
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.all(8),
        child: InkWell(
          onTap: () {
            print(index);
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => PlayScreen(
                  index: index,
                      imageURL: widget.images[index].imageURL,
                      songName: widget.images[index].title,
                      artistName: widget.images[index].subTitle,
                    )));
          },
          child: Row(
            children: [
           widget.isFromUpNext? Padding(
             padding: const EdgeInsets.only(right:16.0),
             child: Icon(widget.highlightindex==index?Icons.play_arrow_rounded: Icons.view_stream,color: widget.highlightindex==index?CustomColor.secondaryColor:Colors.white,),
           )
            :SizedBox(height: 0,width: 0,),
              Expanded(
                flex: 3,
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
                  flex: 9,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.images[index].title,
                          style: fontWeight400(color: (widget.highlightindex==index && widget.isFromUpNext==true) ?CustomColor.secondaryColor:Colors.white),
                        ),
                        Text(
                          widget.images[index].subTitle,
                          style: fontWeight400(size: 12.0,color: widget.highlightindex==index&& widget.isFromUpNext==true?CustomColor.secondaryLightColor:CustomColor.subTitle),
                        ),
                      ],
                    ),
                  )),
             
              Expanded(
                  child: Align(
                      alignment: Alignment.centerRight,
                      child: Icon(Icons.more_vert_rounded)))
            ],
          ),
        ),
      )
  ;
    }, itemCount: widget.images.length, onReorder:  (int oldIndex, int newIndex) {
        setState(() {
          if (oldIndex < newIndex) {
            newIndex -= 1;
          }
          final ImageModel item = widget.images.removeAt(oldIndex);
          widget.images.insert(newIndex, item);
        });
      },);
  }
}
