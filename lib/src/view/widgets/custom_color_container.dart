import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../helpers/constants/color.dart';

class CustomColorContainer extends StatelessWidget {
  CustomColorContainer({
    Key? key,
    required this.child,
    this.bgColor,
    this.shape = BoxShape.rectangle,
    this.horizontalPadding = 0.0,
    this.verticalPadding = 0.0,
  }) : super(key: key);
  final Widget child;
  double horizontalPadding;
  double verticalPadding;
  var shape;
  var bgColor;
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding, vertical: verticalPadding),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
            borderRadius:
                shape == BoxShape.circle ? null : BorderRadius.circular(12),
            color: bgColor ?? Colors.transparent,
            shape: shape),
        child: child);
  }
}
