import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common_widgets/bottom_navigation_bar/bottom_navigation_bar.dart';
import '../provider/bottom_navigation_bar_provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}


class _MainScreenState extends State<MainScreen> {
  @override
  void dispose() {
    BottomNavigationBarProvider().pages[BottomNavigationBarProvider().selectedBottomIndex];
    // TODO: implement dispose
    super.dispose();
  }
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
