import 'package:flutter/material.dart';
import 'package:musiq/src/features/home/domain/model/collection_view_all_model.dart';

import '../../../common_widgets/container/custom_color_container.dart';
import '../../../constants/color.dart';
import '../../../constants/style.dart';
import '../../../utils/image_url_generate.dart';

class ReorderListUpNextSongTile extends StatefulWidget {
  const ReorderListUpNextSongTile({
    Key? key,
    required this.playScreenModel,
    required this.index,
  }) : super(key: key);
// final SongController songController;
  final CollectionViewAllModel playScreenModel;
  final int index;

  @override
  State<ReorderListUpNextSongTile> createState() =>
      _ReorderListUpNextSongTileState();
}

class _ReorderListUpNextSongTileState extends State<ReorderListUpNextSongTile> {
  @override
  Widget build(BuildContext context) {
    return ReorderableListView.builder(
      itemCount: widget.playScreenModel.records.length,
      shrinkWrap: true,
      itemBuilder: (context, indexList) {
        return Container(
          key: Key(indexList.toString()),
          padding: const EdgeInsets.symmetric(vertical: 4),
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: [
              InkWell(
                child: Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Icon(
                    widget.index == indexList
                        ? Icons.play_arrow_rounded
                        : Icons.view_stream_rounded,
                    color: widget.index == indexList
                        ? CustomColor.secondaryColor
                        : Colors.white,
                    size: 18,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: CustomColorContainer(
                  child: Image.network(
                    generateSongImageUrl(
                        widget.playScreenModel.records[indexList]!.albumName,
                        widget.playScreenModel.records[indexList]!.albumId),
                    height: 70,
                    width: 70,
                    fit: BoxFit.fill,
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
                          widget.playScreenModel.records[indexList]!.songName,
                          style: fontWeight400(
                              color: indexList == widget.index
                                  ? CustomColor.secondaryColor
                                  : Colors.white),
                        ),
                        Text(
                          widget.playScreenModel.records[indexList]!
                              .musicDirectorName![0]!,
                          style: fontWeight400(
                              size: 12.0,
                              color: indexList == widget.index
                                  ? CustomColor.secondaryColor
                                  : CustomColor.subTitle),
                        ),
                      ],
                    ),
                  )),
              const Expanded(
                  child: Align(
                      alignment: Alignment.centerRight,
                      child: Icon(Icons.more_vert_rounded)))
            ],
          ),
        );
      },
      onReorder: (int oldIndex, int newIndex) {
        setState(() {
          if (oldIndex < newIndex) {
            newIndex -= 1;
          }
          var item = widget.playScreenModel.records.removeAt(oldIndex);
          widget.playScreenModel.records.insert(newIndex, item);
        });
      },
    );
  }
}
