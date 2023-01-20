import 'package:flutter/material.dart';
import 'package:musiq/src/common_widgets/box/vertical_box.dart';
import 'package:musiq/src/common_widgets/loader.dart';
import 'package:musiq/src/constants/color.dart';
import 'package:musiq/src/features/player/domain/model/player_song_list_model.dart';
import 'package:musiq/src/utils/image_url_generate.dart';
import 'package:musiq/src/utils/size_config.dart';
import 'package:musiq/src/utils/time.dart';
import 'package:provider/provider.dart';

import '../../../common_widgets/container/custom_color_container.dart';
import '../../../common_widgets/image/no_artist.dart';
import '../../../constants/style.dart';
import '../provider/player_provider.dart';

class SongInfoScreen extends StatefulWidget {
  const SongInfoScreen({super.key, required this.playerSongListModel});
  final PlayerSongListModel playerSongListModel;

  @override
  State<SongInfoScreen> createState() => _SongInfoScreenState();
}

class _SongInfoScreenState extends State<SongInfoScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      context
          .read<PlayerProvider>()
          .songInfo(widget.playerSongListModel.id.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
        child: Scaffold(
            backgroundColor: CustomColor.bg,
            body: Consumer<PlayerProvider>(builder: (context, pro, _) {
              return pro.issongInfoDetailsLoad
                  ? const LoaderScreen()
                  : pro.songInfoModel == null
                      ? const SizedBox.shrink()
                      : SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: getProportionateScreenHeight(350),
                                child: Stack(
                                  children: [
                                    Image.network(
                                      generateSongImageUrl(
                                          pro.songInfoModel!.records
                                              .albumDetails.albumName,
                                          pro.songInfoModel!.records
                                              .albumDetails.albumId),
                                      fit: BoxFit.cover,
                                      height: getProportionateScreenHeight(350),
                                      width: double.maxFinite,
                                    ),
                                    Container(
                                      height: getProportionateScreenHeight(350),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Colors.black.withOpacity(0.5),
                                            Colors.transparent,
                                            Colors.transparent,
                                            Colors.transparent,
                                            Colors.black.withOpacity(0.7)
                                          ],
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.bottomLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          pro.songInfoModel!.records.songName,
                                          style: fontWeight600(size: 24.0),
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: IconButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            icon: const Icon(
                                              Icons.arrow_back_ios,
                                              // color: color2,

                                              size: 18,
                                            )),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      pro.songInfoModel!.records.albumDetails
                                          .albumName,
                                      style: fontWeight400(
                                          size: 16.0,
                                          color: Colors.white.withOpacity(0.6)),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Duration:",
                                          style: fontWeight400(
                                              size: 16.0,
                                              color: Colors.white
                                                  .withOpacity(0.6)),
                                        ),
                                        Text(
                                          " ${detailedDuration(" ${pro.songInfoModel!.records.duration}")}",
                                          style: fontWeight400(
                                              size: 16.0,
                                              color: Colors.white
                                                  .withOpacity(0.6)),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Release:",
                                          style: fontWeight400(
                                              size: 16.0,
                                              color: Colors.white
                                                  .withOpacity(0.6)),
                                        ),
                                        Text(
                                          " ${pro.songInfoModel!.records.albumDetails.releasedYear}",
                                          style: fontWeight400(
                                              size: 16.0,
                                              color: Colors.white
                                                  .withOpacity(0.6)),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Label:",
                                          style: fontWeight400(
                                              size: 16.0,
                                              color: Colors.white
                                                  .withOpacity(0.6)),
                                        ),
                                        Text(
                                          " ${pro.songInfoModel!.records.label}",
                                          style: fontWeight400(
                                              size: 16.0,
                                              color: Colors.white
                                                  .withOpacity(0.6)),
                                        ),
                                      ],
                                    ),
                                    const VerticalBox(height: 24),
                                    Text(
                                      "Artists",
                                      style: fontWeight600(),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.only(top: 4),
                                      height: 300,
                                      child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          shrinkWrap: true,
                                          physics:
                                              const BouncingScrollPhysics(),
                                          itemCount: pro.songInfoModel!.records
                                              .artistDetails.length,
                                          itemBuilder: (context, index) => Row(
                                                children: [
                                                  index == 0
                                                      ? const SizedBox(
                                                          width: 12,
                                                        )
                                                      : const SizedBox(),
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 12),
                                                    child: InkWell(
                                                      onTap: () {
                                                        // Navigation.navigateToScreen(
                                                        //     context, RouteName.artistViewAllSongListScreen,
                                                        //     args: ArtistViewAllModel(
                                                        //         id: artist.records[index].id.toString(),
                                                        //         artistId: artist.records[index].artistId
                                                        //             .toString(),
                                                        //         artistName: artist.records[index].artistName
                                                        //             .toString(),
                                                        //         isImage: artist.records[index].isImage));
                                                      },
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          pro
                                                                      .songInfoModel!
                                                                      .records
                                                                      .artistDetails[
                                                                          index]
                                                                      .isImage ==
                                                                  false
                                                              ? NoArtist()
                                                              : CustomColorContainer(
                                                                  child: Image
                                                                      .network(
                                                                    generateArtistImageUrl(pro
                                                                        .songInfoModel!
                                                                        .records
                                                                        .artistDetails[
                                                                            index]
                                                                        .artistId),
                                                                    height: 240,
                                                                    width: 200,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                                ),
                                                          const SizedBox(
                                                            height: 6,
                                                          ),
                                                          Text(
                                                            pro
                                                                .songInfoModel!
                                                                .records
                                                                .artistDetails[
                                                                    index]
                                                                .artistName,
                                                            style:
                                                                fontWeight400(
                                                                    size: 16.0),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
            })));
    // body: SingleChildScrollView(
    //   child: Column(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: [
    //         Column(
    //           children: [
    //             Stack(
    //               children: [
    //                 Image.network(
    //                   playerSongListModel.imageUrl,
    // fit: BoxFit.cover,
    // height: 350,
    // width: double.maxFinite,
    //                 ),
    //                 Column(
    //                   crossAxisAlignment: CrossAxisAlignment.start,
    //                   children: [
    //                     Container(
    //                         height: 175,
    //                         width: double.maxFinite,
    //                         decoration: BoxDecoration(
    //                           gradient: LinearGradient(
    //                               begin: Alignment.bottomCenter,
    //                               end: Alignment.topCenter,
    //                               colors: [
    //                                 Colors.transparent,
    //                                 Colors.black.withOpacity(0.5),
    //                                 //  color1.withOpacity(0.5)
    //                               ]),
    //                         ),
    //                         child: Padding(
    //                           padding: const EdgeInsets.only(
    //                               bottom: 56, right: 365, left: 5),
    // child: IconButton(
    //     onPressed: () {},
    //     icon: const Icon(
    //       Icons.arrow_back_ios,
    //       // color: color2,

    //       size: 18,
    //     )),
    //                         )),
    //                     Container(
    //                       height: 176,
    //                       width: double.maxFinite,
    //                       decoration: BoxDecoration(
    //                         gradient: LinearGradient(
    //                             begin: Alignment.topCenter,
    //                             end: Alignment.bottomCenter,
    //                             colors: [
    //                               Colors.transparent,
    //                               Colors.black.withOpacity(0.5),
    //                               // color1.withOpacity(0.99)
    //                             ]),
    //                       ),
    //                       child: Padding(
    //                         padding: const EdgeInsets.only(
    //                             top: 150, left: 16),
    //                         child: Text(
    //                           "Havana",
    //                           style: fontWeight600(),
    //                           // style: GoogleFonts.poppins(
    //                           //     textStyle: TextStyle(
    //                           //         color: color2,
    //                           //         fontSize: 22,
    //                           //         fontWeight: FontWeight.w600)),
    //                         ),
    //                       ),
    //                     ),
    //                   ],
    //                 )
    //               ],
    //             ),
    //           ],
    //         ),
    //         // Column(
    //         //   crossAxisAlignment: CrossAxisAlignment.start,
    //         //   children: List.generate(
    //         //     listtexts.length,
    //         //     (index) => Padding(
    //         //       padding: const EdgeInsets.only(left: 16, top: 10),
    //         //       child: Text(listtexts[index].toString(),
    //         //           style: GoogleFonts.poppins(
    //         //               textStyle: TextStyle(
    //         //                   color:
    //         //                       Color.fromRGBO(255, 255, 255, 0.6)),
    //         //               fontSize: 15,
    //         //               fontWeight: FontWeight.w400)),
    //         //     ),
    //         //   ),
    //         // ),

    //         Padding(
    //           padding: const EdgeInsets.only(left: 16, top: 24),
    //           child: Column(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: [
    //               const Text(
    //                 "Artists",
    //                 // style: GoogleFonts.poppins(
    //                 //     textStyle: TextStyle(
    //                 //   color: color2,
    //                 //   fontSize: 18,
    //                 //   fontWeight: FontWeight.w500,
    //                 // )),
    //               ),
    //               Padding(
    //                 padding: const EdgeInsets.only(top: 24),
    //                 child: Row(
    //                   children: [
    //                     Container(
    //                       height: 230,
    //                       width: 156,
    //                       decoration: BoxDecoration(
    //                         borderRadius: BorderRadius.circular(15),
    //                       ),
    //                       child: Column(
    //                         crossAxisAlignment:
    //                             CrossAxisAlignment.start,
    //                         children: const [
    //                           // Image.asset("images/ph35.png"),
    //                           Padding(
    //                             padding: EdgeInsets.only(top: 8),
    //                             child: Text(
    //                               "Camila cabello",
    //                               // style: GoogleFonts.poppins(
    //                               //     textStyle: TextStyle(
    //                               //         color: color2,
    //                               //         fontSize: 15,
    //                               //         fontWeight: FontWeight.w400)),
    //                             ),
    //                           )
    //                         ],
    //                       ),
    //                     ),
    //                     Padding(
    //                       padding: const EdgeInsets.only(left: 16),
    //                       child: Container(
    //                         height: 230,
    //                         width: 156,
    //                         decoration: BoxDecoration(
    //                           borderRadius: BorderRadius.circular(15),
    //                           // color: color1
    //                         ),
    //                         child: Column(
    //                           crossAxisAlignment:
    //                               CrossAxisAlignment.start,
    //                           children: const [
    //                             // Image.asset("images/ph36.png"),
    //                             Padding(
    //                               padding: EdgeInsets.only(top: 8),
    //                               child: Text(
    //                                 "Harry styles",
    //                                 // style: GoogleFonts.poppins(
    //                                 //     textStyle: TextStyle(
    //                                 //         color: color2,
    //                                 //         fontSize: 15,
    //                                 //         fontWeight:
    //                                 //             FontWeight.w400)),
    //                               ),
    //                             )
    //                           ],
    //                         ),
    //                       ),
    //                     )
    //                   ],
    //                 ),
    //               )
    //             ],
    //           ),
    //         )
    //       ]),
    // )));
  }
}
