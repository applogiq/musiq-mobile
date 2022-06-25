import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:musiq/src/helpers/constants/color.dart';
import 'package:musiq/src/helpers/constants/images.dart';
import 'package:musiq/src/helpers/constants/style.dart';
import 'package:musiq/src/logic/controller/view_all_controller.dart';
import 'package:musiq/src/model/api_model/recent_song_model.dart';
import 'package:musiq/src/model/api_model/song_list_model.dart';
import 'package:musiq/src/view/pages/home/components/widget/loader.dart';
import 'package:musiq/src/view/pages/home/components/widget/vertical_list_view.dart';
import 'package:musiq/src/view/widgets/custom_app_bar.dart';
import 'package:musiq/src/view/widgets/custom_button.dart';

import '../../../../../helpers/constants/api.dart';
import '../../../../widgets/custom_color_container.dart';
import '../../../play/play_screen.dart';
import '../widget/play_button_widget.dart';

class RecentlyPlayedViewAll extends StatelessWidget {
  RecentlyPlayedViewAll(
      {Key? key,
      required this.title,
      required this.songList,
      this.imageURL = "assets/images/default/no_artist.png",
      this.isNetworkImage = true})
      : super(key: key);
  final String title;
  String imageURL;
  RecentlyPlayed songList;
  bool isNetworkImage;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    var size = MediaQuery.of(context).size;

    final ViewAllController viewAllController = Get.put(ViewAllController());
    viewAllController.recentlyPlayedViewAll();
    return SafeArea(
      child: Obx(() {
        return viewAllController.isLoaded.value
            ? Scaffold(
              appBar: PreferredSize(preferredSize: Size(size.width,viewAllController.scrollPosition.value==0.0? size.height/2.5:80),
              child:viewAllController.scrollPosition.value==0.0? 
               PrimaryAppBar(isNetworkImage: isNetworkImage, imageURL:
                                "${APIConstants.SONG_BASE_URL}public/music/tamil/${viewAllController.recentlyPlayed.records[0].name[0].toUpperCase()}/${viewAllController.recentlyPlayed.records[0].name}/image/${viewAllController.recentlyPlayed.records[0].albumId.toString()}.png",

                title: title,height: size.height/2.5,)
              :SecondaryAppBar(title: title)
        ),
                body: ListView(
                      controller: viewAllController.scrollController,
                      shrinkWrap: true,
                        //  physics: ClampingScrollPhysics(),

                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
        children: List.generate(
      viewAllController.recentlyPlayed.records.length,
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
                    child: Image.network(
                          "${APIConstants.SONG_BASE_URL}public/music/tamil/${viewAllController.recentlyPlayed.records[index].name[0].toUpperCase()}/${viewAllController.recentlyPlayed.records[index].name}/image/${viewAllController.recentlyPlayed.records[index].albumId.toString()}.png",
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
                            viewAllController.recentlyPlayed.records[index].songs!.name.toString(),
                            style: fontWeight400(),
                          ),
                          Text(
                           viewAllController.recentlyPlayed.records[index].name,
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
                    
                    )

              
            : LoaderScreen();
      }),);
  }
}

class PrimaryAppBar extends StatelessWidget {
  const PrimaryAppBar({
    Key? key,
    required this.isNetworkImage,
    required this.imageURL,
    required this.title, required this.height,
  }) : super(key: key);

  final bool isNetworkImage;
  final String imageURL;
  final String title;
  final double height; 

  @override
  Widget build(BuildContext context) {
    return Column(
       children: [
         Expanded(
           child: Stack(
             children: [
               Container(
                height: height,
                 decoration: BoxDecoration(
                     image:isNetworkImage==false?
                      DecorationImage(
                   image: AssetImage(imageURL),
                   // fit: BoxFit.cover,
                   colorFilter: ColorFilter.mode(
                       Colors.black.withOpacity(0.8), BlendMode.dstIn),
                 )
                     :

                      DecorationImage(
                   image: NetworkImage(   
                    imageURL,
                   
),
                   fit: BoxFit.fill,
                   colorFilter: ColorFilter.mode(
                       Colors.black.withOpacity(0.8), BlendMode.dstIn),
                 )),
               ),
               GradientCover(),
               AppBarOverlayContent(title: title)
             ],
           ),
         ),
       ],
     );
  }
}

class AppBarOverlayContent extends StatelessWidget {
  const AppBarOverlayContent({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding:
            const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Icon(
                Icons.arrow_back_ios,
                size: 20,
              ),
            ),
            Spacer(),
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: fontWeight600(size: 22.0),
                ),
                Icon(Icons.more_vert),
              ],
            ),
            Text(
              // "${viewAllController.recentlyPlayed.records.length} Songs",
             "",
              style: fontWeight400(
                color: CustomColor.subTitle2,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 24),
              child: InkWell(
                onTap: (){
            //                             var songPlayList=[];
            // for(int i=0;i<songList.totalrecords;i++){

            //   songPlayList.add(songList.records[i].id);
            // }
            // // print(index);
            // Navigator.of(context).push(MaterialPageRoute(
            //     builder: (context) => PlayScreen(
            //       songList: songList,
            //       index: 0,
            //       id:songList.records[0].id.toString(),
            //           imageURL:  "${APIConstants.SONG_BASE_URL}public/music/tamil/${songList.records[0].albumDetails.name[0].toUpperCase()}/${songList.records[0].albumDetails.name}/image/${songList.records[0].albumDetails.albumId}.png",
            //           songName: songList.records[0].name,
            //           artistName: songList.records[0].albumDetails.musicDirectorName[0].toString(),
            //           songplayList: songPlayList,
            //         )));
                },
                child: CustomButton(
                  isIcon: true,
                  label: "Play All",
                  margin: 0,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class GradientCover extends StatelessWidget {
  const GradientCover({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            tileMode: TileMode.decal,
            begin: Alignment.topCenter,
            end: Alignment(0.0, 1),
            stops: [
              0.3,
              0.75,
            ],
            colors: [
              Color.fromRGBO(22, 21, 28, 0),
              Color.fromRGBO(22, 21, 28, 1),
            ]),
      ),
    );
  }
}

class SecondaryAppBar extends StatelessWidget {
  const SecondaryAppBar({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return CustomAppBarWidget(title: title,actions: [ Padding(
      padding: const EdgeInsets.symmetric(horizontal:8.0),
      child: PlayButtonWidget(bgColor: CustomColor.secondaryColor,iconColor: Colors.white,),
    ),
     Padding(
       padding: const EdgeInsets.only(right:8.0),
       child: Icon(Icons.more_vert),
     ),],
     height: 70.0,
     );
  }
}