import 'package:flutter/material.dart';

import '../../helpers/constants/color.dart';

class CustomButton extends StatelessWidget {
  CustomButton(
      {Key? key, required this.label, this.margin = 16, this.isIcon = false})
      : super(key: key);
  final String label;
  double margin;
  bool isIcon;
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(margin),
        width: MediaQuery.of(context).size.width,
        height: 52,
        decoration: BoxDecoration(
            color: CustomColor.secondaryColor,
            borderRadius: BorderRadius.circular(12)),
        child: Center(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isIcon ? Icon(Icons.play_arrow_rounded) : SizedBox(),
            Text(
              label,
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ],
        )));
  }
}
