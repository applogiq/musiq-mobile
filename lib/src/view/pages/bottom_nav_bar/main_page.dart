import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

import '../../../logic/controller/bottom_nav_controller.dart';
import 'components/bottom_navigation_bar.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
      final BottomNavigationBarController barController =
        Get.put(BottomNavigationBarController());
    double width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body:Obx(() => barController.pages[barController.selectedBottomIndex.value],),
        bottomNavigationBar: BottomNavigationBarWidget(
          width: width, navBarController: barController),
      ),
    );
  }
}