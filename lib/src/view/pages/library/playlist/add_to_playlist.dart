import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:musiq/src/view/pages/library/playlist/playlist_floating_button.dart';
import '../../../../constants/color.dart';
import '../../../../constants/string.dart';
import '../../../../constants/style.dart';
import '../../../../constants/style/box_decoration.dart';
import '../../../../helpers/utils/image_url_generate.dart';
import '../../../../logic/controller/library_controller.dart';
import '../../../../logic/services/api_route.dart';
import '../../../../widgets/custom_app_bar.dart';
import '../../../../widgets/custom_color_container.dart';
import '../../home/components/widget/loader.dart';
import '../favourites/no_favourite.dart';

class AddToPlaylist extends StatelessWidget {
   AddToPlaylist({Key? key, required this.song_id}) : super(key: key);
   final int song_id;
   LibraryController libraryController = Get.put(LibraryController());
 APIRoute apiRoute = APIRoute();
  @override
  Widget build(BuildContext context) {
    libraryController.loadPlayListData();
    return Obx(() {
      return libraryController.isLoadedPlayList.value == false
          ? LoaderScreen()
          : SafeArea(child: Scaffold(
      appBar: PreferredSize(
        preferredSize:  Size(MediaQuery.of(context).size.width, 60),
        child: CustomAppBarWidget(title: "Add to playlist",height: 54.0,),
        ),
        body:    Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0),
                child: GetBuilder<LibraryController>(
                  init: LibraryController(),
                  initState: (_) {},
                  builder: (_) {
                    return libraryController.view_all_play_list.records.length==0?
   NoSongScreen(mainTitle: ConstantText.noPlaylistHere, subTitle: ""): ListView(
                      shrinkWrap: true,
                      
                      children: List.generate(
                        libraryController.view_all_play_list.records.length,
                        (index) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: ()async{
                              
                              Map params={};

                              params["playlist_id"]=libraryController.view_all_play_list.records[index].id;
                              params["song_id"]=song_id;
                              print(params);
                              await apiRoute.addSongToPlaylist(params);
                              Fluttertoast.showToast(
        msg: "Added to ${libraryController.view_all_play_list
                                            .records[index].playlistName}",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: CustomColor.subTitle2,
        textColor: Colors.white,
        fontSize: 16.0
    );
    Navigator.of(context).pop();
                            },
                            child: Row(
                              children: [
                                libraryController.view_all_play_list
                                            .records[index].noOfSongs ==
                                        0
                                    ? Container(
                                        height: 70,
                                        width: 70,
                                        decoration: PlayListNoImageDecoration(),
                                        child: Center(
                                            child: Text(
                                          libraryController.view_all_play_list
                                              .records[index].playlistName[0]
                                              .toString().toUpperCase(),
                                          style: fontWeight600(),
                                        ),),
                                      )
                                    : Align(
                                        alignment: Alignment.centerLeft,
                                        child: CustomColorContainer(
                                          bgColor: libraryController
                                                      .view_all_play_list
                                                      .records[index]
                                                      .noOfSongs ==
                                                  0
                                              ? CustomColor.defaultCard
                                              : Colors.transparent,
                                          child: libraryController
                                                      .view_all_play_list
                                                      .records[index]
                                                      .noOfSongs ==
                                                  0
                                              ? Container(
                                                  height: 70,
                                                  width: 70,
                                                  alignment: Alignment.center,
                                                  child: Text(libraryController
                                                      .view_all_play_list
                                                      .records[index]
                                                      .playlistName[0]))
                                              : Image.network(
                                                  generateSongImageUrl(
                                                      libraryController
                                                          .view_all_play_list
                                                          .records[index]
                                                          .albumName
                                                          .toString(),
                                                      libraryController
                                                          .view_all_play_list
                                                          .records[index]
                                                          .albumId
                                                          .toString()),
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            libraryController.view_all_play_list
                                                .records[index].playlistName
                                                .toString(),
                                             style: fontWeight400(),
                                          ),
                                          Text(
                                            "Playlist -" +
                                                libraryController
                                                    .view_all_play_list
                                                    .records[index]
                                                    .noOfSongs
                                                    .toString() +
                                                " songs",
                                            style: fontWeight400(
                                                size: 12.0,
                                                color: CustomColor.subTitle),
                                          ),
                                        ],
                                      ),
                                    )),
                             
                            
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
  
      floatingActionButton: PlaylistButton(),
    ));
    });
  }
}