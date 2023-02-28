import 'package:flutter/material.dart';

import '../../../core/constants/images.dart';

class FlashImageWidget extends StatelessWidget {
  const FlashImageWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFF23232D),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Image.asset(
          Images.flashImage,
          height: 24,
          width: 24,
        ),
      ),
    );
  }
}
