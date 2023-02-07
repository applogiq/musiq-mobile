import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../common_widgets/loader.dart';
import '../../../../core/constants/string.dart';
import '../../../common/screen/no_song_screen.dart';
import '../../provider/library_provider.dart';
import '../../widgets/playlist/playlist_widgets.dart';
import 'view_playlist_screen.dart';

class PlaylistsScreen extends StatefulWidget {
  const PlaylistsScreen({super.key});

  @override
  State<PlaylistsScreen> createState() => _PlaylistsScreenState();
}

class _PlaylistsScreenState extends State<PlaylistsScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      context.read<LibraryProvider>().getPlayListsList();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LibraryProvider>(
      builder: (context, pro, _) {
        return pro.isPlayListLoad
            ? const LoaderScreen()
            : Scaffold(
                floatingActionButton: const PlayListAddButton(),
                body: pro.playListModel.records.isEmpty
                    ? NoSongScreen(
                        mainTitle: ConstantText.noPlaylistHere,
                        subTitle: ConstantText.yourPlaylistNoAvailable)
                    : ListView.builder(
                        itemCount: pro.playListModel.records.length,
                        itemBuilder: (context, index) {
                          var record = pro.playListModel.records;
                          return PlaylistTile(
                            record: record,
                            index: index,
                            callBack: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ViewPlaylistSongScreen(
                                      id: record[index].id,
                                      title: record[index].playlistName)));
                            },
                          );
                        },
                      ),
              );
      },
    );
  }
}
