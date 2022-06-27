import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:musiq/src/helpers/utils/image_url_generate.dart';
import 'package:musiq/src/logic/controller/view_all_controller.dart';
import 'package:musiq/src/model/api_model/song_list_model.dart';

import '../../../../../helpers/constants/images.dart';
import '../../../../../helpers/constants/style.dart';
import '../../../../../model/api_model/artist_model.dart' as art;
import '../../../../widgets/custom_color_container.dart';
import 'recently_played_view_all.dart';

class ArtistSongList extends StatelessWidget {
  const ArtistSongList({Key? key, required this.songList, required this.record})
      : super(key: key);
  final SongList songList;
  final art.Record record;
  @override
  Widget build(BuildContext context) {
    final ViewAllController viewAllController = Get.put(ViewAllController());

    var size = MediaQuery.of(context).size;
    return Obx(() => SafeArea(
          child: Scaffold(
              appBar: PreferredSize(
                  preferredSize: Size(
                      size.width,
                      viewAllController.scrollPosition.value == 0.0
                          ? size.height / 2.5
                          : 80),
                  child: viewAllController.scrollPosition.value == 0.0
                      ? PrimaryAppBar(
                          isNetworkImage: record.isImage,
                          imageURL: record.isImage
                              ? generateArtistImageUrl(record.artistId)
                              : Images.noArtist,
                          title: record.artistName,
                          height: size.height / 2.5,
                        )
                      : SecondaryAppBar(title: record.artistName),),
                
                      body: ListView(
                      controller: viewAllController.scrollController,
                      shrinkWrap: true,
                        //  physics: ClampingScrollPhysics(),

                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
        children: List.generate(
     songList.records.length,
      (index) => Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.all(8),
        child: InkWell(
          onTap: () {
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
          },
          child: Row(
            children: [

              Expanded(
                flex: 3,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: CustomColorContainer(
                    child:Text("") ,
//                      Image.network(
//                           generateSongImageUrl(songList.records[index].albumName, songList.records[index].albumId),
//  height: 70,
//                       width: 70,
//                       fit: BoxFit.fill,
//                     ),
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
                            songList.records[index].songName.toString(),
                            style: fontWeight400(),
                          ),
                          Text(
                           songList.records[index].albumName.toString(),
                            style: fontWeight400(size: 12.0,),
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
      ),
    ),
    ),
                        ),

                      ],
                    ),
                    
                      ),
        ));
  }
}
