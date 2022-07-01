import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:musiq/src/helpers/constants/color.dart';
import 'package:musiq/src/helpers/constants/images.dart';
import 'package:musiq/src/helpers/constants/style.dart';
import 'package:musiq/src/model/api_model/song_list_model.dart';
import 'package:musiq/src/view/pages/home/components/widget/play_button_widget.dart';
import 'package:musiq/src/view/pages/home/components/widget/vertical_list_view.dart';
import 'package:musiq/src/view/widgets/custom_button.dart';

import '../../../../../helpers/constants/api.dart';
import '../../../play/play_screen.dart';

class ViewAllScreen extends StatefulWidget {
  ViewAllScreen(
      {Key? key,
      required this.title,
      required this.songList,
      this.imageURL ="assets/images/default/no_artist.png",this.isNetworkImage=true})
      : super(key: key);
  final String title;
  String imageURL;
  SongList songList;
  bool isNetworkImage;

  @override
  State<ViewAllScreen> createState() => _ViewAllScreenState();
}

class _ViewAllScreenState extends State<ViewAllScreen> {
 ScrollController _scrollController = ScrollController();
  double _scrollPosition = 0;

  _scrollListener() {
    setState(() {
      _scrollPosition = _scrollController.position.pixels;
    });
  }

  @override
  void initState() {
    // _scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    
    return SafeArea(
        child: Scaffold(
          body: Column(
            children: [
             _scrollPosition ==0?          Expanded(
                flex: 7,
                child: Column(
                  children: [
                    Expanded(
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                image:widget.isNetworkImage==false?
                                 DecorationImage(
                              image: AssetImage(widget.imageURL),
                              // fit: BoxFit.cover,
                              colorFilter: ColorFilter.mode(
                                  Colors.black.withOpacity(0.8), BlendMode.dstIn),
                            )
                                :
                                
                                
                                 DecorationImage(
                              image: NetworkImage(widget.imageURL),
                              fit: BoxFit.cover,
                              colorFilter: ColorFilter.mode(
                                  Colors.black.withOpacity(0.8), BlendMode.dstIn),
                            )),
                          ),
                          Container(
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
                          ),
                          SafeArea(
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
                                        widget.title,
                                        style: fontWeight600(size: 22.0),
                                      ),
                                      Icon(Icons.more_vert),
                                    ],
                                  ),
                                  Text(
                                    "${widget.songList.records.length} Songs",
                                    style: fontWeight400(
                                      color: CustomColor.subTitle2,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 24),
                                    child: InkWell(
                                      onTap: (){
                                        var songPlayList=[];
            for(int i=0;i<widget.songList.totalrecords;i++){
             
              songPlayList.add(widget.songList.records[i].id);
            }
            print(songPlayList);
            // print(index);
            // Navigator.of(context).push(MaterialPageRoute(
            //     builder: (context) => PlayScreen(
            //       songList: widget.songList,
            //       index: 0,
            //       id:widget.songList.records[0].id.toString(),
            //           imageURL:  "${APIConstants.SONG_BASE_URL}public/music/tamil/${widget.songList.records[0].albumName[0].toUpperCase()}/${widget.songList.records[0].albumName}/image/${widget.songList.records[0].albumId}.png",
            //           songName: widget.songList.records[0].songName,
            //           artistName: widget.songList.records[0].musicDirectorName[0].toString(),
            //           songplayList: songPlayList,
            //         )));
                                      },
                                      child: CustomButton(
                                        isIcon: true,
                                        label: "Play All",
                                        verticalMargin: 0,
                                        horizontalMargin: 0,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ):
             Container(
              color:CustomColor.appBarColor,
               padding: const EdgeInsets.all(8.0),
               child: Row(
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
                Text(
                                          widget.title,
                                          style: fontWeight600(size: 22.0),
                                        ),
               Spacer(),
               PlayButtonWidget(bgColor: CustomColor.secondaryColor,iconColor: Colors.white,),
               Icon(Icons.more_vert),
                ],
               ),
             )
             
             
             
           , 
              Expanded(
                flex: 8,
                child: Container(
                  child: NotificationListener<ScrollEndNotification>(
                    onNotification: (scrollNotification) {
                      print(_scrollController.position.userScrollDirection.toString());
   if (_scrollController.position.userScrollDirection ==
              ScrollDirection.reverse) {
            print('scrolled down');
            setState(() {
              _scrollPosition=1;
            });
            //the setState function
          } else if (_scrollController.position.userScrollDirection ==
              ScrollDirection.forward) {
            setState(() {
              _scrollPosition=0;
            });
            //setState function
            print(_scrollController.position.userScrollDirection);
          }
          return true;},
                    child: ListView(
                      controller: _scrollController,
                      shrinkWrap: true,
                         physics: ClampingScrollPhysics(),
 
                      children: [
                        // CustomSongVerticalList(
                        //   songList: songList,
                        //   playButton: false,
                        // ),
                      
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      
      
    );
  }
}
