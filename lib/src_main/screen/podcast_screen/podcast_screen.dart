import 'package:flutter/material.dart';
import 'package:musiq/src_main/constants/images.dart';

import '../../widgets/list/recommended_songs.dart';

class PodcastScreen extends StatelessWidget {
  const PodcastScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text("Podcast"),
        ],
      ),
    );
  }
}
