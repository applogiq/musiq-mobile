import 'package:flutter/material.dart';
import 'package:musiq/src/constants/constant.dart';
import 'package:provider/provider.dart';

import '../../../common_widgets/loader.dart';
import '../../common/screen/no_song_screen.dart';
import '../provider/library_provider.dart';
import '../widgets/favourite/favourite_widgets.dart';

class FavouritesScreen extends StatefulWidget {
  const FavouritesScreen({super.key});

  @override
  State<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      context.read<LibraryProvider>().getFavouritesList();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LibraryProvider>(
      builder: (context, pro, _) {
        return pro.isFavouriteLoad
            ? const LoaderScreen()
            : pro.favouriteModel.records.isEmpty
                ? NoSongScreen(
                    mainTitle: ConstantText.noSongHere,
                    subTitle: ConstantText.yourfavNoAvailable)
                : ListView.builder(
                    itemCount: pro.favouriteModel.records.length,
                    itemBuilder: (context, index) {
                      var record = pro.favouriteModel.records;
                      return FavouriteTile(record: record, index: index);
                    },
                  );
      },
    );
  }
}
