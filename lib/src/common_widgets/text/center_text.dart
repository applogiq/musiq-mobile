import 'package:flutter/material.dart';

import '../../core/constants/style.dart';

class CenterTextWidget extends StatelessWidget {
  const CenterTextWidget({
    Key? key,
    required this.label,
    required this.topPadding,
    required this.textSize,
    required this.textColor,
  }) : super(key: key);

  final String label;
  final Color textColor;
  final double textSize;
  final double topPadding;

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
