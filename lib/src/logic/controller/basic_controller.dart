import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:musiq/src/view/pages/artist_preference/artist_preference.dart';

import '../../helpers/constants/api.dart';
import '../../helpers/utils/navigation.dart';
import '../../model/api_model/user_model.dart';
import '../../view/pages/common_screen/account_screen.dart/select_your fav_artist.dart';
import '../services/api_call.dart';

class BasicController extends GetxController{
 final storage = const FlutterSecureStorage();
   APICall apiCall=APICall();
   

 checkLogged(context)async{
Map<String, String> allValues = await storage.readAll();

if(allValues["access_token"]!=null){
   Map<String, dynamic> params = {
     "email": allValues["email"],
     "password": allValues["password_cred"]
    };
    var url=Uri.parse(APIConstants.BASE_URL.toString()+APIConstants.LOGIN.toString());
  
  var res= await apiCall.postRequestWithoutAuth(url,params);
  
  var data=jsonDecode(res.body.toString());
  User user=User.fromMap(data);
    await storage.deleteAll();
  
  var userData = user.records.toMap();
          for (final name in userData.keys) {
            final value = userData[name];
            debugPrint('$name,$value');
            await storage.write(
              key: name,
              value: value.toString(),
            );
          }
         await storage.write(key: "artist_list", value:jsonEncode(user.records.preference.artist));
         await storage.write(key: "password_cred", value:params["password"]);
         var list1=await storage.read(key: "artist_list");
  
  if(user.records.preference.artist.length<3){

     Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>ArtistPreferenceMain(artist_list: user.records.preference.artist,

    )));
  }
  else{
  Navigation.navigateReplaceToScreen(context, "bottom/");

  }
  
}
else{
   Navigation.navigateReplaceToScreen(context, 'onboarding/');
}
  }
 


}