import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:musiq/src/model/ui_model/view_all_song_list_model.dart';
import 'package:musiq/src/view/widgets/empty_box.dart';

import '../../../../../../helpers/constants/style.dart';
import '../../../../../sandbox/app_bar_main.dart';
import '../../../../../widgets/custom_button.dart';
import '../../../../../widgets/custom_color_container.dart';
import '../../widget/vertical_list_view.dart';

class ViewAllScreenSongList extends StatelessWidget {
   ViewAllScreenSongList({Key? key, required this.banner, required this.view_all_song_list_model}) : super(key: key);
  final ViewAllBanner banner;
  final List<ViewAllSongList> view_all_song_list_model;
 ScrollController controller = ScrollController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      body: CustomScrollView(
         physics: ClampingScrollPhysics(),
          controller: controller,
          slivers: [
            
            SliverAppBar(
              leading: EmptyBox(),
              expandedHeight: 280.0,
              floating: true,
              pinned: true,
              elevation: 50,
              backgroundColor: Color.fromRGBO(33, 33, 44, 1),
            
              flexibleSpace: MyAppSpace(imageURL:banner.bannerImageUrl,name: banner.bannerTitle,count: 5, ),
            ),
                  SliverList(
              delegate: SliverChildListDelegate(
                List.generate(
                  view_all_song_list_model.length,
                  (index) => Column(
                    children: [

                      Container(
                        padding:index==0? EdgeInsets.only(top:20):EdgeInsets.symmetric(vertical:16),
                        width: MediaQuery.of(context).size.width,
                        child: SongListTile(view_all_song_list_model: view_all_song_list_model,index: index,),
                      ),
                    ],
                  ),
                ),
              ),
            )
      
          ],)
      

      // body: CustomScrollView(
      //   slivers: [
      //     SliverAppBar(
      //   expandedHeight: 250.0,
      //   flexibleSpace: FlexibleSpaceBar(
      //     title: Text(banner.bannerTitle, textScaleFactor: 1),
      //     background: Image.network(
      //       banner.bannerImageUrl,
      //       fit: BoxFit.fill,
      //     ),
      //   ),
      // ),
//       body:Column(children: [



//  Expanded(
//                 flex: 7,
//                 child: Column(
//                   children: [
//                     Expanded(
//                       child: Stack(
//                         children: [
//                           Container(
//                             decoration: BoxDecoration(
//                                 image:
                                
                                
//                                  DecorationImage(
//                               image: NetworkImage(banner.bannerImageUrl),
//                               fit: BoxFit.cover,
//                               colorFilter: ColorFilter.mode(
//                                   Colors.black.withOpacity(0.8), BlendMode.dstIn),
//                             ),
//                             ),
//                           ),
//                           Container(
//                             decoration: BoxDecoration(
//                               gradient: LinearGradient(
//                                   tileMode: TileMode.decal,
//                                   begin: Alignment.topCenter,
//                                   end: Alignment(0.0, 1),
//                                   stops: [
//                                     0.3,
//                                     0.75,
//                                   ],
//                                   colors: [
//                                     Color.fromRGBO(22, 21, 28, 0),
//                                     Color.fromRGBO(22, 21, 28, 1),
//                                   ]),
//                             ),
//                           ),
//                           SafeArea(
//                             child: Padding(
//                               padding:
//                                   const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
//                               child: Column(
//                                 // mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   InkWell(
//                                     onTap: () {
//                                       Navigator.of(context).pop();
//                                     },
//                                     child: Icon(
//                                       Icons.arrow_back_ios,
//                                       size: 20,
//                                     ),
//                                   ),
//                                   Spacer(),
//                                   Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       Text(
//                                        banner.bannerTitle,
//                                         style: fontWeight600(size: 22.0),
//                                       ),
//                                       Icon(Icons.more_vert),
//                                     ],
//                                   ),
//                                   // Text(
//                                   //   "${widget.songList.records.length} Songs",
//                                   //   style: fontWeight400(
//                                   //     color: CustomColor.subTitle2,
//                                   //   ),
//                                   // ),
//                                   Padding(
//                                     padding: const EdgeInsets.only(top: 24),
//                                     child: InkWell(
//                                       onTap: (){
//             //                             var songPlayList=[];
//             // for(int i=0;i<widget.songList.totalrecords;i++){
             
//             //   songPlayList.add(widget.songList.records[i].id);
//             // }
//             // print(songPlayList);
//             // print(index);
//             // Navigator.of(context).push(MaterialPageRoute(
//             //     builder: (context) => PlayScreen(
//             //       songList: widget.songList,
//             //       index: 0,
//             //       id:widget.songList.records[0].id.toString(),
//             //           imageURL:  "${APIConstants.SONG_BASE_URL}public/music/tamil/${widget.songList.records[0].albumName[0].toUpperCase()}/${widget.songList.records[0].albumName}/image/${widget.songList.records[0].albumId}.png",
//             //           songName: widget.songList.records[0].songName,
//             //           artistName: widget.songList.records[0].musicDirectorName[0].toString(),
//             //           songplayList: songPlayList,
//             //         )));
//                                       },
//                                       child: CustomButton(
//                                         isIcon: true,
//                                         label: "Play All",
//                                         margin: 0,
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           )
//                         ],
//                       ),
//                     ),
                 
                 
//                   ],
//                 ),
//               ),
//                           Expanded(
//                 flex: 8,
//                 child: Container(
//                   child: NotificationListener<ScrollEndNotification>(
//                     onNotification: (scrollNotification) {
//   //                     print(_scrollController.position.userScrollDirection.toString());
//   //  if (_scrollController.position.userScrollDirection ==
//   //             ScrollDirection.reverse) {
//   //           print('scrolled down');
//   //           setState(() {
//   //             _scrollPosition=1;
//   //           });
//   //           //the setState function
//   //         } else if (_scrollController.position.userScrollDirection ==
//   //             ScrollDirection.forward) {
//   //           setState(() {
//   //             _scrollPosition=0;
//   //           });
//   //           //setState function
//   //           print(_scrollController.position.userScrollDirection);
//           // }
//           return true;},
//                     child: ListView(
//                       // controller: _scrollController,
//                       shrinkWrap: true,
//                          physics: ClampingScrollPhysics(),
 
