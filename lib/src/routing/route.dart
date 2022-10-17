import 'package:flutter/material.dart';
import 'package:musiq/src/routing/route_name.dart';

import '../features/artist/screens/artist_preference_screen/artist_preference_screen.dart';
import '../features/auth/screens/forgot_screen/forgot_main_screen.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/register_screen.dart';
import '../features/common/screen/error_screen.dart';
import '../features/common/screen/main_screen.dart';
import '../features/common/screen/onboarding_screen.dart';
import '../features/common/screen/splash_screen.dart';
import '../features/home/screens/home_screen.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteName.login:
        return MaterialPageRoute(
            builder: (BuildContext context) => const LoginScreen());
      case RouteName.splash:
        return MaterialPageRoute(
            builder: (BuildContext context) => const SplashScreen());
      case RouteName.mainScreen:
        return MaterialPageRoute(
            builder: (BuildContext context) => MainScreen());
      case RouteName.artistPreference:
        return MaterialPageRoute(
            builder: (BuildContext context) => ArtistPreferenceScreen());
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
