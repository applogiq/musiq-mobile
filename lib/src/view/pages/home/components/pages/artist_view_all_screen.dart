import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:musiq/src/helpers/constants/images.dart';
import 'package:musiq/src/logic/controller/view_all_controller.dart';
import 'package:musiq/src/logic/services/api_route.dart';
import 'package:musiq/src/view/pages/home/components/pages/view_all/view_all_songs_list.dart';
import 'package:musiq/src/view/pages/home/components/pages/view_all_screen.dart';
import 'package:musiq/src/view/pages/home/components/widget/loader.dart';
import 'package:musiq/src/view/pages/home/home_screen.dart';
import 'package:musiq/src/view/widgets/custom_app_bar.dart';
import 'package:musiq/src/view/widgets/custom_color_container.dart';

import '../../../../../helpers/constants/api.dart';
import '../../../../../helpers/constants/color.dart';
import '../../../../../helpers/utils/image_url_generate.dart';
import '../../../../../logic/services/api_call.dart';
import '../../../../../model/api_model/artist_model.dart';
import '../../../../../model/api_model/song_list_model.dart';
import '../../../../../model/ui_model/view_all_song_list_model.dart';

class ArtistListViewAll extends StatelessWidget {
   ArtistListViewAll({Key? key,}) : super(key: key);
  // final ArtistModel artist;
  
  // APICall apiCall=APICall();

  @override
  Widget build(BuildContext context) {
    final ViewAllController viewAllController=Get.put(ViewAllController());
    viewAllController.getArtistViewAll();
    return Obx((){
      return viewAllController.isLoaded.value?SafeArea(child: Scaffold(appBar: PreferredSize(
        preferredSize: Size(double.maxFinite, 50),
        child: CustomAppBarWidget(
          title: "Artists",
        ),

      ),
      body: Column(
        children: [
           SearchSection(),
           Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                semanticChildCount: 2,
                shrinkWrap: true,
                itemCount: viewAllController.artist.records.length,
                itemBuilder: (context, index) => Container(
                  padding: EdgeInsets.symmetric(horizontal: 6),
                  child: InkWell(
                    onTap:()async{
                      APIRoute apiRoute=APIRoute();
 
                             ViewAllBanner banner= ViewAllBanner(bannerId: viewAllController.artist.records[index].id.toString(),
                              bannerImageUrl:  APIConstants.BASE_IMAGE_URL+viewAllController.artist.records[index].artistId+".png",
                           bannerTitle:  viewAllController.artist.records[index].artistName,
                       );
                              print(banner.bannerImageUrl.toString());
                            SongList songList=  await apiRoute.getSpecificArtistSong(index: viewAllController.artist.records[index].id);
                              // print(songList.records.length);
                              List<ViewAllSongList> viewAllSongListModel=[];
                              for(int i=0;i<songList.records.length;i++){
                                viewAllSongListModel.add(ViewAllSongList(songList.records[i].id.toString(), generateSongImageUrl(songList.records[i].albumName,songList.records[i].albumId), songList.records[i].songName, songList.records[i].musicDirectorName[0],songList.records[i].albumName));
                              }
                           
                            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ViewAllScreenSongList(banner: banner, view_all_song_list_model: viewAllSongListModel)));
                     



                    // viewAllController.artistTap(record: viewAllController.artist.records[index],context:context,index:viewAllController.artist.records[index].id);
                    }
                    
                    ,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                       viewAllController.artist.records[index].isImage==false?Container(height: 185,width: 163.5,decoration: BoxDecoration(color: CustomColor.defaultCard,borderRadius: BorderRadius.circular(12),border: Border.all(color: CustomColor.defaultCardBorder,width: 2.0)),child: Center(child: Image.asset("assets/images/default/no_artist.png",width: 113,height: 118,)),): CustomColorContainer(
                          child:Image.network(APIConstants.BASE_IMAGE_URL+viewAllController.artist.records[index].artistId+".png",height: 185,
                            width: 163.5,
                            fit: BoxFit.cover,)
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Text(
                          viewAllController.artist.records[index].artistName,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, childAspectRatio: 0.78),
              ),
            ),
          )
        ],
      ),
      ),
      )
      :LoaderScreen();
    },);
    
//      Scaffold(
      // appBar: PreferredSize(
      //   preferredSize: Size(double.maxFinite, 50),
      //   child: CustomAppBarWidget(
      //     title: "Artists",
      //   ),
      // ),
//       body:
// Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: SearchTextWidget(
//               onTap: () {},
//               hint: "Search Artists",
//             ),
//           ),
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: GridView.builder(
//                 semanticChildCount: 2,
//                 shrinkWrap: true,
//                 itemCount: artist.records.length,
//                 itemBuilder: (context, index) => Container(
//                   padding: EdgeInsets.symmetric(horizontal: 6),
//                   child: InkWell(
//                     onTap: ()async {
//                               Map<String, String> queryParams = {
//   'artist_id': artist.records[index].id.toString(),
//   'skip': '0',
//   'limit': '100',
// };
//  var urlSet="${APIConstants.BASE_URL}songs?artist_id=${queryParams["artist_id"]}&skip=${queryParams["skip"]}&limit=${queryParams["limit"]}";
//                         var res= await apiCall.getRequestWithAuth(urlSet);
//                         print(res.statusCode);
//                         if(res.statusCode==200){
//                           var data=jsonDecode(res.body);
//                           SongList songList=SongList.fromMap(data);
//                           print(songList.toMap());
//                               Navigator.of(context).push(MaterialPageRoute(builder: (_)=>ViewAllScreen(songList: songList,title: artist.records[index].name,
//                               isNetworkImage: artist.records[index].isImage,
//                             imageURL: artist.records[index].isImage? APIConstants.BASE_IMAGE_URL+artist.records[index].artistId+".png":
//                                   "assets/images/default/no_artist.png",
                            
//                             )));
//                         }
//                         else{

//                         }
                    
//                     },
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                        artist.records[index].isImage==false?Container(height: 185,width: 163.5,decoration: BoxDecoration(color: CustomColor.defaultCard,borderRadius: BorderRadius.circular(12),border: Border.all(color: CustomColor.defaultCardBorder,width: 2.0)),child: Center(child: Image.asset("assets/images/default/no_artist.png",width: 113,height: 118,)),): CustomColorContainer(
//                           child:Image.network(APIConstants.BASE_IMAGE_URL+artist.records[index].artistId+".png",height: 185,
//                             width: 163.5,
//                             fit: BoxFit.cover,)
//                         ),
//                         SizedBox(
//                           height: 6,
//                         ),
//                         Text(
//                           artist.records[index].name,
//                           style: TextStyle(
//                               fontWeight: FontWeight.w400, fontSize: 14),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 2, childAspectRatio: 0.78),
//               ),
//             ),
//           )
//         ],
//       ),
//     );
  
  
  
  }
}

class SearchSection extends StatelessWidget {
  const SearchSection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
     padding: const EdgeInsets.all(16.0),
     child: SearchTextWidget(
       isReadOnly: true,
       onTap: () {},
       hint: "Search Artists",
     ),
          );
  }
}
