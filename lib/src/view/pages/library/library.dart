import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:musiq/src/helpers/constants/color.dart';

class Library extends StatelessWidget {
  const Library({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              "Library",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            bottom: PreferredSize(
              preferredSize: Size(double.maxFinite, 60),
              child: Container(
                margin: EdgeInsets.fromLTRB(16, 24, 16, 0),
                decoration: BoxDecoration(
                    color: CustomColor.textfieldBg,
                    borderRadius: BorderRadius.circular(12)),
                child: TabBar(
                  indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(12), // Creates border
                      color: CustomColor.secondaryColor),
                  tabs: [
                    Tab(
                        icon: Text(
                      "Favourites",
                      style: TextStyle(fontWeight: FontWeight.w400),
                    )),
                    Tab(
                      icon: Text(
                        "Playlists",
                        style: TextStyle(fontWeight: FontWeight.w400),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            backgroundColor: Colors.transparent,
          ),
          body: TabBarView(
            children: [
              Center(
                child: Text("Fav"),
              ),
              Center(
                child: Text("Playlists"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
