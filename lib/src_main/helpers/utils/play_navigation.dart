// var songPlayList=[];
// for(int i=0;i<songList.totalrecords;i++){

//   songPlayList.add(songList.records[i].id);
// }
// print(index);
// Navigator.of(context).push(MaterialPageRoute(
//     builder: (context) => PlayScreen(
//       songList: songList,
//       index: index,
//       id:songList.records[index].id.toString(),
//           imageURL:  "${APIConstants.SONG_BASE_URL}public/music/tamil/${songList.records[index].albumDetails.name[0].toUpperCase()}/${songList.records[index].albumDetails.name}/image/${songList.records[index].albumDetails.albumId}.png",
//           songName: songList.records[index].name,
//           artistName: songList.records[index].albumDetails.musicDirectorName[0].toString(),
//           songplayList: songPlayList,
//         )));
import 'package:flutter/material.dart';
import 'package:musiq/src/model/api_model/recent_song_model.dart';

// import '../../view/pages/play/play_screen.dart';

recentlyPlayedToPlayScreen(
    RecentlyPlayed songList, BuildContext context, int index) {
  var songPlayList = [];
  print(songList.records.length);
  for (int i = 0; i < songList.records.length; i++) {
    print(songList.records[i][0].id);
  }
  // Navigator.of(context).push(MaterialPageRoute(

  //   builder: (context) => PlayScreen(
  //     songList: songList,
  //     index: index,
  //     id:songList.records[index].id.toString(),
  //         imageURL:  "${APIConstants.SONG_BASE_URL}public/music/tamil/${songList.records[index].albumDetails.name[0].toUpperCase()}/${songList.records[index].albumDetails.name}/image/${songList.records[index].albumDetails.albumId}.png",
  //         songName: songList.records[index].name,
  //         artistName: songList.records[index].albumDetails.musicDirectorName[0].toString(),
  //         songplayList: songPlayList,
  //       )));
}
