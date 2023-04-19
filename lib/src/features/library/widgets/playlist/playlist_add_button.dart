import 'package:flutter/material.dart';
import 'package:musiq/src/features/library/provider/library_provider.dart';
import 'package:musiq/src/features/library/widgets/favourite/alert_packages/show_dialog_package.dart';
import 'package:provider/provider.dart';

import '../../../../common_widgets/dialog/playlist_dialog_box.dart';
import '../../../../core/constants/constant.dart';

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
          pro.playListName = "";

          showAnimatedDialog(
            context: context,
            barrierDismissible: false,

            animationType: DialogTransitionType.slideFromLeft,
            curve: Curves.fastOutSlowIn,
            builder: (BuildContext context) {
              return SizedBox(
                height: 10,
                width: double.maxFinite,
                // color: const Color.fromRGBO(22, 21, 28, 0.8),
                child: PlaylistDialogBox(
                  onChanged: (v) {
                    // pro.checkPlayListName(v);
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
                ),
              );
            },
            // duration: const Duration(seconds: 1),
          );

          // showDialog(
          //     context: context,
          //     barrierDismissible: false,
          //     builder: (BuildContext context) {
          //       return
          //        Container(
          //         height: 10,
          //         width: double.maxFinite,
          //         color: const Color.fromRGBO(22, 21, 28, 0.8),
          //         child: PlaylistDialogBox(
          //           onChanged: (v) {
          //             // pro.checkPlayListName(v);
          //           },
          //           callBack: () async {
          //             await pro.createPlayList(context);
          //           },
          //           title: ConstantText.createPlaylist,
          //           fieldName: ConstantText.name,
          //           buttonText: ConstantText.create,
          //           errorValue: pro.playListError,
          //           isError: pro.isPlayListError,
          //           // callback: libraryController.createPlaylist(context),
          //         ),
          //       );
          //     });
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
