import 'package:flutter/material.dart';
class CustomColorContainer extends StatelessWidget {
  CustomColorContainer({
    Key? key,
    required this.child,
    this.bgColor,
    this.shape = BoxShape.rectangle,
    this.left = 0.0,
    this.right = 0.0,
    this.verticalPadding = 0.0,
  }) : super(key: key);
  final Widget child;
  double left;
  double right;
  double verticalPadding;
  var shape;
  var bgColor;
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(
            top: verticalPadding,bottom: verticalPadding,left: left,right: right),
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
            borderRadius:
                shape == BoxShape.circle ? null : BorderRadius.circular(12),
            color: bgColor ?? Colors.transparent,
            shape: shape),
        child: child);
  }
}
