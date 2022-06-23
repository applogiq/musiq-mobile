import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musiq/src/helpers/constants/color.dart';
import 'package:musiq/src/helpers/constants/images.dart';
import 'package:musiq/src/helpers/constants/style.dart';
import 'package:musiq/src/logic/controller/song_controller.dart';
import 'package:musiq/src/logic/progress/audio_progress.dart';
import 'package:musiq/src/model/api_model/song_list_model.dart';
import 'package:musiq/src/view/pages/home/components/widget/play_button_widget.dart';
import 'package:musiq/src/view/pages/home/components/widget/reordable_vertical_list.dart';
import 'package:musiq/src/view/pages/home/components/widget/vertical_list_view.dart';

import '../../../helpers/constants/api.dart';

class PlayScreen extends StatefulWidget {
  PlayScreen(
      {Key? key,
      required this.imageURL,
      required this.songName,
      required this.id,
      required this.artistName,
      required this.index,
      required this.songplayList,
      required this.songList})
      : super(key: key);
  final int index;
  final String imageURL;
  final String songName;
  final String id;
  final String artistName;
  List songplayList;
  SongList songList;

  @override
  State<PlayScreen> createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {
  late AudioPlayer player;
  double bottomSheetHeight = 20;
  bool isOpen = false;
  bool hideLyrics = false;
  int duration = 0;
  int progressDuration = 0;
  int bufferDuration = 0;
  bool isShuffle = false;
  bool isLoop = false;
  int loopState = 1;
  late int selectedIndex;

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

  loadSong() async {
    selectedIndex = widget.index;
    var dur;
    await player.setAudioSource(
      ConcatenatingAudioSource(
        useLazyPreparation: true, // default

        shuffleOrder: DefaultShuffleOrder(),

        children: List.generate(
            widget.songplayList.length,
            (index) => AudioSource.uri(Uri.parse(
                "http://192.168.29.184:3000/api/v1/audio?song_id=${widget.songplayList[index]}"))),
      ),
      initialIndex: widget.index,
      initialPosition: Duration.zero,
    );
    // try{

    //          dur=await player.setUrl('http://192.168.29.184:3000/api/v1/audio?song_id=${widget.id}');
    //           duration=dur!.inMilliseconds;
    //           setState(() {
    //             duration;
    //           });
    //           print(duration);
    // }
    // catch(e){duration=0;}
    //            print(dur);

    // print(dur);
    // var parts = dur.toString().split(':');
    // List <double> lint = parts.map(double.parse).toList();
    // lint[0]=lint[0]*60*60;
    // lint[1]=lint[1]*60;
    // lint[2]=lint[2];
    // print(lint);
    // var sum = lint.reduce((a, b) => a + b);
    // print(sum.round());
    // duration=sum.round()*1000;
    // setState(() {
    //   duration;
    // });
    // // print(duration);
    if (this.mounted) {
      setState(() {
        selectedIndex;
        duration;
      });
    }
    //  player.setLoopMode(LoopMode.one);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    player.dispose();
    super.dispose();
  }

  changeState() {
    if (isOpen == false) {
      isOpen = true;
      bottomSheetHeight = MediaQuery.of(context).size.height - 60;
    } else {
      isOpen = false;
      bottomSheetHeight = 80;
    }
    // bottomSheetHeight=isOpen?MediaQuery.of(context).size.height:80;
    // isOpen!=isOpen;
    setState(() {
      bottomSheetHeight;
      print(bottomSheetHeight);
    });
  }

  PopupMenuItem _buildPopupMenuItem(String title, String routeName) {
    return PopupMenuItem(
      onTap: () {
        if (routeName == "hide") {
          hideLyrics = !hideLyrics;
          setState(() {
            hideLyrics;
          });
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
                            image: NetworkImage(
                                "http://192.168.29.184:3000/public/music/tamil/S/Sangamam/image/AL004.png"),
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
                              padding: const EdgeInsets.only(bottom: 16.0),
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
                                            style: fontWeight500(size: 16.0),
                                          ),
                                          Text(
                                            "don't waste time with a masterpiece (huh)",
                                            style: fontWeight500(
                                                size: 16.0,
                                                color: CustomColor.subTitle),
                                          ),
                                          Text("You should be rollin' with me,",
                                              style: fontWeight500(
                                                  size: 16.0,
                                                  color: CustomColor.subTitle)),
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: Icon(Icons.arrow_back_ios_new_rounded)),
                            PopupMenuButton(
                              shape: RoundedRectangleBorder(),
                              padding: EdgeInsets.all(0.0),
                              itemBuilder: (ctx) => [
                                _buildPopupMenuItem('Share', 'share'),
                                _buildPopupMenuItem('Song Info', "song_info"),
                                _buildPopupMenuItem(
                                    hideLyrics ? 'Show Lyrics' : 'Hide Lyrics',
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
                  flex: 5,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 40,
                      ),
                      // Text(widget.songList.records[widget.songplayList[selectedIndex]].name,style: fontWeight500(size: 20.0),),
                      //  Text(widget.songList.records[widget.songplayList[selectedIndex]].albumDetails.musicDirectorName[0].toString(),style: fontWeight400(size: 16.0,color: CustomColor.subTitle),
                      // ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                                onTap: () async {
                                  songController.isShuffle.toggle();
                                  // if (isShuffle == false) {
                                  //   await player.setShuffleModeEnabled(true);
                                  // } else {
                                  //   await player.setShuffleModeEnabled(false);
                                  // }
                                  // setState(() {
                                  //   isShuffle = !isShuffle;
                                  // });
                                },
                                child: Obx(() => Icon(
                                      Icons.shuffle_rounded,
                                      color: songController.isShuffle.value
                                          ? CustomColor.secondaryColor
                                          : Colors.white,
                                    ))),
                            Icon(Icons.favorite_rounded)
                          ],
                        ),
                      ),
                      Obx(() => Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: ProgressBar(
                              progress:
                                  Duration(milliseconds: songController.duration.value),
                              buffered: Duration(milliseconds: bufferDuration),
                              total: Duration(milliseconds: songController.duration.value),
                              progressBarColor: CustomColor.secondaryColor,
                              baseBarColor: Colors.white.withOpacity(0.24),
                              bufferedBarColor: Colors.white.withOpacity(0.24),
                              thumbColor: Colors.white,
                              barHeight: 6.0,
                              thumbRadius: 6.0,
                              onSeek: (duration) {
                                print('User selected a new time: ');
                                player.seek(duration);
                              },
                            ),
                          )),

                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Theme(
                          data: ThemeData(
                              iconTheme:
                                  IconThemeData(size: 32, color: Colors.white)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(Icons.playlist_add_rounded, size: 40),
                              InkWell(
                                  onTap: () {
                                    songController.playNext();
                                  },
                                  child: Icon(
                                    Icons.skip_previous_rounded,
                                    size: 40,
                                  )),
                              Obx(() {
                                return InkWell(
                                  onTap: () {
                                    songController.playOrPause();
                                  },
                                  child: songController.isPlay.value
                                      ? PlayButtonWidget(
                                          bgColor: CustomColor.secondaryColor,
                                          iconColor: Colors.white,
                                          size: 34.0,
                                          padding: 16.0,
                                          icon: Icons.pause_rounded,
                                        )
                                      : PlayButtonWidget(
                                          bgColor: CustomColor.secondaryColor,
                                          iconColor: Colors.white,
                                          size: 34.0,
                                          padding: 16.0,
                                        ),
                                );
                              }),
                              InkWell(
                                  onTap: () async {
                                    songController.playNext();
                                  },
                                  child: Icon(
                                    Icons.skip_next_rounded,
                                    size: 40,
                                  )),
                              Obx(() => InkWell(
                                  onTap: () async {
                                    songController.loopSong();
                                    // if (loopState == 0) {
                                    //   loopState = 1;
                                    //   await player.setLoopMode(LoopMode.all);
                                    //   isLoop = true;
                                    // } else if (loopState == 1) {
                                    //   loopState = 2;
                                    //   await player.setLoopMode(LoopMode.one);
                                    //   isLoop = true;
                                    // } else {
                                    //   loopState = 0;
                                    //   isLoop = false;
                                    //   await player.setLoopMode(LoopMode.off);
                                    // }
                                    // print(loopState);
                                    // print(isLoop);
                                    // setState(() {
                                    //   isLoop;
                                    //   loopState;
                                    // });
                                  },
                                  child: Icon(
                                    songController.loopState.value == 2
                                        ? Icons.repeat_one_rounded
                                        : Icons.repeat_rounded,
                                    size: 40,
                                    color: songController.isRepeated.value
                                        ? CustomColor.secondaryColor
                                        : Colors.white,
                                  ))),
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
                height: bottomSheetHeight,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                    color: Color.fromRGBO(33, 33, 44, 1),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30))),
                child: isOpen == false
                    ? ListTile(
                        onTap: () {
                          changeState();
                          // isOpen?bottomSheetHeight=MediaQuery.of(context).size.height:bottomSheetHeight=80.0,
                        },
                        title: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            UpNext(),
                            Text(
                              "Wolves - Selena Gomez",
                              style: fontWeight400(size: 14.0),
                            ),
                          ],
                        ),
                        trailing: Icon(Icons.keyboard_arrow_up),
                      )
                    : Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              UpNext(),
                              InkWell(
                                  onTap: () {
                                    if (isOpen == false) {
                                      isOpen = true;
                                      bottomSheetHeight =
                                          MediaQuery.of(context).size.height -
                                              60;
                                    } else {
                                      isOpen = false;
                                      bottomSheetHeight = 60;
                                    }
                                    // bottomSheetHeight=isOpen?MediaQuery.of(context).size.height:80;
                                    // isOpen!=isOpen;
                                    setState(() {
                                      bottomSheetHeight;
                                      print(bottomSheetHeight);
                                    });
                                  },
                                  child:
                                      Icon(Icons.keyboard_arrow_down_rounded))
                            ],
                          ),
                          Expanded(
                            child: ListView(
                              shrinkWrap: true,
                              children: [
                                CustomReorderableVerticalList(
                                  images: Images().favList,
                                  isFromUpNext: true,
                                  highlightindex: widget.index,
                                ),
                              ],
                            ),
                          ),
                        ],
                      )),
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
    return Text(
      "Up next",
      style: fontWeight500(size: 16.0),
    );
  }
}
