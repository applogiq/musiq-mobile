import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:musiq/src/helpers/utils/navigation.dart';
import 'package:musiq/src/view/pages/common_screen/account_screen.dart/components/logo_image.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
   final storage = FlutterSecureStorage();

  
  @override
  void initState() {
    super.initState();
   WidgetsBinding.instance.addPostFrameCallback((_){

// startTime();c
checkLogged();


});
  }
  checkLogged()async{
Map<String, String> allValues = await storage.readAll();
print(allValues);
print(allValues["access_token"]);
if(allValues["access_token"]!=null){
  // var artist=allValues["preference"];
  // print(artist);
  Navigation.navigateReplaceToScreen(context, "login/");
  
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
