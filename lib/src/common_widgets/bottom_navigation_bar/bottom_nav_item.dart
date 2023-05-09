import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../features/common/provider/bottom_navigation_bar_provider.dart';

class NavBarItem extends StatelessWidget {
  const NavBarItem({
    Key? key,
    required this.width,
    required this.index,
  }) : super(key: key);

  final int index;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: width / 4,
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
                  radius: 12,
                  backgroundColor: provider.activeIconColor(index),
                  child: Icon(
                    provider.bottomItems[index].iconData,
                    color: provider.iconColor(index),
                    size: 18,
                  ),
                ),
                Text(
                  provider.bottomItems[index].labelData,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: provider.textColor(index)),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
