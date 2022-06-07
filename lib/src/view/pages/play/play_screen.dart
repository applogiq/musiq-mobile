import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musiq/src/helpers/constants/color.dart';
import 'package:musiq/src/helpers/constants/images.dart';
import 'package:musiq/src/helpers/constants/style.dart';
import 'package:musiq/src/view/pages/home/components/widget/play_button_widget.dart';
import 'package:musiq/src/view/pages/home/components/widget/reordable_vertical_list.dart';
import 'package:musiq/src/view/pages/home/components/widget/vertical_list_view.dart';

class PlayScreen extends StatefulWidget {
   PlayScreen(
      {Key? key,
      required this.imageURL,
      required this.songName,
      required this.artistName, required this.index})
      : super(key: key);
      final int index;
  final String imageURL;
  final String songName;
  final String artistName;

  @override
  State<PlayScreen> createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {
  late AudioPlayer player;
  double bottomSheetHeight=80;
  bool isOpen=false;
  bool hideLyrics=false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
      SystemUiOverlay.bottom,
    ]);
     player = AudioPlayer();
     loadSong();
    
  }
  loadSong()async{
              await player.setAsset('assets/song/1.wav');

  }
@override
  void dispose() {
    // TODO: implement dispose
     player.dispose();
    super.dispose();
  }
  changeState(){
     if(isOpen==false){
    isOpen=true;
    bottomSheetHeight=MediaQuery.of(context).size.height-60;
  }
  else{
      isOpen=false;
    bottomSheetHeight=80;
 
  }
  // bottomSheetHeight=isOpen?MediaQuery.of(context).size.height:80;
  // isOpen!=isOpen;
  setState(() {
    bottomSheetHeight;
    print(bottomSheetHeight);
  });
  }
  PopupMenuItem _buildPopupMenuItem(
      String title,String routeName) {
    return PopupMenuItem(
      onTap: (){
        if(routeName=="hide"){
          hideLyrics=!hideLyrics;
          setState(() {
            hideLyrics;
          });
        }
        else{

        print(routeName);
        }
      },
      child:  Text(title),
    );
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Column(
              children: [
                Expanded(
                  flex: 5,
                  child: Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(widget.imageURL),
                      
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
                            Expanded(child:     Container(
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
                      ),)
                            ,
                            Expanded(child:       Padding(
                              padding: const EdgeInsets.only(bottom:16.0),
                              child: Align(alignment: Alignment.bottomCenter,child:hideLyrics==true?SizedBox(height: 0,width: 0,): Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                        Text("Waste time with a masterpiece,",style: fontWeight500(size: 16.0),
     
    ),
    Text("don't waste time with a masterpiece (huh)",style: fontWeight500(size: 16.0,color: CustomColor.subTitle),),
    Text("You should be rollin' with me,",style: fontWeight500(size: 16.0,color: CustomColor.subTitle)),
                      ],),),
                            ))
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal:16.0,vertical: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(onTap: (){
                              Navigator.of(context).pop();
                            },child: Icon(Icons.arrow_back_ios_new_rounded)),
                             PopupMenuButton(
                               shape: RoundedRectangleBorder(),
                               padding: EdgeInsets.all(0.0),
          itemBuilder: (ctx) => [
            _buildPopupMenuItem('Share','share'),
            _buildPopupMenuItem('Song Info',"song_info"),
            _buildPopupMenuItem(hideLyrics?'Show Lyrics':'Hide Lyrics',"hide"),
          
          ],
        )
                          ],
                        ),
                      ),
                
                    ]),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [SizedBox(height: 40,),
                    Text(widget.songName,style: fontWeight500(size: 20.0),),
                     Text(widget.artistName,style: fontWeight400(size: 16.0,color: CustomColor.subTitle),
                    ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.shuffle),
                    Icon(Icons.favorite_rounded)
    
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ProgressBar( progress: Duration(milliseconds: 115000),
      buffered: Duration(milliseconds: 2000),
      total: Duration(milliseconds: 255000),
      progressBarColor: CustomColor.secondaryColor,
      baseBarColor: Colors.white.withOpacity(0.24),
      bufferedBarColor: Colors.white.withOpacity(0.24),
      thumbColor: Colors.white,
      barHeight: 6.0,
      thumbRadius: 6.0,
      onSeek: (duration) {
      print('User selected a new time: $duration');
       player.seek(duration );
       
      },),
              ),
      //              InkWell(onTap: ()async{
      //                try{
    
      //               await player.setAsset('assets/song/1.wav');
      //                }
      //                catch (e){
      //                  print(e.toString());
      //                }
      //               player.setVolume(5.0);
                      
      // player.play();
      // print(player.duration);
      //               //  player.play(); 
      //              },child: Icon(Icons.play_arrow))
      
    
    
    Padding(
      padding: const EdgeInsets.all(16.0),
      child:   Theme(
      data:ThemeData(iconTheme: IconThemeData(size:32,color: Colors.white)),
      child: Row(
      
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
      
            children: [
      
              Icon(Icons.playlist_add,),
      
              Icon(Icons.skip_previous,),
      
             player.playing==false? InkWell(onTap: ()async{
      //  try{
      //                  }
      //                  catch (e){
      //                    print(e.toString());
      //                  }
      //                 player.setVolume(5.0);
                      
      player.play();
      setState(() {
      player.playing;
      });
             },child: PlayButtonWidget(bgColor: CustomColor.secondaryColor,iconColor: Colors.white,size: 34.0,padding: 16.0,)):
             InkWell(onTap: ()async{
               await player.pause();
                setState(() {
      player.playing;
      });
             },child:  PlayButtonWidget(bgColor: CustomColor.secondaryColor,iconColor: Colors.white,size: 34.0,padding: 16.0,icon: Icons.pause,)),
      
              Icon(Icons.skip_next),
      
              Icon(Icons.repeat,),
      
            ],
      
      ),
      ),
    )
    
      ],
                 
                 
                 
                 
                  ),
                ),
              ],
            ),
            Container(
              height:bottomSheetHeight,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
              color: Color.fromRGBO(33, 33, 44, 1),
      borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30))
              ),
    child:isOpen==false? ListTile(onTap: (){
     changeState();
      // isOpen?bottomSheetHeight=MediaQuery.of(context).size.height:bottomSheetHeight=80.0,
    },title: Column(mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,children: [
      UpNext(),
      Text("Wolves - Selena Gomez",style: fontWeight400(size: 14.0),),
    ],),trailing: Icon(Icons.keyboard_arrow_up),):Column(
      children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [UpNext(),InkWell(onTap: (){ if(isOpen==false){
      isOpen=true;
      bottomSheetHeight=MediaQuery.of(context).size.height-60;
      }
      else{
        isOpen=false;
      bottomSheetHeight=80;
     
      }
      // bottomSheetHeight=isOpen?MediaQuery.of(context).size.height:80;
      // isOpen!=isOpen;
      setState(() {
      bottomSheetHeight;
      print(bottomSheetHeight);
      });},child: Icon(Icons.keyboard_arrow_down_rounded))],),
          Expanded(
            child: ListView(
              shrinkWrap: true,
              children: [
                CustomReorderableVerticalList(images: Images().favList,isFromUpNext: true,highlightindex: widget.index,),
              ],
            ),
          ),
      ],
    )
            ),
          ],
        ),
      ),
    );
  }
}

class UpNext extends StatelessWidget {
  const UpNext({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text("Up next",style: fontWeight500(size: 16.0),);
  }
}
