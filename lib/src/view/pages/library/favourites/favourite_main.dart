import 'package:flutter/material.dart';
import 'package:musiq/src/helpers/constants/string.dart';
import 'package:musiq/src/view/pages/library/favourites/no_favourite.dart';

import '../../../../logic/controller/library_controller.dart';
import '../../home/components/pages/view_all/view_all_songs_list.dart';

class FavouritesMain extends StatelessWidget {
  const FavouritesMain({
    Key? key,
    required this.libraryController,
  }) : super(key: key);

  final LibraryController libraryController;

  @override
  Widget build(BuildContext context) {
    return libraryController.view_all_songs_list.length==0?
   NoSongScreen(isFav: true,mainTitle: ConstantText.noSongHere,subTitle: ConstantText.yourfavNoAvailable,)
    
    : Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0),
      child:
      
       ListView(
        shrinkWrap: true,
        children: [
         
          Column(
              children: List.generate(
            libraryController.view_all_songs_list.length,
           
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
                      view_all_song_list_model:
                          libraryController
                              .view_all_songs_list,
                      index: index)),
            ),
          )),
        ],
      ),
    );
  }
}

