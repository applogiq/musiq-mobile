import 'package:flutter/material.dart';

class CustomAppBarWidget extends StatelessWidget {
  CustomAppBarWidget(
      {Key? key, required this.title, this.actions, this.height = 64.0})
      : super(key: key);
  final String title;
  var actions;
  var height;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: height,
      titleSpacing: 0.1,
      leading: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(Icons.arrow_back_ios_rounded)),
      title: Text(title),
      actions: actions,
    );
  }
}
