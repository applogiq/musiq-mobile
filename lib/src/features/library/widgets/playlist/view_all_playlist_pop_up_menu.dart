// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../common_widgets/dialog/playlist_dialog_box.dart';
import '../../../../core/constants/constant.dart';
import '../../../../core/enums/enums.dart';
import '../../../../core/routing/route_name.dart';
import '../../../../core/utils/navigation.dart';
import '../../../search/provider/search_provider.dart';
import '../../../search/screens/search_screen.dart';
import '../../provider/library_provider.dart';

class ViewAllPlaylistPopUpMenu extends StatelessWidget {
  const ViewAllPlaylistPopUpMenu({
    Key? key,
    required this.id,
    required this.title,
    required this.mainContext,
  }) : super(key: key);

  final int id;
  final String title;
  final BuildContext mainContext;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      color: CustomColor.appBarColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(8.0),
          bottomRight: Radius.circular(8.0),
          topLeft: Radius.circular(8.0),
          topRight: Radius.circular(8.0),
        ),
      ),
      padding: const EdgeInsets.all(0.0),
      onSelected: (value) async {
        if (value == 1) {
          context.read<SearchProvider>().resetState();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SearchScreen(
                searchRequestModel: SearchRequestModel(
                    searchStatus: SearchStatus.playlist, playlistId: id),
              ),
            ),
          );
          // Navigation.navigateToScreen(context, RouteName.search,
          //     args: SearchRequestModel(
          //         searchStatus: SearchStatus.playlist, playlistId: id));
        } else if (value == 2) {
          context.read<LibraryProvider>().reset();
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return PlaylistDialogBox(
                  onChanged: (v) {
                    context.read<LibraryProvider>().checkPlayListName(v);
                  },
                  callBack: () async {
                    await context
                        .read<LibraryProvider>()
                        .updatePlayListName(context, id, mainContext);
                  },
                  initialText: title,
                  title: ConstantText.renamePlaylist,
                  fieldName: ConstantText.name,
                  buttonText: ConstantText.rename,
                  errorValue: "",
                  isError: false,
                  // callback: libraryController.createPlaylist(context),
                );
              });
        } else if (value == 3) {
          await context.read<LibraryProvider>().deletePlayList(id);
          Navigation.navigateReplaceToScreen(context, RouteName.mainScreen);
        }
      },
      itemBuilder: (ctx) => [
        const PopupMenuItem(
          value: 1,
          child: Text('Add songs'),
        ),
        const PopupMenuItem(
          value: 2,
          child: Text('Rename'),
        ),
        const PopupMenuItem(
          value: 3,
          child: Text('Delete'),
        ),
      ],
    );
  }
}
