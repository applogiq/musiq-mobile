import 'package:flutter/material.dart';
import 'package:musiq/src/common_widgets/loader.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/constant.dart';
import '../../common/screen/no_song_screen.dart';
import '../provider/library_provider.dart';
import '../widgets/favourite/favourite_tile.dart';

class FavouritesScreen extends StatefulWidget {
  const FavouritesScreen({super.key});

  @override
  State<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: context.read<LibraryProvider>().getFavouritesList(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoaderScreen();
        } else {
          if (snapshot.error != null) {
            return const Center(
              child: Text("Something occur wrong,Please try again"),
            );
          } else {
            return Consumer<LibraryProvider>(
              builder: (context, pro, _) {
                return pro.favouriteModel.records.isEmpty
                    ? NoSongScreen(
                        mainTitle: ConstantText.noSongHere,
                        subTitle: ConstantText.yourfavNoAvailable)
                    : ListView.builder(
                        itemCount: pro.favouriteModel.records.length,
                        itemBuilder: (context, index) {
                          var record = pro.favouriteModel.records;
                          return Column(
                            children: [
                              FavouriteTile(record: record, index: index),
                              pro.favouriteModel.records.length - 1 == index
                                  ? const SizedBox(height: 24)
                                  : const SizedBox.shrink()
                            ],
                          );
                        },
                      );
              },
            );
          }
        }
      },
    );
  }
}
