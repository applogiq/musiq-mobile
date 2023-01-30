import 'package:flutter/material.dart';

import '../../../../common_widgets/buttons/custom_button.dart';
import '../../../../constants/color.dart';
import '../../../../constants/string.dart';
import '../../../common/screen/no_song_screen.dart';

class NoPlaylistSong extends StatelessWidget {
  const NoPlaylistSong(
      {Key? key, required this.appBarTitle, required this.playListId})
      : super(key: key);
  final String appBarTitle;
  final String playListId;

  PopupMenuItem _buildPopupMenuItem(String title, value, context) {
    return PopupMenuItem(
      onTap: () async {
        // if (Options.delete == Options.values[value]) {
        //   await libraryController.deletePlaylist(int.parse(playListId));
        //   Navigator.pop(context);
        // }
        // if (Options.rename == Options.values[value]) {
        //   Future.delayed(
        //     const Duration(seconds: 0),
        //     () => showDialog(
        //       context: context,
        //       builder: (context) => CustomDialogBox(
        //         initialText: appBarTitle,
        //         isRename: true,
        //         title: ConstantText.renamePlaylist,
        //         fieldName: "Name",
        //         buttonText: "Rename",
        //         playlistId: int.parse(playListId),
        //         // callback: libraryController.renamePlaylistUrl(
        //         //     int.parse(playListId), ),
        //       ),
        //     ),
        //   );
        // }
      },
      value: value,
      child: Row(
        children: [
          Text(title),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: Size(MediaQuery.of(context).size.width, 80),
        child: AppBar(
          leading: InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: const Icon(Icons.arrow_back_ios_rounded)),
          title: Text(appBarTitle),
          actions: [
            PopupMenuButton(
              color: CustomColor.appBarColor,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(8.0),
                  bottomRight: Radius.circular(8.0),
                  topLeft: Radius.circular(8.0),
                  topRight: Radius.circular(8.0),
                ),
              ),
              onSelected: (value) {
                print(value);
                // _onMenuItemSelected(value as int);
                // _onMenuItemSelected(value as int);
              },
              itemBuilder: (ctx) => [
                // _buildPopupMenuItem('Add songs', Options.play.index, context),
                // _buildPopupMenuItem('Rename', Options.rename.index, context),
                // _buildPopupMenuItem('Delete', Options.delete.index, context)
              ],
            ),
          ],
        ),
      ),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          NoSongScreen(
            isFav: true,
            mainTitle: ConstantText.noSongHere,
            subTitle: ConstantText.noSongInPlayList,
          ),
          InkWell(
              onTap: () {
                // Navigator.of(context).push(
                //     MaterialPageRoute(builder: (context) => SearchScreen()));
              },
              child: const CustomButton(
                label: ConstantText.addSong,
                horizontalMargin: 105,
              )),
          const Spacer(),
          const Spacer()
        ],
      ),
    );
  }
}
