import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:musiq/src/helpers/constants/color.dart';
import 'package:musiq/src/helpers/constants/images.dart';
import 'package:musiq/src/helpers/utils/image_url_generate.dart';
import 'package:musiq/src/logic/controller/library_controller.dart';
import 'package:musiq/src/view/pages/home/components/pages/view_all/view_all_songs_list.dart';
import 'package:musiq/src/view/pages/home/components/widget/loader.dart';
import 'package:musiq/src/view/pages/home/components/widget/vertical_list_view.dart';

import '../../../helpers/constants/style.dart';
import '../../widgets/custom_color_container.dart';

class Library extends StatelessWidget {
  Library({Key? key}) : super(key: key);
  Images images = Images();

  @override
  Widget build(BuildContext context) {
    LibraryController libraryController=Get.put(LibraryController());
    libraryController.loadFavouriteData();
    return Obx((){
      return libraryController.isLoaded.value==false?LoaderScreen():
      SafeArea(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              "Library",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            bottom: PreferredSize(
              preferredSize: Size(double.maxFinite, 60),
              child: Container(
                margin: EdgeInsets.fromLTRB(16, 24, 16, 0),
                decoration: BoxDecoration(
                    color: CustomColor.textfieldBg,
                    borderRadius: BorderRadius.circular(12)),
                child: TabBar(
                  indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(12), // Creates border
                      color: CustomColor.secondaryColor),
                  tabs: [
                    Tab(
                        icon: Text(
                      "Favourites",
                      style: TextStyle(fontWeight: FontWeight.w400),
                    )),
                    Tab(
                      icon: Text(
                        "Playlists",
                        style: TextStyle(fontWeight: FontWeight.w400),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            backgroundColor: Colors.transparent,
          ),
          body: TabBarView(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    
                    // CustomSongVerticalList(
                    //   images: images.favList,
                    //   playButton: false,
                    // )
                    Column(
        children: List.generate(
      libraryController.view_all_songs_list.length,
      // images.favList.length,
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
          child:SongListTile(view_all_song_list_model: libraryController.view_all_songs_list, index: index)
          
        ),
      ),
    )),
 
                  ],
                ),
              ),
              PlaylistScreen(images: images),
            ],
          ),
        ),
      ),
    );
    });
    
     ;
  }
}

class PlaylistScreen extends StatelessWidget {
  const PlaylistScreen({
    Key? key,
    required this.images,
  }) : super(key: key);

  final Images images;

  @override
  Widget build(BuildContext context) {
    LibraryController libraryController=Get.put(LibraryController());
    libraryController.loadPlayListData();
    return Obx((){
      return libraryController.isLoadedPlayList.value==false?LoaderScreen():

      Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0),
        child: ListView(
          shrinkWrap: true,
          // children: [
          //   // CustomSongVerticalList(
          //   //   images: images.playList,
          //   //   playButton: false,
          //   // )
          // ],
          children: List.generate(libraryController.view_all_play_list.records.length, (index) =>  Row(
            children: [
       
              Expanded(
                flex: 3,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: CustomColorContainer(
                    bgColor: libraryController.view_all_play_list.records[index].noOfSongs==0?CustomColor.defaultCard:Colors.transparent
                    ,child: 
                    libraryController.view_all_play_list.records[index].noOfSongs==0?
                    Center(child: Text(libraryController.view_all_play_list.records[index].playlistName![0]))
                    :
                    Image.network(
                      generateSongImageUrl(libraryController.view_all_play_list.records[index].albumName.toString(), libraryController.view_all_play_list.records[index].albumId.toString())
                      // libraryController.view_all_songs_list[index].songImageUrl,
                      // images.playList[index].imageURL,
                      // "${APIConstants.SONG_BASE_URL}public/music/tamil/${songList.records[index].albumName[0].toUpperCase()}/${songList.records[index].albumName}/image/${songList.records[index].albumId}.png",
                        // "https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/450px-No_image_available.svg.png",
                     , height: 70,
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
                         libraryController.view_all_play_list.records[index].playlistName.toString(),
                          // libraryController.view_all_play_list[index].records.
                          // images.playList[index].title,
                    // libraryController.view_all_play_list[index].records.      libraryController.view_all_play_list[index].songName,
                          style: fontWeight400(),
                        ),
                        Text(
                           images.playList[index].title,
                          style: fontWeight400(size: 12.0,color: CustomColor.subTitle),
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
    );
  
    });}
}
