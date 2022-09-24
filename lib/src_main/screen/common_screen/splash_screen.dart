import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:musiq/src/view/pages/bottom_nav_bar/main_page.dart';
import 'package:musiq/src/view/pages/common_screen/account_screen.dart/components/logo_image.dart';
import 'package:musiq/src_main/helpers/utils/navigation.dart';
import 'package:musiq/src_main/provider/splash_provider.dart';
import 'package:musiq/src_main/route/route_name.dart';
import 'package:musiq/src_main/screen/home_screen/home_screen.dart';
import 'package:musiq/src_main/screen/main_screen.dart';
import 'package:provider/provider.dart';

import '../../constants/images.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final storage = const FlutterSecureStorage();
  @override
  void initState() {
    super.initState();
    checkLogged();
  }

  checkLogged() async {
    Map<String, String> localData = await storage.readAll();

    await Future.delayed(Duration(seconds: 3), () {
      if (localData["access_token"] != null) {
        if (localData["is_preference"] == "true") {
          Navigation.navigateReplaceToScreen(context, RouteName.mainScreen);
        } else {
          Navigation.navigateReplaceToScreen(
              context, RouteName.artistPreference);
        }
      } else {
        Navigation.navigateReplaceToScreen(context, RouteName.onboarding);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Hero(tag: Images.heroImage, child: const LogoWithImage()),

      // }),
    ));
  }
}
