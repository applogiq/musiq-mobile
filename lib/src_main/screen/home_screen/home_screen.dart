import 'package:flutter/material.dart';
import 'package:musiq/src_main/constants/images.dart';

import '../../widgets/list/recommended_songs.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);
  Images images = Images();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // RecommendedSongs(images: images),
        ],
      ),
    );
  }
}
