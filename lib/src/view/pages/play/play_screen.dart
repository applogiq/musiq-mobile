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
import 'package:musiq/src/view/pages/play/play_screen_new.dart';
import 'package:musiq/src/view/widgets/empty_box.dart';

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
  double bottomSheetHeight = 20;
  bool isOpen = false;
  bool hideLyrics = false;

  late int selectedIndex;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
      SystemUiOverlay.bottom,
    ]);
  }

  @override
  void dispose() {
    // TODO: implement dispose

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
    songController.load(widget.songplayList, widget.index);
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Obx(() {
            return Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height - 10,
                  child: Column(
                    children: [
                      Expanded(
                        flex: 6,
                        child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(
                                      // "https://mir-s3-cdn-cf.behance.net/project_modules/fs/fe529a64193929.5aca8500ba9ab.jpg",
                                      "${APIConstants.SONG_BASE_URL}public/music/tamil/${widget.songList.records[songController.selectedIndex.value].albumName[0].toUpperCase()}/${widget.songList.records[songController.selectedIndex.value].albumName}/image/${widget.songList.records[songController.selectedIndex.value].albumId}.png"),
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
                            SongName(
                                widget: widget, songController: songController),
                            Obx(
                              () => Text(
                                widget
                                    .songList
                                    .records[songController.selectedIndex.value]
                                    .musicDirectorName[0]
                                    .toString(),
                                style: fontWeight400(
                                    size: 14.0, color: CustomColor.subTitle),
                              ),
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
                              Obx(() => Text(
                                    widget
                                        .songList
                                        .records[songController.nextIndex.value]
                                        .songName
                                        .toString(),
                                    style: fontWeight400(size: 14.0),
                                  )),
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
                            )
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

class ShuffleButton extends StatelessWidget {
  const ShuffleButton({
    Key? key,
    required this.songController,
  }) : super(key: key);

  final SongController songController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
              onTap: () async {
                songController.shuffleSong();
              },
              child: Obx(() => Icon(
                    Icons.shuffle_rounded,
                    color: songController.isShuffle.value
                        ? CustomColor.secondaryColor
                        : Colors.white,
                  ))),
          InkWell(onTap: (){ 
            songController.checkFav();
          },child: Obx(() => Icon(Icons.favorite_rounded,color: songController.isFav.value
                        ? CustomColor.secondaryColor
                        : Colors.white,),),)
        ],
      ),
    );
  }
}

class SongName extends StatelessWidget {
  const SongName({
    Key? key,
    required this.widget,
    required this.songController,
  }) : super(key: key);

  final PlayScreen widget;
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

class ProgressBarWidget extends StatelessWidget {
  const ProgressBarWidget({
    Key? key,
    required this.songController,
  }) : super(key: key);

  final SongController songController;

  @override
  Widget build(BuildContext context) {
    return Obx(() => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ProgressBar(
            progress: Duration(
                milliseconds: songController.progressDurationValue.value),
            buffered: Duration(
                milliseconds: songController.bufferDurationValue.value),
            total:
                Duration(milliseconds: songController.totalDurationValue.value),
            progressBarColor: CustomColor.secondaryColor,
            baseBarColor: Colors.white.withOpacity(0.24),
            bufferedBarColor: Colors.white.withOpacity(0.24),
            thumbColor: Colors.white,
            barHeight: 6.0,
            thumbRadius: 6.0,
            onSeek: (duration) {
              songController.seekDuration(duration);
            },
          ),
        ));
  }
}

class PlayPrevious extends StatelessWidget {
  const PlayPrevious({
    Key? key,
    required this.songController,
  }) : super(key: key);

  final SongController songController;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          songController.playPrev();
        },
        child: Icon(
          Icons.skip_previous_rounded,
          size: 34,
        ));
  }
}

class RepeatSong extends StatelessWidget {
  const RepeatSong({
    Key? key,
    required this.songController,
  }) : super(key: key);

  final SongController songController;

  @override
  Widget build(BuildContext context) {
    return Obx(() => InkWell(
        onTap: () async {
          songController.loopSong();
        },
        child: Icon(
          songController.loopState.value == 2
              ? Icons.repeat_one_rounded
              : Icons.repeat_rounded,
          size: 34,
          color: songController.isRepeated.value
              ? CustomColor.secondaryColor
              : Colors.white,
        )));
  }
}

class PlayNext extends StatelessWidget {
  const PlayNext({
    Key? key,
    required this.songController,
  }) : super(key: key);

  final SongController songController;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () async {
          songController.playNext();
        },
        child: Icon(
          Icons.skip_next_rounded,
          size: 34,
        ));
  }
}

class PlayPauseController extends StatelessWidget {
  const PlayPauseController({
    Key? key,
    required this.songController,
  }) : super(key: key);

  final SongController songController;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return InkWell(
        onTap: () {
          songController.playOrPause();
        },
        child: songController.isPlay.value
            ? PlayButtonWidget(
                bgColor: CustomColor.secondaryColor,
                iconColor: Colors.white,
                size: 34.0,
                padding: 14.0,
                icon: Icons.pause_rounded,
              )
            : PlayButtonWidget(
                bgColor: CustomColor.secondaryColor,
                iconColor: Colors.white,
                size: 34.0,
                padding: 14.0,
              ),
      );
    });
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
