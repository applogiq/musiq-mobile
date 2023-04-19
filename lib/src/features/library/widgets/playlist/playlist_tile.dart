import 'package:flutter/material.dart';
import 'package:musiq/src/common_widgets/box/horizontal_box.dart';
import 'package:musiq/src/core/constants/images.dart';
import 'package:musiq/src/features/library/widgets/favourite/alert_packages/show_dialog_package.dart';
import 'package:provider/provider.dart';

import '../../../../common_widgets/container/custom_color_container.dart';
import '../../../../core/constants/color.dart';
import '../../../../core/constants/string.dart';
import '../../../../core/constants/style.dart';
import '../../../../core/constants/style/box_decoration.dart';
import '../../../../core/utils/size_config.dart';
import '../../../../core/utils/url_generate.dart';
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
      padding: const EdgeInsets.only(left: 16, top: 16),
      child: InkWell(
        onTap: () {
          callBack();
        },
        child: Row(
          children: [
            record[index].noOfSongs == 0
                ? Container(
                    height: 60,
                    width: 60,
                    decoration: playListNoImageDecoration(),
                    child: Center(
                      child: Text(
                        // "S",
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
                              height: 60,
                              width: 60,
                              alignment: Alignment.center,
                              child: Text(record[index].playlistName[0]))
                          : Image.network(
                              generateSongImageUrl(
                                  record[index].albumName.toString(),
                                  record[index].albumId.toString()),
                              height: 60,
                              width: 60,
                              fit: BoxFit.fill,
                              errorBuilder: (context, error, stackTrace) =>
                                  Image.asset(
                                Images.noSong,
                                height: 60,
                                width: 60,
                                fit: BoxFit.fill,
                              ),
                            ),
                    ),
                  ),
            const HorizontalBox(width: 7),
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
                      alignment: Alignment.centerRight,
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

                              break;
                            case 3:
                              showAnimatedDialog(
                                context: context,
                                barrierDismissible: true,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    backgroundColor:
                                        const Color.fromRGBO(33, 33, 44, 1),
                                    title: const Center(
                                        child: Text("Delete Playlist")),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Text(
                                          "Are you sure you want to delete playlist",
                                          style: TextStyle(fontSize: 14),
                                        ),
                                        Text(
                                          "${record[index].playlistName} ?",
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        child: Container(
                                          height:
                                              getProportionateScreenHeight(44),
                                          width:
                                              getProportionateScreenWidth(120),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              color: const Color.fromRGBO(
                                                  255, 255, 255, 0.1)),
                                          child: const Center(
                                              child: Text("Cancel")),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () async {
                                          context
                                              .read<LibraryProvider>()
                                              .deletePlayList(record[index].id);
                                          Navigator.pop(context);
                                        },
                                        child: Container(
                                          height:
                                              getProportionateScreenHeight(44),
                                          width:
                                              getProportionateScreenWidth(120),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              color: const Color.fromRGBO(
                                                  254, 86, 49, 1)),
                                          child: const Center(
                                              child: Text("Confirm")),
                                        ),
                                      ),
                                      SizedBox(
                                        width: getProportionateScreenWidth(5),
                                      )
                                    ],
                                  );
                                },
                                animationType:
                                    DialogTransitionType.slideFromLeft,
                                curve: Curves.fastOutSlowIn,
                                // duration: const Duration(seconds: 1),
                              );
                              // showDialog(
                              //   context: context,
                              //   builder: (BuildContext context) {
                              //     return AlertDialog(
                              //       backgroundColor:
                              //           const Color.fromRGBO(33, 33, 44, 1),
                              //       title: const Center(
                              //           child: Text("Delete Playlist")),
                              //       content: Column(
                              //         mainAxisSize: MainAxisSize.min,
                              //         children: [
                              //           const Text(
                              //             "Are you sure you want to delete playlist",
                              //             style: TextStyle(fontSize: 14),
                              //           ),
                              //           Text(
                              //             "${record[index].playlistName} ?",
                              //             style: const TextStyle(
                              //                 fontSize: 16,
                              //                 fontWeight: FontWeight.bold),
                              //           ),
                              //         ],
                              //       ),
                              //       actions: [
                              //         GestureDetector(
                              //           onTap: () {
                              //             Navigator.pop(context);
                              //           },
                              //           child: Container(
                              //             height:
                              //                 getProportionateScreenHeight(44),
                              //             width:
                              //                 getProportionateScreenWidth(120),
                              //             decoration: BoxDecoration(
                              //                 borderRadius:
                              //                     BorderRadius.circular(12),
                              //                 color: const Color.fromRGBO(
                              //                     255, 255, 255, 0.1)),
                              //             child: const Center(
                              //                 child: Text("Cancel")),
                              //           ),
                              //         ),
                              //         GestureDetector(
                              //           onTap: () async {
                              //             context
                              //                 .read<LibraryProvider>()
                              //                 .deletePlayList(record[index].id);
                              //             Navigator.pop(context);
                              //           },
                              //           child: Container(
                              //             height:
                              //                 getProportionateScreenHeight(44),
                              //             width:
                              //                 getProportionateScreenWidth(120),
                              //             decoration: BoxDecoration(
                              //                 borderRadius:
                              //                     BorderRadius.circular(12),
                              //                 color: const Color.fromRGBO(
                              //                     254, 86, 49, 1)),
                              //             child: const Center(
                              //                 child: Text("Confirm")),
                              //           ),
                              //         ),
                              //         SizedBox(
                              //           width: getProportionateScreenWidth(5),
                              //         )
                              //       ],
                              //     );
                              //   },
                              // );

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
