import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musiq/src/helpers/constants/string.dart';
import 'package:musiq/src/helpers/utils/image_url_generate.dart';
import 'package:musiq/src/logic/services/api_route.dart';
import 'package:musiq/src/model/api_model/favourite_model.dart';
import 'package:musiq/src/model/api_model/playlist_model.dart';
import 'package:musiq/src/model/ui_model/view_all_song_list_model.dart';

class LibraryController extends GetxController{
  var isLoaded=false.obs;
  var isLoadedPlayList=false.obs;
  var playListError="".obs;
  var playListName="".obs;
  List playListNameExist=[];
  List<ViewAllSongList> view_all_songs_list=[];
  late PlayListModel view_all_play_list;
  var isCreatePlayListError =false.obs;
APIRoute apiRoute=APIRoute();
  loadFavouriteData()async{
Favourite favourite=await apiRoute.getFavourites();
   if(favourite.success==true){
  //  List<ViewAllSongList> viewAllSongList=[];
  view_all_songs_list.clear();
for(int i=0;i<favourite.totalRecords;i++){
  view_all_songs_list.add(ViewAllSongList(favourite.records[i].id.toString(), generateSongImageUrl(favourite.records[i].albumName.toString(), favourite.records[i].albumId.toString()), favourite.records[i].songName, favourite.records[i].musicDirectorName[0],favourite.records[i].albumName,favourite.records[i].albumName));
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
 view_all_play_list=await apiRoute.getPlaylists();
 playListNameExist.clear();
 for(int i=0;i<view_all_play_list.totalRecords;i++){
  playListNameExist.add(view_all_play_list.records[i].playlistName);
 }
   if(view_all_play_list.success==true){
  //  List<ViewAllSongList> viewAllSongList=[];
// for(int i=0;i<playListModel.totalRecords;i++){
//   view_all_play_list.add(ViewAllSongList(playListModel.records[i].id.toString(), generateSongImageUrl(playListModel.records[i].albumName.toString(), playListModel.records[i].albumId.toString()), playListModel.records[i].songName ?? "",playListModel.records[i].songName ?? "",playListModel.records[i].albumName??""));
// }

   }
   else{

   }
    
      isLoadedPlayList.value=true;
    
  }

checkPlayListName(String name){
  print(name);
  print(playListNameExist);
 if(name.trim()==""){
  isCreatePlayListError.value=true;
  playListError.value=ConstantText.fieldRequired;
 }
 else if(playListNameExist.contains(name.trim())){
    isCreatePlayListError.value=true;
  playListError.value=ConstantText.playListNameExist;

  }
  else{
    isCreatePlayListError.value=false;
  }
  playListName.value=name;
  
}

createPlaylist(context)async{
  if(playListName.value==""){

  }
  else if(isCreatePlayListError.value==true){
  
  }
  else{
  var res=await apiRoute.createPlayList(playListName.value);
  print(res.body);
  var data=jsonDecode(res.body);
  print(data);
  view_all_play_list=PlayListModel.fromMap(jsonDecode(res.body));
  update();
  Navigator.of(context).pop();
  }
}

}