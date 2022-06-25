import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musiq/src/logic/services/api_route.dart';
import 'package:musiq/src/model/api_model/artist_model.dart';

import '../../helpers/constants/api.dart';
import '../../model/api_model/recent_song_model.dart';

class ViewAllController extends GetxController{
  APIRoute apiRoute=APIRoute();
var isLoaded=false.obs;
late RecentlyPlayed recentlyPlayed;
late ArtistModel artist;
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

  void getArtistViewAll() {
     isLoaded.value=false;
  Future.delayed(Duration(seconds: 5),(){
    isLoaded.value=true;
  });
  }

}