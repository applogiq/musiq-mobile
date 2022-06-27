import 'package:flutter/material.dart';
import 'package:musiq/src/helpers/constants/color.dart';
import 'package:musiq/src/helpers/constants/style.dart';
import 'package:musiq/src/model/api_model/song_list_model.dart';
import 'package:musiq/src/view/pages/play/play_screen.dart';
import 'package:musiq/src/view/widgets/custom_color_container.dart';

import '../../../../../helpers/constants/api.dart';

class CustomSongVerticalList extends StatelessWidget {
  CustomSongVerticalList(
      {Key? key, required this.songList, this.playButton = true})
      : super(key: key);

  SongList songList;
  bool playButton;
  

  @override
  Widget build(BuildContext context) {
    return Column(
        children: List.generate(
      songList.records.length,
      (index) => Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.all(8),
        child: InkWell(
          onTap: () { 
            var songPlayList=[];
            for(int i=0;i<songList.totalrecords;i++){
             
              songPlayList.add(songList.records[i].id);
            }
            print(index);
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => PlayScreen(
                  songList: songList,
                  index: index,
                  id:songList.records[index].id.toString(),
                      imageURL:  "${APIConstants.SONG_BASE_URL}public/music/tamil/${songList.records[index].albumName[0].toUpperCase()}/${songList.records[index].albumName}/image/${songList.records[index].albumId}.png",
                      songName: songList.records[index].songName,
                      artistName: songList.records[index].musicDirectorName[0].toString(),
                      songplayList: songPlayList,
                    )));
          },
          child: Row(
            children: [
       
              Expanded(
                flex: 3,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: CustomColorContainer(
                    child: Image.network(
                      "${APIConstants.SONG_BASE_URL}public/music/tamil/${songList.records[index].albumName[0].toUpperCase()}/${songList.records[index].albumName}/image/${songList.records[index].albumId}.png",
                        // "https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/450px-No_image_available.svg.png",
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
                          songList.records[index].albumName,
                          style: fontWeight400(),
                        ),
                        Text(
                          songList.records[index].songName,
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
