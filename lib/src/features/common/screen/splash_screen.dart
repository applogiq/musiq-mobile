import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../common_widgets/image/logo_image.dart';
import '../../../constants/images.dart';
import '../../../routing/route_name.dart';
import '../../../utils/navigation.dart';

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
          print("!323234");
          Navigation.navigateReplaceToScreen(
              context, RouteName.mainScreen);
        } else {
          Navigation.navigateReplaceToScreen(
              context, RouteName.artistPreference);
        }
      } else {
        print("object");
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
