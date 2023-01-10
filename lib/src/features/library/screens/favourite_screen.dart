import 'package:flutter/material.dart';
import 'package:musiq/src/common_widgets/loader.dart';
import 'package:musiq/src/features/library/provider/library_provider.dart';
import 'package:musiq/src/utils/image_url_generate.dart';
import 'package:provider/provider.dart';

import '../../../common_widgets/container/custom_color_container.dart';
import '../../../constants/color.dart';
import '../../../constants/style.dart';

class FavouritesScreen extends StatefulWidget {
  const FavouritesScreen({super.key});

  @override
  State<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      context.read<LibraryProvider>().getFavouritesList();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LibraryProvider>(builder: (context, pro, _) {
      return pro.isFavouriteLoad
          ? const LoaderScreen()
          : ListView.builder(
              itemCount: pro.favouriteModel.records.length,
              itemBuilder: (context, index) {
                var record = pro.favouriteModel.records;
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: CustomColorContainer(
                          child: Image.network(
                            generateSongImageUrl(
                                record[index].albumName, record[index].albumId),
                            height: 70,
                            width: 70,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Expanded(
                          flex: 8,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  record[index].songName,
                                  style: fontWeight400(),
                                ),
                                Text(
                                  "${record[index].albumName} - ${record[index].musicDirectorName[0]}",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: fontWeight400(
                                      size: 12.0, color: CustomColor.subTitle),
                                ),
                              ],
                            ),
                          )),
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.only(right: 16.0),
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
                            // onSelected: (value) {
                            //   _onMenuItemSelected(value as int);
                            // },
                            itemBuilder: (ctx) => [
                              //   _buildPopupMenuItem('Play next'),
                              //   _buildPopupMenuItem('Add to queue'),
                              //   _buildPopupMenuItem('Remove'),
                              //   _buildPopupMenuItem('Song info'),
                            ],
                          ),
                        ),
                      ))
                    ],
                  ),
                );
              }
              // Column(
              //   children: [
              //     Container(

              //         alignment: Alignment.centerLeft,
              //         padding: const EdgeInsets.all(8),
              //         child: InkWell(
              //             onTap: () {
              //               // var songPlayList=[];
              //               // for(int i=0;i<songList.length;i++){

              //               //   songPlayList.add(songList.records[i].id);
              //               // }
              //               // print(index);
              //               // Navigator.of(context).push(MaterialPageRoute(
              //               //     builder: (context) => PlayScreen(
              //               //       songList: songList,
              //               //       index: index,
              //               //       id:songList.records[index].id.toString(),
              //               //           imageURL:  "${APIConstants.SONG_BASE_URL}public/music/tamil/${songList.records[index].albumName[0].toUpperCase()}/${songList.records[index].albumName}/image/${songList.records[index].albumId}.png",
              //               //           songName: songList.records[index].songName,
              //               //           artistName: songList.records[index].musicDirectorName[0].toString(),
              //               //           songplayList: songPlayList,
              //               //         )));
              //             },
              //             child: const Text("Favourites")),
              //       ),
              //   ],
              // );
              );
    });
  }
}
