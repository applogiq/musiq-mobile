import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:musiq/src/logic/services/api_call.dart';
import 'package:musiq/src/model/api_model/album_model.dart';
import 'package:musiq/src/model/api_model/aura_model.dart';
import 'package:musiq/src/model/api_model/aura_song_model.dart';
import 'package:musiq/src/model/api_model/favourite_model.dart';
import 'package:musiq/src/model/api_model/playlist_model.dart';
import 'package:musiq/src/model/api_model/playlist_song_model.dart';
import 'package:musiq/src/model/api_model/song_list_model.dart';
import 'package:musiq/src/model/api_model/trending_hits_model.dart';

import '../../helpers/constants/api.dart';
import '../../model/api_model/artist_model.dart';
import '../../model/api_model/recent_song_model.dart';

class APIRoute{
  APICall apiCall=APICall();
  var storage=FlutterSecureStorage();
  APIConstants apiConstants=APIConstants();
   Future<ArtistModel> getArtist({int limit=100})async{
     var artistUrl=apiConstants.getArtistUrl(0, limit);

  var res=await apiCall.getRequestWithAuth(APIConstants.BASE_URL+artistUrl, );
  var data=jsonDecode(res.body);
  print(data.toString());
      ArtistModel artistModel=ArtistModel.fromMap(data);
      
       return artistModel;
  }

 Future<RecentlyPlayed> getRecentlyPlayed({int limit=100})async{
   var user_id=await storage.read(key: "register_id");
    
  var endPoint=apiConstants.getRecentlyPlayedUrl(user_id, limit);
  var res=await apiCall.getRequestWithAuth(APIConstants.BASE_URL+endPoint, );
  print(res.statusCode);
  var data=jsonDecode(res.body);
  if(res.statusCode==404){
      RecentlyPlayed recentlyPlayed=RecentlyPlayed(success: false, message: "NO", records: [], totalrecords: 0);
      return recentlyPlayed;
  }
  print(data.toString());
      RecentlyPlayed recentlyPlayed=RecentlyPlayed.fromMap(data);
      
       return recentlyPlayed;
  }

Future<Album> getAlbum({int limit=100})async{
  var albumsUrl=apiConstants.getAlbumsUrl(0, limit);
  var res=await apiCall.getRequestWithAuth(APIConstants.BASE_URL+albumsUrl );
  var data=jsonDecode(res.body);
  print(data.toString());
      Album album=Album.fromMap(data);
      
       return album;
  }

getFavourites({ int limit=100})async{
  var id=await storage.read(key: "id");
  //  var auraUrl=apiConstants.getAuraUrl(limit:limit);
  var res=await apiCall.getRequestWithAuth(APIConstants.BASE_URL+APIConstants.FAV+ id.toString());
  
  if(res.statusCode==200){
    print(jsonDecode(res.body));
    Favourite favourite=Favourite.fromMap(jsonDecode(res.body));
    return favourite;
  }
  else{
    Favourite favourite=Favourite(success: false, message: "", records: [], totalRecords: 0);
    print(favourite);
    return favourite;

  }
  }
   getSpecificPlaylist(int? id)async {
    
    var res=await apiCall.getRequestWithAuth(APIConstants.BASE_URL+APIConstants.SPECIFIC_PLAYLIST+ id.toString());
    print(res.statusCode);
     if(res.statusCode==200){
    print(jsonDecode(res.body));
    PlayListSongModel playListModel=PlayListSongModel.fromMap(jsonDecode(res.body));
    return playListModel;
  }
  else{
    PlayListSongModel playListModel=PlayListSongModel(success: false, message: "", records: [], totalRecords: 0);
    print(playListModel);
    return playListModel;

  }
  
  }
getPlaylists({ int limit=100})async{
    var id=await storage.read(key: "id");
 
 
  var res=await apiCall.getRequestWithAuth(APIConstants.BASE_URL+APIConstants.PLAYLIST+ id.toString());
  
  if(res.statusCode==200){
    print(jsonDecode(res.body));
    PlayListModel playListModel=PlayListModel.fromMap(jsonDecode(res.body));
    return playListModel;
  }
  else{
    PlayListModel playListModel=PlayListModel(success: false, message: "", records: [], totalRecords: 0);
    print(playListModel);
    return playListModel;

  }
  }
  getSpecificArtistSong({required int index, int skip=0, int limit=100})async {
    var artistSong=apiConstants.getSpecificArtistUrl(index,skip, limit);
   
var url=APIConstants.BASE_URL+artistSong;

    var res=await apiCall.getRequestWithAuth(url );
    if(res.statusCode==200){

  var data=jsonDecode(res.body);
 print(data.toString());
 SongList songList=SongList.fromMap(data);
 return songList;
 
    }
 else{
  SongList songList=SongList(success: false, message: "No Data", records: [], totalrecords: 0);
  return songList;
 }
 
  }
getSpecificAuraSongs({required int id,int limit=100})async{
  var auroSpecificUrl=apiConstants.getSpecificAuraUrl(id, limit);
  var res=await apiCall.getRequestWithAuth(APIConstants.BASE_URL+auroSpecificUrl );
   var data=jsonDecode(res.body);
 print(data.toString());
 AuraSongModel auraSongModel=AuraSongModel.fromMap(data);
 return auraSongModel;
 
}


Future<AuraModel> getAura({int limit=100})async{
   var auraUrl=apiConstants.getAuraUrl(limit:limit);
 var res=await apiCall.getRequestWithAuth(APIConstants.BASE_URL+auraUrl );
  var data=jsonDecode(res.body);
 print(data.toString());
      AuraModel auraModel=AuraModel.fromMap(data);
      
       return auraModel;
}

