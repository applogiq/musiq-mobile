import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../common_widgets/container/custom_color_container.dart';
import '../../../../constants/color.dart';
import '../../../../constants/string.dart';
import '../../../../constants/style.dart';
import '../../../../constants/style/box_decoration.dart';
import '../../../../utils/image_url_generate.dart';
import '../../domain/models/playlist_model.dart';
import '../../provider/library_provider.dart';

class PlaylistTile extends StatelessWidget {
  const PlaylistTile(
      {super.key,
      required this.record,
      required this.index,
      this.isMore = true,
      required this.callBack});

  final Function callBack;
  final int index;
  final bool isMore;
  final List<Record> record;

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
                          switch (value) {
                            case 1:
                              context
                                  .read<LibraryProvider>()
                                  .play(record[index].id, context);
                              break;
                            case 2:
                              context
                                  .read<LibraryProvider>()
                                  .addToQueue(record[index].id, context);
                              print("queue");
                              break;
                            case 3:
                              print("delete");
                              context
                                  .read<LibraryProvider>()
                                  .deletePlayList(record[index].id);
                              break;
                          }
                        },
                        itemBuilder: (ctx) => [
                          PopupMenuItem(
                            enabled:
                                record[index].noOfSongs == 0 ? false : true,
                            value: 1,
                            child: const Text(ConstantText.playAll),
                          ),
                          PopupMenuItem(
                            enabled:
                                record[index].noOfSongs == 0 ? false : true,
                            value: 2,
                            child: const Text(ConstantText.addToQueue),
                          ),
                          const PopupMenuItem(
                            value: 3,
                            child: Text(ConstantText.delete),
                          ),
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
