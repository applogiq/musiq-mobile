import 'package:get/get.dart';
import 'package:musiq/src/helpers/utils/image_url_generate.dart';
import 'package:musiq/src/logic/services/api_route.dart';
import 'package:musiq/src/model/api_model/favourite_model.dart';
import 'package:musiq/src/model/api_model/playlist_model.dart';
import 'package:musiq/src/model/ui_model/view_all_song_list_model.dart';

class LibraryController extends GetxController{
  var isLoaded=false.obs;
  var isLoadedPlayList=false.obs;
  List<ViewAllSongList> view_all_songs_list=[];
  late PlayListModel view_all_play_list;
APIRoute apiRoute=APIRoute();
  loadFavouriteData()async{
Favourite favourite=await apiRoute.getFavourites(id: 2);
   if(favourite.success==true){
  //  List<ViewAllSongList> viewAllSongList=[];
for(int i=0;i<favourite.totalRecords;i++){
  view_all_songs_list.add(ViewAllSongList(favourite.records[i].id.toString(), generateSongImageUrl(favourite.records[i].albumName.toString(), favourite.records[i].albumId.toString()), favourite.records[i].songName, favourite.records[i].musicDirectorName[0],favourite.records[i].albumName));
}

   }
   else{

   }
    Future.delayed(Duration(seconds: 3),(){
      isLoaded.value=true;
    });
  }

loadPlayListData()async{
  isLoadedPlayList.value=false;
 view_all_play_list=await apiRoute.getPlaylists(id: 2);
   if(view_all_play_list.success==true){
  //  List<ViewAllSongList> viewAllSongList=[];
// for(int i=0;i<playListModel.totalRecords;i++){
//   view_all_play_list.add(ViewAllSongList(playListModel.records[i].id.toString(), generateSongImageUrl(playListModel.records[i].albumName.toString(), playListModel.records[i].albumId.toString()), playListModel.records[i].songName ?? "",playListModel.records[i].songName ?? "",playListModel.records[i].albumName??""));
// }

   }
   else{

   }
    Future.delayed(Duration(seconds: 3),(){
      isLoadedPlayList.value=true;
    });
  }





}