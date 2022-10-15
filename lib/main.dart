import 'dart:io';

import 'package:flutter/material.dart';
import 'package:musiq/src/config/themes/theme.dart';
import 'package:musiq/src/features/artist/provider/artist_provider.dart';
import 'package:musiq/src/features/auth/provider/forgot_password_provider.dart';
import 'package:musiq/src/features/auth/provider/login_provider.dart';
import 'package:musiq/src/features/auth/provider/register_provider.dart';
import 'package:musiq/src/features/common/provider/bottom_navigation_bar_provider.dart';
import 'package:musiq/src/features/common/provider/internet_connectivity_provider.dart';
import 'package:musiq/src/features/common/provider/splash_provider.dart';
import 'package:musiq/src/features/profile/provider/profile_provider.dart';
import 'package:musiq/src/routing/route.dart';
import 'package:musiq/src/routing/route_name.dart';
import 'package:provider/provider.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (BuildContext context) => SplashProvider(),
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) => InternetConnectivityProvider(),
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) => RegisterProvider(),
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) => LoginProvider(),
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) => ForgotPasswordProvider(),
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) => BottomNavigationBarProvider(),
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) => ProfileProvider(),
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) => ArtistPreferenceProvider(),
        ),
      ],
      builder: (context, child) {
        // final splashProvider = Provider.of<SplashProvider>(context);
        // final networkProvider =
        //     Provider.of<InternetConnectivityProvider>(context);
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: themeData(context),
          initialRoute: RouteName.splash,
          onGenerateRoute: Routes.generateRoute,
          // home: networkProvider.isNetworkAvailable
          //     ? Builder(
          //         builder: (_) {
          //           if (splashProvider.status == "splash") {
          //             return SplashScreen();
          //           } else if (splashProvider.status == "home") {
          //             return MainPage();
          //           } else {
          //             return OnboardingScreen();
          //           }
          //         },
          //       )
          //     : OfflineScreen(),
          // routes: routes,
        );
      },
    );
    // return MultiBlocProvider(
    //   providers: blocProvidersRoute,
    //   child: GetMaterialApp(
    //     initialBinding: NetworkBinding(),
    //     debugShowCheckedModeBanner: false,
    //     theme: themeData(context),
    //     home: SplashScreen(),
    //     routes: routes,
    //   ),
    // );
  }
}
