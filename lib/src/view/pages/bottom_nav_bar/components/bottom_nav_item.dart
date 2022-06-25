import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../logic/controller/bottom_nav_controller.dart';

class NavBarItem extends StatelessWidget {
  const NavBarItem({
    Key? key,
    required this.width,
    required this.navBarController,
    required this.index,
  }) : super(key: key);

  final double width;
  final int index;
  final BottomNavigationBarController navBarController;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width / 4,
      child: InkWell(
          onTap: () {
            navBarController.selectedBottomIndex(index);
          },
          child: Obx(
            () => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: navBarController.activeIconColor(index),
                  child: Icon(
                    navBarController.bottomItems[index].iconData,
                    color: navBarController.iconColor(index),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  navBarController.bottomItems[index].labelData,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: navBarController.textColor(index)),
                )
              ],
            ),
          )),
    );
  }
}
