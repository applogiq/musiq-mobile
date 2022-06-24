import 'dart:convert';

import 'package:musiq/src/logic/services/api_call.dart';
import 'package:musiq/src/model/api_model/album_model.dart';

import '../../helpers/constants/api.dart';
import '../../model/api_model/artist_model.dart';
import '../../model/api_model/recent_song_model.dart';

class APIRoute{
  APICall apiCall=APICall();
   Future<ArtistModel> getArtist()async{
  var res=await apiCall.getRequestWithAuth(APIConstants.BASE_URL+APIConstants.ARTIST_LIST, );
  var data=jsonDecode(res.body);
  print(data.toString());
      ArtistModel artistModel=ArtistModel.fromMap(data);
      
       return artistModel;
  }

 Future<RecentPlayed> getRecentlyPlayed()async{
  var res=await apiCall.getRequestWithAuth(APIConstants.RECENT_PLAYED, );
  var data=jsonDecode(res.body);
  print(data.toString());
      RecentPlayed recentPlayed=RecentPlayed.fromMap(data);
      
       return recentPlayed;
  }

Future<Album> getAlbum()async{
  var res=await apiCall.getRequestWithAuth(APIConstants.ALBUMS_URL, );
  var data=jsonDecode(res.body);
  print(data.toString());
      Album album=Album.fromMap(data);
      
       return album;
  }


  // Future<RecentPlayed> getRecent()async{
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
    
  //      RecentPlayed recentPlayed=RecentPlayed.fromMap(data);
  //      print(recentPlayed.toMap());
     
  //   return recentPlayed;
   
    
  // }


}