import 'dart:convert';

import 'package:musiq/src/logic/services/api_call.dart';
import 'package:musiq/src/model/api_model/album_model.dart';

import '../../helpers/constants/api.dart';
import '../../model/api_model/artist_model.dart';
import '../../model/api_model/recent_song_model.dart';

class APIRoute{
  APICall apiCall=APICall();
  APIConstants apiConstants=APIConstants();
   Future<ArtistModel> getArtist({int limit=100})async{
     var artistUrl=apiConstants.getArtistUrl(0, limit);

  var res=await apiCall.getRequestWithAuth(APIConstants.BASE_URL+artistUrl, );
  var data=jsonDecode(res.body);
  print(data.toString());
      ArtistModel artistModel=ArtistModel.fromMap(data);
      
       return artistModel;
  }

 Future<RecentlyPlayed> getRecentlyPlayed()async{
  var res=await apiCall.getRequestWithAuth(APIConstants.RECENT_PLAYED, );
  var data=jsonDecode(res.body);
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


}