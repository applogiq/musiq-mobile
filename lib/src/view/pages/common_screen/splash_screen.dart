import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:musiq/src/helpers/constants/images.dart';
import 'package:musiq/src/helpers/utils/navigation.dart';
import 'package:musiq/src/logic/controller/basic_controller.dart';
import 'package:musiq/src/logic/services/api_call.dart';
import 'package:musiq/src/view/pages/common_screen/account_screen.dart/components/logo_image.dart';
import 'package:musiq/src/view/pages/common_screen/account_screen.dart/select_your%20fav_artist.dart';
import 'package:musiq/src/view/pages/common_screen/offline_screen.dart';

import '../../../helpers/constants/api.dart';
import '../../../logic/controller/network_controller.dart';
import '../../../model/api_model/user_model.dart';

class SplashScreen  extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);
  

  

  @override
  Widget build(BuildContext context) {
    BasicController controller=Get.put(BasicController());
         final NetworkController _networkController = Get.find<NetworkController>();

    controller.checkLogged(context);

    return Scaffold(
    
      body: Obx((){
        return _networkController.connectionType.value==0?OfflineScreen():Center(child: Hero(tag: Images.heroImage,child: LogoWithImage()),);
      }),
    );
  }
}
