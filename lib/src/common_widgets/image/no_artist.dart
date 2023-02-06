import 'package:flutter/material.dart';

import '../../core/constants/color.dart';
import '../../core/constants/images.dart';

class NoArtist extends StatelessWidget {
  const NoArtist({Key? key, this.height = 240, this.width = 200})
      : super(key: key);

  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: CustomColor.defaultCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CustomColor.defaultCardBorder, width: 2.0),
      ),
      child: Center(
        child: Image.asset(
          Images.noArtist,
          width: 113,
          height: 118,
        ),
      ),
    );
  }
}
