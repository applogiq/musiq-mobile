import 'package:flutter/cupertino.dart';
import 'package:musiq/src/common_widgets/box/vertical_box.dart';
import 'package:musiq/src/features/home/provider/home_provider.dart';
import 'package:musiq/src/features/home/widgets/artist_list_view.dart';
import 'package:musiq/src/features/home/widgets/home_screen_song_list.dart';
import 'package:musiq/src/features/home/widgets/top_album_list.dart';
import 'package:provider/provider.dart';

class PodCastAllScreen extends StatefulWidget {
  const PodCastAllScreen({super.key});

  @override
  State<PodCastAllScreen> createState() => _PodCastAllScreenState();
}

class _PodCastAllScreenState extends State<PodCastAllScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(builder: (context, pro, object) {
      return ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: HomeScreenSongList(
              title: "Top Podcasts",
              isViewAll: true,
              songList: pro.newReleaseListModel,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: HomeScreenSongList(
              title: "Top Podcasts",
              isViewAll: true,
              songList: pro.newReleaseListModel,
            ),
          ),
          const VerticalBox(height: 10),
          ArtistListView(artist: pro.preferableartistmodel),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: HomeScreenSongList(
              title: "Top Podcasts",
              isViewAll: true,
              songList: pro.newReleaseListModel,
            ),
          ),
          TopAlbum(album: pro.albumListModel)
        ],
      );
    });
  }
}
