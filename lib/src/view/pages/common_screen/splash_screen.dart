import 'package:flutter/material.dart';
import 'package:musiq/src/view/pages/common_screen/account_screen.dart/components/logo_image.dart';
import '../../../constants/images.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Hero(tag: Images.heroImage, child: LogoWithImage()),
    ));
  }
}
