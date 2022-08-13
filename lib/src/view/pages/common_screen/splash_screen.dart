

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musiq/src/logic/controller/basic_controller.dart';
import 'package:musiq/src/view/pages/common_screen/account_screen.dart/components/logo_image.dart';
import 'package:musiq/src/view/pages/common_screen/offline_screen.dart';

import '../../../constants/images.dart';
import '../../../logic/controller/network_controller.dart';


class SplashScreen  extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);
  

  

  @override
  Widget build(BuildContext context) {
   

    return Scaffold(
    body: Center(child: Hero(tag: Images.heroImage,child: LogoWithImage()),
      // body: Obx((){
      //   return _networkController.connectionType.value==0?OfflineScreen():Center(child: Hero(tag: Images.heroImage,child: LogoWithImage()),);
      // }),
    ));
  }
}
