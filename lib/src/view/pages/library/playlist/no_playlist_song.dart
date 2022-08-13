import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musiq/src/view/pages/home/components/pages/search_screen.dart';
import '../../../../constants/color.dart';
import '../../../../constants/string.dart';
import '../../../../logic/controller/library_controller.dart';

import '../../../../widgets/custom_button.dart';
import '../../../../widgets/custom_dialog_box.dart';
import '../favourites/no_favourite.dart';

enum Options { play, rename, delete }

class NoPlaylistSong extends StatelessWidget {
  NoPlaylistSong(
      {Key? key, required this.appBarTitle, required this.playListId})
      : super(key: key);
  final String appBarTitle;
  final String playListId;
  LibraryController libraryController = Get.put(LibraryController());

  PopupMenuItem _buildPopupMenuItem(
    String title,
    value,
    context, {
    int position = 0,
    int id = 0,
  }) {
    return PopupMenuItem(
      onTap: () async {
        if (Options.delete == Options.values[value]) {
          await libraryController.deletePlaylist(int.parse(playListId));
          Navigator.pop(context);
        }
        if (Options.rename == Options.values[value]) {
          Future.delayed(
            const Duration(seconds: 0),
            () => showDialog(
              context: context,
              builder: (context) => CustomDialogBox(
                initialText: appBarTitle,
                isRename: true,
                title: ConstantText.renamePlaylist,
                fieldName: "Name",
                buttonText: "Rename",
                playlistId: int.parse(playListId),
                // callback: libraryController.renamePlaylistUrl(
                //     int.parse(playListId), ),
              ),
            ),
          );
        }
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
              child: Icon(Icons.arrow_back_ios_rounded)),
          title: Text(appBarTitle),
          actions: [
            PopupMenuButton(
              color: CustomColor.appBarColor,
              shape: RoundedRectangleBorder(
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
                _buildPopupMenuItem('Add songs', Options.play.index, context),
                _buildPopupMenuItem('Rename', Options.rename.index, context),
                _buildPopupMenuItem('Delete', Options.delete.index, context)
              ],
            ),
          ],
        ),
      ),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Spacer(),
          NoSongScreen(
            isFav: true,
            mainTitle: ConstantText.noSongHere,
            subTitle: ConstantText.noSongInPlayList,
          ),
          InkWell(
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => SearchScreen()));
              },
              child: CustomButton(
                label: ConstantText.browseSong,
                horizontalMargin: 105,
              )),
          Spacer(),
          Spacer()
        ],
      ),
    );
  }
}
