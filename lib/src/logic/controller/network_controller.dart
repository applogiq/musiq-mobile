import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class NetworkController extends GetxController
{
   var connectionType = 0.obs;

   final Connectivity _connectivity = Connectivity();

   late StreamSubscription _streamSubscription ;

  @override
  void onInit() {
     GetConnectionType();
     _streamSubscription = _connectivity.onConnectivityChanged.listen(_updateState);
  }

   Future<void>GetConnectionType() async{
    var connectivityResult;
    try{
      connectivityResult = await (_connectivity.checkConnectivity());
    }on PlatformException catch(e){
      print(e);
    }
    return _updateState(connectivityResult);
   }

     _updateState(ConnectivityResult result)
   {
     switch(result)
     {
       case ConnectivityResult.wifi:
               connectionType.value=1;
               break;
       case ConnectivityResult.mobile:
         connectionType.value=2;
         break;
       case ConnectivityResult.none:
         connectionType.value=0;
         
         break;
       default: Get.snackbar('Network Error', 'Failed to get Network Status');
       break;

     }
   }

  @override
  void onClose() {
      _streamSubscription.cancel();
  }
}