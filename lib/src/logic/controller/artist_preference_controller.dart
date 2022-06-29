import 'package:get/get.dart';
import 'package:musiq/src/logic/controller/basic_controller.dart';
import 'package:musiq/src/model/api_model/artist_model.dart';

import '../../helpers/constants/api.dart';
import '../services/api_call.dart';
import '../services/api_route.dart';

class ArtistPreferenceController extends GetxController{
  BasicController basicController=BasicController();
  
var isLoaded=false.obs;
 APIRoute apiRoute=APIRoute();
 APICall apiCall=APICall();
 var userFollowedArtist=[].obs;
 ArtistModel? artistModel;

  

  void loadData(List datas) async{
    userFollowedArtist.value=datas;
    print(userFollowedArtist.value);
    isLoaded.value=false;
artistModel= await apiRoute.getArtist();

print(artistModel!.records.length);
    isLoaded.value=true;
  }

  void followAndUnfollow(Map params)async {
      var res=  await apiCall.putRequestWithAuth(APIConstants.ARTIST_FOLLOWING,params);
      print(res.statusCode);
  }

  void checkFollow(Record record,int index) {
    print(record.artistId);
    if(userFollowedArtist.contains(record.artistId))
    {
      artistModel!.records[index].followers=(record.followers! -1);

      userFollowedArtist.remove(record.artistId);
      update();
       Map<String, dynamic> params = {
        "artist_id": record.artistId,
        "follow": false
      };
      followAndUnfollow(params);

    }
    else{
      if(artistModel!.records[index].followers==null){
        artistModel!.records[index].followers=1;
      }else{

       artistModel!.records[index].followers=(record.followers! +1);
      }

      userFollowedArtist.add(record.artistId);
        Map<String, dynamic> params = {
        "artist_id": record.artistId,
        "follow": true
      };
      followAndUnfollow(params);
      update();
    
    }
  }

}