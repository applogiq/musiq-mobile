import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../features/common/provider/bottom_navigation_bar_provider.dart';

class NavBarItem extends StatelessWidget {
  const NavBarItem({
    Key? key,
    required this.width,
    required this.index,
  }) : super(key: key);

  final double width;
  final int index;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: width / 3,
        child: Consumer<BottomNavigationBarProvider>(
            builder: (context, provider, _) {
          return InkWell(
            onTap: () {
              provider.changeIndex(index);
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: provider.activeIconColor(index),
                  child: Icon(
                    provider.bottomItems[index].iconData,
                    color: provider.iconColor(index),
                  ),
                ),
                // const SizedBox(
                //   height: 8,
                // ),
                Text(
                  provider.bottomItems[index].labelData,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: provider.textColor(index)),
                )
              ],
            ),
          );
        }));
  }
}
