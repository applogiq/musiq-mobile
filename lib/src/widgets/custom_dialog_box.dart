import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musiq/src/constants/color.dart';
import 'package:musiq/src/constants/style.dart';
import 'package:musiq/src/logic/controller/library_controller.dart';
import 'package:musiq/src/widgets/custom_button.dart';
import 'custom_color_container.dart';
import 'empty_box.dart';

class CustomDialogBox extends StatelessWidget {
  final String title, fieldName, buttonText;

  CustomDialogBox(
      {Key? key,
      required this.title,
      required this.fieldName,
      required this.buttonText,
      this.initialText = "",
      this.isRename = false,
      this.playlistId = 0})
      : super(key: key);
  final String initialText;
  int playlistId;
  final bool isRename;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 0,
      backgroundColor: Colors.amber,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    final LibraryController libraryController = Get.put(LibraryController());
    return Container(
      padding: EdgeInsets.all(16),
      // padding: EdgeInsets.only(left: 20,top: 45
      //     + 20, right: 20,bottom: 20
      // ),
      // margin: EdgeInsets.only(top: 45),
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: CustomColor.appBarColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
                color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
          ]),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: fontWeight500(),
                  ),
                  InkWell(
                      onTap: () {
                        libraryController.isCreatePlayListError.value = false;
                        Navigator.of(context).pop();
                      },
                      child: Icon(Icons.close))
                ],
              ),
              Divider(
                color: CustomColor.textfieldBg,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text(
                      fieldName,
                      style: fontWeight500(size: 14.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: CustomColorContainer(
                      left: 16,
                      right: 24,
                      verticalPadding: 0,
                      bgColor: CustomColor.textfieldBg,
                      child: ConstrainedBox(
                        constraints: BoxConstraints.expand(
                            height: 46, width: double.maxFinite),
                        child: TextFormField(
                          initialValue: initialText,
                          cursorColor: Colors.white,
                          onChanged: (value) {
                            libraryController.checkPlayListName(value);
                          },

                          // inputFormatters: [WhitelistingTextInputFormatter(RegExp("[a-zA-Z]")),],,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintStyle: TextStyle(fontSize: 14),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Obx(() {
                    return libraryController.isCreatePlayListError.value
                        ? Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              libraryController.playListError.value,
                              style: const TextStyle(color: Colors.red),
                            ),
                          )
                        : EmptyBox();
                  }),
                ],
              ),
              InkWell(
                  onTap: () {
                    isRename
                        ? libraryController.renamePlaylistUrl(
                            playlistId, context)
                        : libraryController.createPlaylist(context);
                  },
                  child: CustomButton(
                    label: buttonText,
                    horizontalMargin: 60,
                    verticalMargin: 8,
                  ))
            ],
          )
        ],
      ),
    );
  }
}