  getSpecificAlbumSong({required int id,int limit=100}) async{
    var albumSpecific=apiConstants.getSpecificAlbumUrl(id, limit);
  var res=await apiCall.getRequestWithAuth(APIConstants.BASE_URL+albumSpecific );
   var data=jsonDecode(res.body);
 print(data.toString());
 SongList auraSongModel=SongList.fromMap(data);
 return auraSongModel;
  }

   createPlayList(String value)async {
    
    print(value);
    Map params=Map();
    params["playlist_name"]=value;
    String url=APIConstants.BASE_URL+APIConstants.CREATE_PLAYLIST;
    var res=await apiCall.postRequestWithAuth(url, params);
    print(res.statusCode);
    return res;
  }

 




// http://192.168.29.185:3000/api/v1/aura/?limit=100

  // Future<RecentlyPlayed> getRecent()async{
  // await Future.delayed(Duration(seconds: 2),(){});
  //   var token=await storage.read(key: "access_token");
  //   var url=Uri.parse(APIConstants.RECENT_PLAYED,);
  //   var header={ 'Content-type': 'application/json',
  //             'Accept': 'application/json',
  //             "Authorization": "Bearer $token"
  //             };
  //   print(url);
  //   var res=await http.get(url,headers: header);
   
  //     var data=jsonDecode(res.body);
  //     print(data.toString());
    
  //      RecentlyPlayed RecentlyPlayed=RecentlyPlayed.fromMap(data);
  //      print(RecentlyPlayed.toMap());
     
  //   return RecentlyPlayed;
   
    
  // }

deleteSpecificPlaylist(int id){
  print(id);
}

  getTrendingHits({ int limit=100})async {
     var trendingHitsUrl=apiConstants.getTrendingHitsUrl(limit:limit);
 var res=await apiCall.getRequestWithAuth(APIConstants.BASE_URL+trendingHitsUrl );
  if(res.statusCode==200){

var data=jsonDecode(res.body);
 print(data.toString());
      TrendingHitsModel trendingHitsModel=TrendingHitsModel.fromMap(data);
      
       return trendingHitsModel;


  }
  else{
    TrendingHitsModel trendingHitsModel=TrendingHitsModel(success: false, message: "no data", records: [], totalrecords: 0);
    return trendingHitsModel;
  }
  
    }

  getNewRelease({required int limit}) async{
     var newReleaseUrl=apiConstants.getTrendingHitsUrl(limit:limit);
 var res=await apiCall.getRequestWithAuth(APIConstants.BASE_URL+newReleaseUrl );
  if(res.statusCode==200){

var data=jsonDecode(res.body);
 print(data.toString());
      TrendingHitsModel new_release=TrendingHitsModel.fromMap(data);
      
       return new_release;


  }
  else{
    TrendingHitsModel new_release=TrendingHitsModel(success: false, message: "no data", records: [], totalrecords: 0);
    return new_release;
  }
  }

  putRecentSongs(String id) async{
    var url =APIConstants.RECENT_LIST;
    Map params={"song_id": id};
    var res=await apiCall.putRequestWithAuth(url,params );
  }
}