//                       children: [
//                        Column(
//         children: List.generate(
//       view_all_song_list_model.length,
//       (index) => Container(
//         alignment: Alignment.centerLeft,
//         padding: EdgeInsets.all(8),
//         child: InkWell(
//           onTap: () { 
//             // var songPlayList=[];
//             // for(int i=0;i<songList.totalrecords;i++){
             
//             //   songPlayList.add(songList.records[i].id);
//             // }
//             // print(index);
//             // Navigator.of(context).push(MaterialPageRoute(
//             //     builder: (context) => PlayScreen(
//             //       songList: songList,
//             //       index: index,
//             //       id:songList.records[index].id.toString(),
//             //           imageURL:  "${APIConstants.SONG_BASE_URL}public/music/tamil/${songList.records[index].albumName[0].toUpperCase()}/${songList.records[index].albumName}/image/${songList.records[index].albumId}.png",
//             //           songName: songList.records[index].songName,
//             //           artistName: songList.records[index].musicDirectorName[0].toString(),
//             //           songplayList: songPlayList,
//             //         )));
      
//           },
//           child: SongListTile(view_all_song_list_model: view_all_song_list_model,index: index,),
//         ),
//       ),
//     ))
 
                      
//                       ],
//                     ),
//                   ),
//                 ),
//               )
  
      
//       ],),
            
        // ],
      // ),
    ));
  }
}

class SongListTile extends StatelessWidget {
  const SongListTile({
    Key? key,
    required this.view_all_song_list_model, required this.index,
  }) : super(key: key);
 final int index;
  final List<ViewAllSongList> view_all_song_list_model;

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
                   view_all_song_list_model[index].songName,
                    style: fontWeight400(),
                  ),
                  Text(
                    view_all_song_list_model[index].songMusicDirector,
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
    );
  }
}