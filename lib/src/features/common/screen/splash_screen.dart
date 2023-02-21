import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:musiq/src/features/common/screen/subscription_onboard.dart';
import 'package:provider/provider.dart';

import '../../../common_widgets/image/logo_image.dart';
import '../../../core/constants/images.dart';
import '../../../core/constants/local_storage_constants.dart';
import '../../../core/routing/route_name.dart';
import '../../../core/utils/navigation.dart';
import '../provider/splash_provider.dart';

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
    checkLogged(context);
  }

  checkLogged(BuildContext context) async {
    Map<String, String> localData = await storage.readAll();
    if (localData["access_token"] != null) {
      if (localData[LocalStorageConstant.isOnboardFree] == "true") {
        await context.read<SplashProvider>().checkLogged(context);
      } else {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const SubscriptionOnboard()));
      }
    } else {
      Navigation.navigateReplaceToScreen(context, RouteName.onboarding);
    }

    // await context.read<SplashProvider>().checkLogged(context);
    // Map<String, String> localData = await storage.readAll();
    // print("SPLASH");
    // await Future.delayed(const Duration(seconds: 2), () async {
    //   if (localData["access_token"] != null) {
    //     if (localData["is_image"] == "true") {
    //       objectbox.deleteImage();

    //       await loadImage(localData["register_id"]!);
    //     } else {
    //       objectbox.deleteImage();
    //     }

    //     if (localData["is_preference"] == "true") {
    //       if (localData[LocalStorageConstant.isOnboardFree] == "true") {
    //         Navigation.navigateReplaceToScreen(context, RouteName.mainScreen);
    //       } else {
    //         Navigator.of(context).push(MaterialPageRoute(
    //             builder: (context) => const SubscriptionOnboard()));
    //       }
    //     } else {
    //       Navigation.navigateReplaceToScreen(
    //           context, RouteName.artistPreference);
    //     }
    //   } else {
    //     Navigation.navigateReplaceToScreen(context, RouteName.onboarding);
    //   }
    // });
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
