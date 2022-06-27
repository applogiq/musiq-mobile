import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:musiq/src/logic/controller/network_controller.dart';
import 'package:musiq/src/view/pages/common_screen/offline_screen.dart';

import '../../../logic/controller/bottom_nav_controller.dart';
import 'components/bottom_navigation_bar.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
      final BottomNavigationBarController barController =
        Get.put(BottomNavigationBarController());
          final NetworkController _networkController = Get.find<NetworkController>();

    double width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body:Obx(() =>_networkController.connectionType.value==0?OfflineScreen(): barController.pages[barController.selectedBottomIndex.value],),
        bottomNavigationBar: BottomNavigationBarWidget(
          width: width, navBarController: barController),
      ),
    );
  }
}