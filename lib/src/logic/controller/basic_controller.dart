import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

import '../../helpers/constants/api.dart';
import '../../helpers/utils/navigation.dart';
import '../../model/api_model/user_model.dart';
import '../../view/pages/common_screen/account_screen.dart/select_your fav_artist.dart';
import '../services/api_call.dart';

class BasicController extends GetxController{
 final storage = FlutterSecureStorage();
   APICall apiCall=APICall();

 checkLogged(context)async{
Map<String, String> allValues = await storage.readAll();
print(allValues);
print(allValues["access_token"]);
if(allValues["access_token"]!=null){
   Map<String, dynamic> params = {
     "email": allValues["email"],
     "password": allValues["password_cred"]
    };
    var url=Uri.parse(APIConstants.BASE_URL.toString()+APIConstants.LOGIN.toString());
  
  var res= await apiCall.postRequestWithoutAuth(url,params);
  print(res.statusCode);
  var data=jsonDecode(res.body.toString());
  User user=User.fromMap(data);
  print(user.toMap());
  print(user.records.preference.artist.length);
  if(user.records.preference.artist.length<2){

    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>SelectYourFavList(artist_list: user.records.preference.artist,)));
  }
  else{
  Navigation.navigateReplaceToScreen(context, "bottom/");

  }
  
}
else{
   Navigation.navigateReplaceToScreen(context, 'onboarding/');
}
  }
 
//   startTime() async {
//   var duration =  Duration(seconds: 3);
//   return Timer(duration, goNext);
// }
goNext(context)async{
  await Future.delayed(Duration(milliseconds: 2000));
  Navigation.navigateReplaceToScreen(context, 'onboarding/');
  }
}