import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:musiq/src/features/library/provider/library_provider.dart';
import 'package:provider/provider.dart';

import '../../core/constants/constant.dart';
import '../buttons/custom_button.dart';
import '../container/custom_color_container.dart';

class PlaylistDialogBox extends StatelessWidget {
  const PlaylistDialogBox({
    Key? key,
    required this.title,
    required this.fieldName,
    required this.buttonText,
    required this.onChanged,
    required this.callBack,
    required this.isError,
    required this.errorValue,
    this.initialText = "",
  }) : super(key: key);

  final String title, fieldName, buttonText;

  final Function callBack;

  final String errorValue;
  final String initialText;
  final bool isError;
  final ValueChanged<String> onChanged;

  contentBox(context) {
    return Consumer(
      builder: (context, pro, _) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: dialogBoxDecoration(),
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
                            Navigator.of(context).pop();
                          },
                          child: const Icon(Icons.close))
                    ],
                  ),
                  Divider(
                    color: CustomColor.textfieldBg,
                  ),
                  Consumer<LibraryProvider>(builder: (context, pro, _) {
                    return Column(
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
                              constraints: const BoxConstraints.expand(
                                  height: 46, width: double.maxFinite),
                              child: TextFormField(
                                initialValue: initialText,
                                cursorColor: Colors.white,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r"^[A-Za-z]+[A-Za-z ]*$"))
                                ],
                                onChanged: (value) {
                                  pro.checkPlayListName(value);
                                },
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintStyle: TextStyle(fontSize: 14),
                                ),
                              ),
                            ),
                          ),
                        ),
                        pro.isPlayListError
                            ? Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  pro.playListError,
                                  style: const TextStyle(color: Colors.red),
                                ),
                              )
                            : const SizedBox.shrink()
                      ],
                    );
                  }),
                  InkWell(
                      onTap: () {
                        callBack();
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
      },
    );
  }

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
}
