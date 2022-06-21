import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:musiq/src/helpers/utils/navigation.dart';
import 'package:musiq/src/logic/services/api_call.dart';
import 'package:musiq/src/view/pages/common_screen/account_screen.dart/components/logo_image.dart';
import 'package:musiq/src/view/pages/common_screen/account_screen.dart/select_your%20fav_artist.dart';

import '../../../helpers/constants/api.dart';
import '../../../model/api_model/user_model.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
   final storage = FlutterSecureStorage();
   APICall apiCall=APICall();

  
  @override
  void initState() {
    super.initState();
   WidgetsBinding.instance.addPostFrameCallback((_){

checkLogged();


});
  }
  checkLogged()async{
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
  if(user.records.preference.artist.length<3){

    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>SelectYourFavList(artist_list: user.records.preference.artist,)));
  }
  else{
  Navigation.navigateReplaceToScreen(context, "bottom/");

  }
  // var artist=allValues["artist_list"]; 
//   String? stringofitems = await storage.read(key: 'artist_list');
 
//  var artist_list = jsonDecode(stringofitems!);
//   print(artist_list.length);  
//   if(artist_list.length==0){
//   }
//   else{

//   Navigation.navigateReplaceToScreen(context, "home/");
//   }
  
}
else{
   Navigation.navigateReplaceToScreen(context, 'onboarding/');
}
  }
  startTime() async {
  var duration =  Duration(seconds: 3);
  return Timer(duration, goNext);
}
goNext(){
  Navigation.navigateReplaceToScreen(context, 'onboarding/');
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.black,
      body: Center(child: LogoWithImage(),)
    );
  }
}
