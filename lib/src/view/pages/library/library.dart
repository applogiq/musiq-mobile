import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:musiq/src/helpers/constants/color.dart';
import 'package:musiq/src/helpers/constants/images.dart';
import 'package:musiq/src/view/pages/home/components/widget/vertical_list_view.dart';

class Library extends StatelessWidget {
  Library({Key? key}) : super(key: key);
  Images images = Images();

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
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    // CustomSongVerticalList(
                    //   images: images.favList,
                    //   playButton: false,
                    // )
                  ],
                ),
              ),
              PlaylistScreen(images: images),
            ],
          ),
        ),
      ),
    );
  }
}

class PlaylistScreen extends StatelessWidget {
  const PlaylistScreen({
    Key? key,
    required this.images,
  }) : super(key: key);

  final Images images;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0),
        child: ListView(
          shrinkWrap: true,
          children: [
            // CustomSongVerticalList(
            //   images: images.playList,
            //   playButton: false,
            // )
          ],
        ),
      ),
    );
  }
}
