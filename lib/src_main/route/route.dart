import 'package:flutter/material.dart';
import 'package:musiq/src/view/pages/artist_preference/artist_preference.dart';
import 'package:musiq/src_main/route/route_name.dart';
import 'package:musiq/src_main/screen/auth_screen/forgot_screen/forgot_main_screen.dart';
import 'package:musiq/src_main/screen/common_screen/onboarding_screen.dart';
import 'package:musiq/src_main/screen/common_screen/splash_screen.dart';
import 'package:musiq/src_main/widgets/text/forgot_password.dart';

import '../screen/auth_screen/login_screen.dart';
import '../screen/auth_screen/register_screen.dart';
import '../screen/common_screen/error_screen.dart';
import '../screen/home_screen/home_screen.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteName.login:
        return MaterialPageRoute(
            builder: (BuildContext context) => const LoginScreen());
      case RouteName.splash:
        return MaterialPageRoute(
            builder: (BuildContext context) => const SplashScreen());
      case RouteName.artistPreference:
        return MaterialPageRoute(
            builder: (BuildContext context) => ArtistPreferenceMain(
                  artist_list: [],
                ));
      case RouteName.forgotPassword:
        return MaterialPageRoute(
            builder: (BuildContext context) => ForgotPasswordMainScreen());
      case RouteName.onboarding:
        return MaterialPageRoute(
            builder: (BuildContext context) => OnboardingScreen());
      case RouteName.register:
        return MaterialPageRoute(
            builder: (BuildContext context) => const RegisterScreen());
      case RouteName.home:
        return MaterialPageRoute(
            builder: (BuildContext context) => HomeScreen());

      default:
        return MaterialPageRoute(
            builder: (BuildContext context) => const ErrorScreen());
    }
  }
}
