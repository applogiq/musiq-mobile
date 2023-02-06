import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/color.dart';
import '../../features/common/provider/bottom_navigation_bar_provider.dart';
import 'bottom_nav_item.dart';

class BottomNavigationBarWidget extends StatelessWidget {
  const BottomNavigationBarWidget({
    Key? key,
    required this.width,
  }) : super(key: key);

  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 80,
      color: CustomColor.bottomNavBarColor,
      child: Consumer<BottomNavigationBarProvider>(
        builder: (context, provider, _) {
          return Row(
            children: List.generate(
              provider.pages.length,
              (index) => NavBarItem(
                width: width,
                index: index,
              ),
            ),
          );
        },
      ),
    );
  }
}
