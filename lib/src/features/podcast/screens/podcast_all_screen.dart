import 'package:flutter/material.dart';
import 'package:musiq/src/common_widgets/loader.dart';
import 'package:musiq/src/features/podcast/provider/podcast_provider.dart';
import 'package:musiq/src/features/podcast/widgets/view_all_podcasts_widget.dart';
import 'package:provider/provider.dart';

class PodCastAllScreen extends StatefulWidget {
  const PodCastAllScreen({super.key});

  @override
  State<PodCastAllScreen> createState() => _PodCastAllScreenState();
}

class _PodCastAllScreenState extends State<PodCastAllScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Provider.of<PodcastProvider>(context, listen: false).getAllPodcastList();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PodcastProvider>(builder: (context, pro, object) {
      return pro.getPodcastsLoad
          ? const LoaderScreen()
          : ListView(
              children: [
                const SizedBox(
                  height: 10,
                ),

                // const SizedBox(
                //   height: 10,
                // ),
                // Center(
                //   child: Consumer<PodcastProvider>(builder: (context, pro, _) {
                //     return InkWell(
                //         onTap: () {
                //           pro.getAllPodcastList();
                //         },
                //         child: const Text("data"));
                //   }),
                // ),
                // Padding(
                //   padding: const EdgeInsets.only(top: 10),
                //   child: HomeScreenSongList(
                //     title: "Top Podcasts",
                //     isViewAll: true,
                //     songList: pro.newReleaseListModel,
                //   ),
                // ),
                // Padding(
                //   padding: const EdgeInsets.only(top: 10),
                //   child: HomeScreenSongList(
                //     title: "Top Podcasts",
                //     isViewAll: true,
                //     songList: pro.newReleaseListModel,
                //   ),
                // ),
                // const VerticalBox(height: 10),
                // ArtistListView(artist: pro.preferableartistmodel),
                // Padding(
                //   padding: const EdgeInsets.only(top: 10),
                //   child: HomeScreenSongList(
                //     title: "Top Podcasts",
                //     isViewAll: true,
                //     songList: pro.newReleaseListModel,
                //   ),
                // ),
                GetAllPodcastWidget(album: pro.getAllpodcasts),

                // const VerticalBox(height: 10),
                // Consumer<HomeProvider>(builder: (context, pro, _) {
                //   return ArtistListView(artist: pro.preferableartistmodel);
                // })
              ],
            );
    });
  }
}
