import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:musiq/src/helpers/constants/color.dart';
import 'package:musiq/src/view/pages/home/home_screen.dart';
import 'package:musiq/src/view/pages/library/library.dart';

class CustomBottomBar extends StatefulWidget {
  const CustomBottomBar({Key? key}) : super(key: key);

  @override
  State<CustomBottomBar> createState() => _CustomBottomBarState();
}

class _CustomBottomBarState extends State<CustomBottomBar> {
  int _selectedScreenIndex = 0;
  final List _screens = [
    {"screen": HomePage(), "title": "Screen A Title"},
    {"screen": const Library(), "title": "Screen B Title"},
    {"screen": HomePage(), "title": "Screen A Title"},
    {"screen": const Library(), "title": "Screen B Title"}
  ];

  selectScreen(int index) {
    setState(() {
      _selectedScreenIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedScreenIndex]["screen"],
      bottomNavigationBar: Container(
        margin: EdgeInsets.only(top: 4),
        height: 60,
        child: Row(
          children: [
            InkWell(
              onTap: () {
                selectScreen(0);
              },
              child: Container(
                child: Column(
                  children: [
                    Container(
                        width: MediaQuery.of(context).size.width / 4,
                        padding:
                            EdgeInsets.symmetric(vertical: 7, horizontal: 8),
                        decoration: BoxDecoration(
                            color: _selectedScreenIndex == 0
                                ? CustomColor.secondaryLightColor
                                : Colors.transparent,
                            shape: BoxShape.circle),
                        child: Icon(
                          Icons.home,
                          color: _selectedScreenIndex == 0
                              ? Colors.white
                              : CustomColor.subTitle,
                        )),
                    Text(
                      "Home",
                      style: TextStyle(
                          color: _selectedScreenIndex == 0
                              ? Colors.white
                              : CustomColor.subTitle),
                    )
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                selectScreen(1);
              },
              child: Container(
                child: Column(
                  children: [
                    Container(
                        width: MediaQuery.of(context).size.width / 4,
                        padding:
                            EdgeInsets.symmetric(vertical: 7, horizontal: 8),
                        decoration: BoxDecoration(
                            color: _selectedScreenIndex == 1
                                ? CustomColor.secondaryLightColor
                                : Colors.transparent,
                            shape: BoxShape.circle),
                        child: Icon(
                          Icons.audiotrack,
                          color: _selectedScreenIndex == 1
                              ? Colors.white
                              : CustomColor.subTitle,
                        )),
                    Text(
                      "Library",
                      style: TextStyle(
                          color: _selectedScreenIndex == 1
                              ? Colors.white
                              : CustomColor.subTitle),
                    )
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                selectScreen(2);
              },
              child: Container(
                child: Column(
                  children: [
                    Container(
                        width: MediaQuery.of(context).size.width / 4,
                        padding:
                            EdgeInsets.symmetric(vertical: 7, horizontal: 8),
                        decoration: BoxDecoration(
                            color: _selectedScreenIndex == 2
                                ? CustomColor.secondaryLightColor
                                : Colors.transparent,
                            shape: BoxShape.circle),
                        child: Icon(
                          Icons.podcasts,
                          color: _selectedScreenIndex == 2
                              ? Colors.white
                              : CustomColor.subTitle,
                        )),
                    Text(
                      "Podcast",
                      style: TextStyle(
                          color: _selectedScreenIndex == 2
                              ? Colors.white
                              : CustomColor.subTitle),
                    )
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                selectScreen(3);
              },
              child: Container(
                child: Column(
                  children: [
                    Container(
                        width: MediaQuery.of(context).size.width / 4,
                        padding:
                            EdgeInsets.symmetric(vertical: 7, horizontal: 8),
                        decoration: BoxDecoration(
                            color: _selectedScreenIndex == 3
                                ? CustomColor.secondaryLightColor
                                : Colors.transparent,
                            shape: BoxShape.circle),
                        child: Icon(
                          Icons.person,
                          color: _selectedScreenIndex == 3
                              ? Colors.white
                              : CustomColor.subTitle,
                        )),
                    Text(
                      "Profile",
                      style: TextStyle(
                          color: _selectedScreenIndex == 3
                              ? Colors.white
                              : CustomColor.subTitle),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
