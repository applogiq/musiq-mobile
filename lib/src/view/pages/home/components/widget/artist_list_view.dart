import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:musiq/src/helpers/constants/color.dart';
import 'package:musiq/src/logic/services/api_call.dart';
import 'package:musiq/src/logic/services/api_route.dart';
import 'package:musiq/src/model/api_model/artist_model.dart';
import 'package:musiq/src/model/api_model/song_list_model.dart';
import 'package:musiq/src/view/pages/home/components/pages/view_all/view_all_songs_list.dart';
import 'package:musiq/src/view/pages/home/components/pages/view_all_screen.dart';
import 'package:musiq/src/view/pages/home/home_screen.dart';

import '../../../../../helpers/constants/api.dart';
import '../../../../../helpers/utils/image_url_generate.dart';
import '../../../../../model/ui_model/view_all_song_list_model.dart';
import '../../../../widgets/custom_color_container.dart';
import '../pages/artist_view_all_screen.dart';
import 'horizontal_list_view.dart';

class ArtistListView extends StatelessWidget {
   ArtistListView({
    Key? key,
    required this.artist,
  }) : super(key: key);

  final ArtistModel artist;
  APICall apiCall=APICall();
   APIRoute apiRoute=APIRoute();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 0.0),
          child:  Row(
      children: [
        Text(
          "Artists",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        Spacer(),
        InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => 
                     ArtistListViewAll()
                    ));
          },
          child: Text(
            "View All",
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: CustomColor.secondaryColor),
          ),
        )
      ],
    )
        ),
        Container(
          padding: EdgeInsets.only(top: 4),
          height: 300,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              itemCount: artist.records.length,
              itemBuilder: (context, index) => Row(
                    children: [
                      index == 0
                          ? SizedBox(
                              width: 12,
                             
                            )
                          : SizedBox(),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 6),
                        child: InkWell(
                          onTap: ()async{
                                  
                             ViewAllBanner banner= ViewAllBanner(bannerId: artist.records[index].id.toString(),
                              bannerImageUrl:  APIConstants.BASE_IMAGE_URL+artist.records[index].artistId+".png",
                           bannerTitle:  artist.records[index].artistName,
                       );
                              print(banner.bannerImageUrl.toString());
                            SongList songList=  await apiRoute.getSpecificArtistSong(index: artist.records[index].id);
                              // print(songList.records.length);
                              List<ViewAllSongList> viewAllSongListModel=[];
                              for(int i=0;i<songList.records.length;i++){
                                viewAllSongListModel.add(ViewAllSongList(songList.records[i].id.toString(), generateSongImageUrl(songList.records[i].albumName,songList.records[i].albumId), songList.records[i].songName, songList.records[i].musicDirectorName[0]));
                              }
                           
                            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ViewAllScreenSongList(banner: banner, view_all_song_list_model: viewAllSongListModel)));
                     


// //                              Map<String, String> queryParams = {
// //   'artist_id': artist.records[index].id.toString(),
// //   'skip': '0',
// //   'limit': '100',
// // };
// //  var urlSet="${APIConstants.BASE_URL}songs?artist_id=${queryParams["artist_id"]}&skip=${queryParams["skip"]}&limit=${queryParams["limit"]}";
// //                         var res= await apiCall.getRequestWithAuth(urlSet);
// //                         print(res.statusCode);
// //                         if(res.statusCode==200){
// //                           var data=jsonDecode(res.body);
// //                           SongList songList=SongList.fromMap(data);
// //                           print(songList.toMap());
// //                               Navigator.of(context).push(MaterialPageRoute(builder: (_)=>ViewAllScreen(songList: songList,title: artist.records[index].artistName,
// //                               isNetworkImage: artist.records[index].isImage,
// //                             imageURL: artist.records[index].isImage? APIConstants.BASE_IMAGE_URL+artist.records[index].artistId+".png":
// //                                   "assets/images/default/no_artist.png", 
// //                             )));
//                         }
//                         else{

//                         }
//                             // Navigator.of(context).push(MaterialPageRoute(builder: (_)=>ViewAllScreen(title: artist.records[index].name,
//                             // imageURL: artist.records[index].isImage? APIConstants.BASE_IMAGE_URL+artist.records[index].artistId+".png":
//                             //       "https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/450px-No_image_available.svg.png",
                            
//                             // )));
                            
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                             artist.records[index].isImage==false?Container(height: 240,width: 200,decoration: BoxDecoration(color: CustomColor.defaultCard,borderRadius: BorderRadius.circular(12),border: Border.all(color: CustomColor.defaultCardBorder,width: 2.0)),child: Center(child: Image.asset("assets/images/default/no_artist.png",width: 113,height: 118,)),): CustomColorContainer(
                                child: Image.network(
                                   APIConstants.BASE_IMAGE_URL+artist.records[index].artistId+".png",
                            // "http://192.168.29.185:3000/api/v1/public/artists/AR001.png",
                                  height: 240,
                                  width: 200,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(
                                height: 6,
                              ),
                              Text(
                                artist.records[index].artistName,
                                style: TextStyle(
                                    fontWeight: FontWeight.w400, fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ),
                  
                    ],
                  )),
        )
      ],
    );
  }
}
