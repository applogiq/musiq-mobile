import 'package:flutter/material.dart';
import 'package:musiq/src/common_widgets/loader.dart';
import 'package:musiq/src/features/library/screens/playlist/view_playlist_screen.dart';
import 'package:provider/provider.dart';

import '../../../../common_widgets/dialog/custom_dialog_box.dart';
import '../../../../constants/color.dart';
import '../../../../constants/string.dart';
import '../../../common/screen/no_song_screen.dart';
import '../../provider/library_provider.dart';
import '../../widgets/playlist_tile.dart';

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
    return Consumer<LibraryProvider>(builder: (context, pro, _) {
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
                            print(record[index].id);
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ViewPlaylistSongScreen(
                                    id: record[index].id,
                                    title: record[index].playlistName)));
                          },
                        );
                      }),
            );
    });
  }
}

class PlayListAddButton extends StatelessWidget {
  const PlayListAddButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<LibraryProvider>(builder: (context, pro, _) {
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
                    await pro.createPlayList(context);
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
    });
  }
}
