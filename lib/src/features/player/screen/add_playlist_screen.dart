import 'package:flutter/material.dart';
import 'package:musiq/src/common_widgets/loader.dart';
import 'package:musiq/src/features/player/provider/player_provider.dart';
import 'package:provider/provider.dart';

import '../../../common_widgets/dialog/custom_dialog_box.dart';
import '../../../constants/color.dart';
import '../../../constants/string.dart';
import '../../library/provider/library_provider.dart';
import '../../library/widgets/playlist_tile.dart';

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
      floatingActionButton:
          Consumer<LibraryProvider>(builder: (context, pro, _) {
        return FloatingActionButton(
          onPressed: () {
            pro.isPlayListError = false;
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return CustomDialogBox(
                    onChanged: (v) {
                      pro.checkPlayListName(v);
                    },
                    callBack: () async {
                      await pro.createPlayList(context, isAddPlaylist: true);
                    },
                    title: ConstantText.createPlaylist,
                    fieldName: ConstantText.name,
                    buttonText: ConstantText.create,
                    errorValue: pro.playListError,
                    isError: pro.isPlayListError,
                    // callback: libraryController.createPlaylist(context),
                  );
                });
          },
          child: Container(
            decoration: BoxDecoration(
              color: CustomColor.secondaryColor,
              borderRadius: const BorderRadius.all(
                Radius.circular(100),
              ),
              border: Border.all(color: Colors.transparent, width: 0.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(0.3),
                ),
              ],
            ),
            child: const Icon(
              Icons.add_rounded,
            ),
          ),
        );
      }),
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
                      debugPrint("add to playlist");
                      Map params = {};

                      params["playlist_id"] = record[index].id;
                      params["song_id"] = widget.songId;

                      debugPrint(params.toString());

                      context.read<PlayerProvider>().addToPlaylist(
                          params, context, record[index].playlistName);
                    },
                  );
                });
      }),
    );
  }
}
