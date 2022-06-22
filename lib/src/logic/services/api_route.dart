import 'dart:convert';

import 'package:musiq/src/logic/services/api_call.dart';

import '../../helpers/constants/api.dart';
import '../../model/api_model/artist_model.dart';

class APIRoute{
  APICall apiCall=APICall();
   Future<ArtistModel> getArtist()async{
  var res=await apiCall.getRequestWithAuth(APIConstants.BASE_URL+APIConstants.ARTIST_LIST, );
  var data=jsonDecode(res.body);
  print(data.toString());
      ArtistModel artistModel=ArtistModel.fromMap(data);
      
       return artistModel;
  }


}