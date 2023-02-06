import 'package:flutter/material.dart';

import '../../core/constants/images.dart';

class LogoWithImage extends StatelessWidget {
  const LogoWithImage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      Images.logoImageWithName,
      height: 90,
    );
  }
}

class LogoWidget extends StatelessWidget {
  const LogoWidget({
    Key? key,
    required this.size,
  }) : super(key: key);

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      width: size,
      child: Center(
        child: Image.asset(
          Images.logoImage,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
