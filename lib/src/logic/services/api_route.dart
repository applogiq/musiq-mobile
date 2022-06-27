import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:musiq/src/logic/services/api_call.dart';
import 'package:musiq/src/model/api_model/album_model.dart';
import 'package:musiq/src/model/api_model/aura_model.dart';

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

  getSpecificArtistSong(int index, int skip, int limit)async {
    var artistSong=apiConstants.getSpecificArtistUrl(index,skip, limit);
   
var url=APIConstants.BASE_URL+artistSong;

    var res=await apiCall.getRequestWithAuth(url );
 
    return res;
 
 
  }



Future<AuraModel> getAura({int limit=100})async{
   var auraUrl=apiConstants.getAuraUrl(limit:limit);
 var res=await apiCall.getRequestWithAuth(APIConstants.BASE_URL+auraUrl );
  var data=jsonDecode(res.body);
 print(data.toString());
      AuraModel auraModel=AuraModel.fromMap(data);
      
       return auraModel;
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


}