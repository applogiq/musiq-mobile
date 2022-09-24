import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:musiq/src/logic/controller/bottom_nav_controller.dart';
import 'package:musiq/src/logic/controller/network_controller.dart';
import 'package:musiq/src/view/pages/common_screen/offline_screen.dart';
import 'package:musiq/src_main/provider/bottom_navigation_bar_provider.dart';
import 'package:musiq/src_main/widgets/bottom_navigation_bar/bottom_navigation_bar.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: Consumer<BottomNavigationBarProvider>(
            builder: (context, provider, _) {
          return provider.pages[provider.selectedBottomIndex];
        }),
        bottomNavigationBar: BottomNavigationBarWidget(
          width: width,
        ),
      ),
    );
  }
}
