import 'package:flutter/material.dart';
import 'package:musiq/src/features/library/domain/models/playlist_model.dart';

import '../../../common_widgets/container/custom_color_container.dart';
import '../../../constants/color.dart';
import '../../../constants/style.dart';
import '../../../constants/style/box_decoration.dart';
import '../../../utils/image_url_generate.dart';

class PlaylistTile extends StatelessWidget {
  const PlaylistTile(
      {super.key,
      required this.record,
      required this.index,
      this.isMore = true,
      required this.callBack});
  final List<Record> record;
  final int index;
  final bool isMore;
  final Function callBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          callBack();
        },
        child: Row(
          children: [
            record[index].noOfSongs == 0
                ? Container(
                    height: 70,
                    width: 70,
                    decoration: playListNoImageDecoration(),
                    child: Center(
                      child: Text(
                        record[index].playlistName[0].toString().toUpperCase(),
                        style: fontWeight600(),
                      ),
                    ),
                  )
                : Align(
                    alignment: Alignment.centerLeft,
                    child: CustomColorContainer(
                      bgColor: record[index].noOfSongs == 0
                          ? CustomColor.defaultCard
                          : Colors.transparent,
                      child: record[index].noOfSongs == 0
                          ? Container(
                              height: 70,
                              width: 70,
                              alignment: Alignment.center,
                              child: Text(record[index].playlistName[0]))
                          : Image.network(
                              generateSongImageUrl(
                                  record[index].albumName.toString(),
                                  record[index].albumId.toString()),
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
                        record[index].playlistName.toString(),
                        style: fontWeight400(),
                      ),
                      Text(
                        "Playlist -${record[index].noOfSongs} songs",
                        style: fontWeight400(
                            size: 12.0, color: CustomColor.subTitle),
                      ),
                    ],
                  ),
                )),
            isMore
                ? Expanded(
                    flex: 2,
                    child: Align(
                      // alignment: Alignment.centerRight,
                      child: PopupMenuButton(
                        color: CustomColor.appBarColor,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(8.0),
                            bottomRight: Radius.circular(8.0),
                            topLeft: Radius.circular(8.0),
                            topRight: Radius.circular(8.0),
                          ),
                        ),
                        onSelected: (value) {
                          // _onMenuItemSelected(value as int);
                          // _onMenuItemSelected(value as int);
                        },
                        itemBuilder: (ctx) => [
                          // _buildPopupMenuItem('Play All',
                          //     Options.play.index),
                          // _buildPopupMenuItem(
                          //     'Add to queue',
                          //     Options.queue.index),
                          // _buildPopupMenuItem('Delete',
                          //     Options.delete.index,
                          //     id: libraryController
                          //         .view_all_play_list
                          //         .records[index]
                          //         .id),
                        ],
                      ),
                    ),
                  )
                : const SizedBox.shrink()
          ],
        ),
      ),
    );
  }
}
