import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common_widgets/bottom_navigation_bar/bottom_navigation_bar.dart';
import '../provider/bottom_navigation_bar_provider.dart';

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
