import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:musiq/src/model/ui_model/play_screen_model.dart';
import 'package:musiq/src/view/pages/play/play_screen.dart';

import '../../../helpers/constants/api.dart';
import '../../../helpers/constants/color.dart';
import '../../../helpers/constants/style.dart';
import '../../../logic/controller/song_controller.dart';
import '../../widgets/empty_box.dart';

class MainPlayScreen extends StatelessWidget {
   MainPlayScreen({Key? key, required this.playScreenModel, required this.index,}) : super(key: key);
  final List<PlayScreenModel> playScreenModel;
  final int index;
  bool hideLyrics = false;

 PopupMenuItem _buildPopupMenuItem(String title, String routeName) {
    return PopupMenuItem(
      onTap: () {
        if (routeName == "hide") {
          hideLyrics = !hideLyrics;
          // setState(() {
          //   hideLyrics;
          // });
        } else {
          print(routeName);
        }
      },
      child: Text(title),
    );
  }

  @override
  Widget build(BuildContext context) {
     final SongController songController = Get.put(SongController());
    songController.loadSong(playScreenModel, index);
      return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Obx(() {
            return Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height-20,
                  child: Column(
                    children: [
                      Expanded(
                        flex: 6,
                        child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(
                                    // playScreenModel[index].
                                      // "https://mir-s3-cdn-cf.behance.net/project_modules/fs/fe529a64193929.5aca8500ba9ab.jpg",
                                      "${APIConstants.SONG_BASE_URL}public/music/tamil/${ playScreenModel[index].albumName[0].toUpperCase()}/${ playScreenModel[index].albumName}/image/${ playScreenModel[index].albumId}.png"
                                      ),
                                  fit: BoxFit.cover)),
                          child: Stack(children: [
                            Container(
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      stops: [
                                    0.6,
                                    0.99
                                  ],
                                      colors: [
                                    Color.fromRGBO(22, 21, 28, 0),
                                    Color.fromRGBO(22, 21, 28, 1),
                                  ])),
                            ),
                            Container(
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              //     stops: [
                                              //   0.4,
                                              //   0.01,
                                              // ],
                                              colors: [
                                            Color.fromRGBO(22, 21, 28, 0.3),
                                            Color.fromRGBO(22, 21, 28, 0),
                                          ])),
                                    ),
                                  ),
                                  Expanded(
                                      child: Padding(
                                    padding: const EdgeInsets.only(bottom: 0.0),
                                    child: Align(
                                      alignment: Alignment.bottomCenter,
                                      child: hideLyrics == true
                                          ? SizedBox(
                                              height: 0,
                                              width: 0,
                                            )
                                          : Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Text(
                                                  "Waste time with a masterpiece,",
                                                  style:
                                                      fontWeight500(size: 16.0),
                                                ),
                                                Text(
                                                  "don't waste time with a masterpiece (huh)",
                                                  style: fontWeight500(
                                                      size: 16.0,
                                                      color:
                                                          CustomColor.subTitle),
                                                ),
                                                Text(
                                                    "You should be rollin' with me,",
                                                    style: fontWeight500(
                                                        size: 16.0,
                                                        color: CustomColor
                                                            .subTitle)),
                                              ],
                                            ),
                                    ),
                                  ))
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 30),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
                                      onTap: () {
                                        songController.player.stop();
                                        Navigator.of(context).pop();
                                      },
                                      child: Icon(
                                          Icons.arrow_back_ios_new_rounded)),
                                  PopupMenuButton(
                                    shape: RoundedRectangleBorder(),
                                    padding: EdgeInsets.all(0.0),
                                    itemBuilder: (ctx) => [
                                      _buildPopupMenuItem('Share', 'share'),
                                      _buildPopupMenuItem(
                                          'Song Info', "song_info"),
                                      _buildPopupMenuItem(
                                          hideLyrics
                                              ? 'Show Lyrics'
                                              : 'Hide Lyrics',
                                          "hide"),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ]),
                        ),
                      ),
                      Expanded(
                        flex: 6,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 18,
                            ),
                            Text(
         playScreenModel[index].songName,
          style: fontWeight500(size: 16.0)),
                            Text(playScreenModel[index].musicDirectorName,
                                // widget
                                //     .songList
                                //     .records[songController.selectedIndex.value]
                                    
                                //     .musicDirectorName[0]
                                //     .toString(),
                                style: fontWeight400(
                                    size: 14.0, color: CustomColor.subTitle),
                              ),
                            
                            ShuffleButton(songController: songController),
                            ProgressBarWidget(songController: songController),
                            PlayerController(songController: songController)
                          ],
                        ),
                      ),
                      Container(
                        // padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                           color: Color.fromRGBO(33, 33, 44, 1),
                    borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30))),
                        child: ListTile(
                          onTap: () {
                            songController.isBottomSheetView.toggle();
                            // isOpen?bottomSheetHeight=MediaQuery.of(context).size.height:bottomSheetHeight=80.0,
                          },
                          title: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              UpNext(),
                               Text(
                                   playScreenModel[index].albumName,
                                    style: fontWeight400(size: 14.0),
                                  ),
                            ],
                          ),
                          trailing: Icon(Icons.keyboard_arrow_up),
                        ),
                      )
                   
                    ],
                  ),
                ),
              
                songController.isBottomSheetView.value == true
                    ? Container(
                        height: MediaQuery.of(context).size.height - 80,
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(33, 33, 44, 1),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                        ),
                        child: Column(
                          children: [
                            ListTile(
                              title: UpNext(),
                              trailing: InkWell(
                                  onTap: () {
                                    songController.isBottomSheetView.toggle();
                                  },
                                  child:
                                      Icon(Icons.keyboard_arrow_down_rounded)),
                            ),
                            ListView.builder(itemCount: 2,shrinkWrap: true,itemBuilder: (context,index){
                              return Row(
      children: [
       
        // Align(
        //   alignment: Alignment.centerLeft,
        //   child: CustomColorContainer(
        //     child: Image.network(
        //       view_all_song_list_model[index].songImageUrl,
        //       height: 70,
        //       width: 70,
        //       fit: BoxFit.fill,
        //     ),
        //   ),
        // ),
        Expanded(
            flex: 9,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                   "view_all_song_list_model[index].songName",
                    style: fontWeight400(),
                  ),
                  Text(
                    "view_all_song_list_model[index].songMusicDirector",
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
                            })
                          ],
                        ),
                      )
                    : EmptyBox()
              ],
            );
          }),
        ),
      ),
    );

  }
}
class SongName extends StatelessWidget {
   SongName({
    Key? key,
    required this.widget,
    required this.songController,
  }) : super(key: key);

  var widget;
  final SongController songController;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Text(
          widget.songList.records[songController.selectedIndex.value].songName,
          style: fontWeight500(size: 16.0)),
    );
  }
}