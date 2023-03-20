import 'package:flutter/material.dart';

import '../../common/screen/no_song_screen.dart';

class NoRecordWidget extends StatelessWidget {
  const NoRecordWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const NoSongScreen(mainTitle: "No Records", subTitle: "");
  }
}
