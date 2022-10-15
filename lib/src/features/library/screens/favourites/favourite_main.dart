import 'package:flutter/material.dart';
import '../../../../common_widgets/container/custom_color_container.dart';
import '../../../../constants/color.dart';
import '../../../../constants/string.dart';
import '../../../../constants/style.dart';
import '../../domain/models/view_all_song_list_model.dart';
import 'no_favourite.dart';

class FavouritesMain extends StatelessWidget {
  const FavouritesMain({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
        // libraryController.view_all_songs_list.length==0

        0 == 0
            ? NoSongScreen(
                isFav: true,
                mainTitle: ConstantText.noSongHere,
                subTitle: ConstantText.yourfavNoAvailable,
              )
            : Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Column(
                        children: List.generate(
                      0,
                      // libraryController.view_all_songs_list.length,
                      (index) => Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.all(8),
                        child: InkWell(
                            onTap: () {
                              // var songPlayList=[];
                              // for(int i=0;i<songList.length;i++){

                              //   songPlayList.add(songList.records[i].id);
                              // }
                              // print(index);
                              // Navigator.of(context).push(MaterialPageRoute(
                              //     builder: (context) => PlayScreen(
                              //       songList: songList,
                              //       index: index,
                              //       id:songList.records[index].id.toString(),
                              //           imageURL:  "${APIConstants.SONG_BASE_URL}public/music/tamil/${songList.records[index].albumName[0].toUpperCase()}/${songList.records[index].albumName}/image/${songList.records[index].albumId}.png",
                              //           songName: songList.records[index].songName,
                              //           artistName: songList.records[index].musicDirectorName[0].toString(),
                              //           songplayList: songPlayList,
                              //         )));
                            },
                            child: SongListTile(
                                view_all_song_list_model: [], index: index)),
                      ),
                    )),
                  ],
                ),
              );
  }
}

class SongListTile extends StatelessWidget {
  const SongListTile({
    Key? key,
    required this.view_all_song_list_model,
    required this.index,
  }) : super(key: key);
  final int index;
  final List<ViewAllSongList> view_all_song_list_model;
  PopupMenuItem _buildPopupMenuItem(String title, {int position = 0}) {
    return PopupMenuItem(
      value: position,
      child: Row(
        children: [
          Text(title),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: CustomColorContainer(
            child: Image.network(
              view_all_song_list_model[index].songImageUrl,
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
                    view_all_song_list_model[index].songName,
                    style: fontWeight400(),
                  ),
                  Text(
                    view_all_song_list_model[index].albumName +
                        " - " +
                        view_all_song_list_model[index].songMusicDirector,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style:
                        fontWeight400(size: 12.0, color: CustomColor.subTitle),
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
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(8.0),
                  bottomRight: Radius.circular(8.0),
                  topLeft: Radius.circular(8.0),
                  topRight: Radius.circular(8.0),
                ),
              ),
              onSelected: (value) {
                _onMenuItemSelected(value as int);
              },
              itemBuilder: (ctx) => [
                _buildPopupMenuItem('Play next'),
                _buildPopupMenuItem('Add to queue'),
                _buildPopupMenuItem('Remove'),
                _buildPopupMenuItem('Song info'),
              ],
            ),
          ),
        ))
      ],
    );
  }

  _onMenuItemSelected(int value) {
    print(value);
    // setState(() {
    //   _popupMenuItemIndex = value;
    // });

    // if (value == Options.search.index) {
    //   _changeColorAccordingToMenuItem = Colors.red;
    // } else if (value == Options.upload.index) {
    //   _changeColorAccordingToMenuItem = Colors.green;
    // } else if (value == Options.copy.index) {
    //   _changeColorAccordingToMenuItem = Colors.blue;
    // } else {
    //   _changeColorAccordingToMenuItem = Colors.purple;
    // }
  }
}
