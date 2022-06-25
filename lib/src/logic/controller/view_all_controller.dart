import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musiq/src/logic/services/api_route.dart';
import 'package:musiq/src/model/api_model/artist_model.dart' as art;
import 'package:musiq/src/view/pages/home/components/pages/artist_song_list_view_all.dart';

import '../../helpers/constants/api.dart';
import '../../model/api_model/recent_song_model.dart';
import '../../model/api_model/song_list_model.dart';

class ViewAllController extends GetxController{
  APIRoute apiRoute=APIRoute();
var isLoaded=false.obs;
late RecentlyPlayed recentlyPlayed;
late art .ArtistModel artist;
late SongList songList;
ScrollController scrollController = ScrollController();
var defaultImage="${APIConstants.SONG_BASE_URL}public/music/tamil/B/Beast/image/AL003.png";

var scrollPosition = 0.0.obs;

  _scrollListener() {
    
      scrollPosition.value = scrollController.position.pixels;
   
  }

// albumsViewAll()async{}
 recentlyPlayedViewAll()async{
   isLoaded.value=false;
    recentlyPlayed=await apiRoute.getRecentlyPlayed();
   isLoaded.value=true;
   
//  await Future.delayed(Duration(seconds: 3),(){
//     isLoaded.value=true;
//   });
  scrollController.addListener(_scrollListener);

}
artistViewAll()async{}
trendingHitsViewAll()async{
  isLoaded.value=false;
  Future.delayed(Duration(seconds: 5),(){
    isLoaded.value=true;
  });
}

  void getRecentlyPlayed() {}

  void getArtistViewAll()async {
     isLoaded.value=false;
artist=await apiRoute.getArtist();
    isLoaded.value=true;

  }

  artistTap({required BuildContext context,required int index,required art.Record record
  
  
  
  ,int skip=0,int limit=100})async{
   var res= await apiRoute.getSpecificArtistSong(index,skip,limit);
   print("API");
   print(res.body);
   if(res.statusCode==200){
     songList=SongList.fromMap(jsonDecode(res.body));
     Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ArtistSongList(songList: songList,record: record,)));
                          
  //  print(songList);
   }
    // print(index);

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
}

}