import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:musiq/src/helpers/constants/color.dart';
import 'package:musiq/src/helpers/constants/images.dart';
import 'package:musiq/src/helpers/constants/style.dart';
import 'package:musiq/src/model/api_model/song_list_model.dart';
import 'package:musiq/src/view/pages/home/components/widget/vertical_list_view.dart';
import 'package:musiq/src/view/widgets/custom_button.dart';

class ViewAllScreen extends StatelessWidget {
  ViewAllScreen(
      {Key? key,
      required this.title,
      required this.songList,
      this.imageURL = "assets/images/banner.png",})
      : super(key: key);
  final String title;
  String imageURL;
  SongList songList;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    // return Scaffold(
    //   body: CustomScrollView(
    //     slivers: [
    // SliverAppBar(
    //   pinned: true,
    //   floating: true,
    //       expandedHeight: 250.0,
    //       automaticallyImplyLeading: false,
    //       flexibleSpace: FlexibleSpaceBar(
    //         // title: Text(title, textScaleFactor: 1),
    //         background:  Stack(
    //                     children: [
    //                       Container(
    //                         decoration: BoxDecoration(
    //                             image: DecorationImage(
    //                           image: NetworkImage(imageURL),
    //                           fit: BoxFit.cover,
    //                           colorFilter: ColorFilter.mode(
    //                               Colors.black.withOpacity(0.8), BlendMode.dstIn),
    //                         )),
    //                       ),
    //                       Container(
    //                         decoration: BoxDecoration(
    //                           gradient: LinearGradient(
    //                               tileMode: TileMode.decal,
    //                               begin: Alignment.topCenter,
    //                               end: Alignment(0.0, 1),
    //                               stops: [
    //                                 0.3,
    //                                 0.75,
    //                               ],
    //                               colors: [
    //                                 Color.fromRGBO(22, 21, 28, 0),
    //                                 Color.fromRGBO(22, 21, 28, 1),
    //                               ]),
    //                         ),
    //                       ),
    //                       SafeArea(
    //                         child: Padding(
    //                           padding:
    //                               const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
    //                           child: Column(
    //                             // mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                             crossAxisAlignment: CrossAxisAlignment.start,
    //                             children: [
    //                               InkWell(
    //                                 onTap: () {
    //                                   Navigator.of(context).pop();
    //                                 },
    //                                 child: Icon(
    //                                   Icons.arrow_back_ios,
    //                                   size: 20,
    //                                 ),
    //                               ),
    //                               Spacer(),
    //                               Row(
    //                                 mainAxisAlignment:
    //                                     MainAxisAlignment.spaceBetween,
    //                                 children: [
    //                                   Text(
    //                                     title,
    //                                     style: fontWeight600(size: 22.0),
    //                                   ),
    //                                   Icon(Icons.more_vert),
    //                                 ],
    //                               ),
    //                               Text(
    //                                 "25 Songs",
    //                                 style: fontWeight400(
    //                                   color: CustomColor.subTitle2,
    //                                 ),
    //                               ),
    //                               Padding(
    //                                 padding: const EdgeInsets.only(top: 24),
    //                                 child: CustomButton(
    //                                   isIcon: true,
    //                                   label: "Play All",
    //                                   margin: 0,
    //                                 ),
    //                               )
    //                             ],
    //                           ),
    //                         ),
    //                       )
    //                     ],
    //                   ),
    //       ),
    //     ),
    // SliverList(
    //       delegate: SliverChildBuilderDelegate(
    //         (_, int index) {
    //           return ListTile(
    //             leading: Container(
    //                 padding: EdgeInsets.all(8),
    //                 width: 100,
    //                 child: Placeholder()),
    //             title: Text('Place ${index + 1}', textScaleFactor: 2),
    //           );
    //         },
    //         childCount: 20,
    //       ),
    //     ),
    //     ],
    return SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              Expanded(
                flex: 6,
                child: Column(
                  children: [
                    Expanded(
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                              image: NetworkImage(imageURL),
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
                                        title,
                                        style: fontWeight600(size: 22.0),
                                      ),
                                      Icon(Icons.more_vert),
                                    ],
                                  ),
                                  Text(
                                    "${songList.records.length} Songs",
                                    style: fontWeight400(
                                      color: CustomColor.subTitle2,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 24),
                                    child: CustomButton(
                                      isIcon: true,
                                      label: "Play All",
                                      margin: 0,
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
              ),
              Expanded(
                flex: 8,
                child: Container(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      CustomSongVerticalList(
                        songList: songList,
                        playButton: false,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      
      
    );
  }
}
