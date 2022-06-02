import 'package:flutter/material.dart';

import '../../helpers/constants/color.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key? key,
    required this.label,
  }) : super(key: key);
  final String label;
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(16),
        width: MediaQuery.of(context).size.width,
        height: 52,
        decoration: BoxDecoration(
            color: CustomColor.secondaryColor,
            borderRadius: BorderRadius.circular(12)),
        child: Center(
            child: Text(
          label,
          style: TextStyle(fontWeight: FontWeight.w500),
        )));
  }
}
