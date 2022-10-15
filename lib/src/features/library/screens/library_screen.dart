import 'package:flutter/material.dart';
import 'package:musiq/src/features/library/screens/favourites/favourite_main.dart';
import 'package:provider/provider.dart';

import '../../../common_widgets/loader.dart';
import '../../../constants/color.dart';
import '../../../constants/images.dart';
import '../provider/library_provider.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  Images images = Images();
  late LibraryProvider libraryProvider;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      libraryProvider = Provider.of<LibraryProvider>(context, listen: false);
      libraryProvider.loadFavouriteData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LibraryProvider>(builder: (context, pro, _) {
      return pro.isLoaded == false ? LoaderScreen() : LibraryTabBarMain();
    });

    ;
  }
}

class LibraryTabBarMain extends StatelessWidget {
  const LibraryTabBarMain({
    Key? key,
  }) : super(key: key);

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
              FavouritesMain(),
              FavouritesMain(),
            ],
          ),
        ),
      ),
    );
  }
}
