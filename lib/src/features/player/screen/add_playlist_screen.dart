import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common_widgets/loader.dart';
import '../../library/widgets/playlist/playlist_widgets.dart';
import '../provider/player_provider.dart';

class AddToPlaylistScreen extends StatefulWidget {
  const AddToPlaylistScreen({super.key, required this.songId});

  final int songId;

  @override
  State<AddToPlaylistScreen> createState() => _AddToPlaylistScreenState();
}

class _AddToPlaylistScreenState extends State<AddToPlaylistScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      context.read<PlayerProvider>().getPlayListsList();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add to playlist"),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios_rounded)),
      ),
      floatingActionButton: const PlayListAddButton(),
      body: Consumer<PlayerProvider>(builder: (context, pro, _) {
        return pro.isPlayListLoad
            ? const LoaderScreen()
            : ListView.builder(
                itemCount: pro.playListModel.records.length,
                itemBuilder: (context, index) {
                  var record = pro.playListModel.records;
                  return PlaylistTile(
                    record: record,
                    index: index,
                    isMore: false,
                    callBack: () {
                      Map params = {};

                      params["playlist_id"] = record[index].id;
                      params["song_id"] = widget.songId;

                      context.read<PlayerProvider>().addToPlaylist(
                          params, context, record[index].playlistName);
                    },
                  );
                });
      }),
    );
  }
}
