import 'package:flutter/material.dart';

import '../../constants/style.dart';

class CenterTextWidget extends StatelessWidget {
  const CenterTextWidget({
    Key? key,
    required this.label,
    required this.topPadding,
    required this.textSize,
    required this.textColor,
  }) : super(key: key);
  final String label;
  final double topPadding;
  final double textSize;
  final Color textColor;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: topPadding),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: fontWeight500(size: textSize, color: textColor),
      ),
    );
  }
}
