
import 'package:flutter/material.dart';

import '../../../../constants/color.dart';
import '../../../../logic/controller/bottom_nav_controller.dart';
import 'bottom_nav_item.dart';

class BottomNavigationBarWidget extends StatelessWidget {
  const BottomNavigationBarWidget({
    Key? key,
    required this.width,
    required this.navBarController,
  }) : super(key: key);

  final double width;
  final BottomNavigationBarController navBarController;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 80,
      color: CustomColor.bottomNavBarColor,
      child: Row(
        children: List.generate(
          4,
          (index) => NavBarItem(
            width: width,
            navBarController: navBarController,
            index: index,
          ),
        ),
      ),
    );
  }
}
