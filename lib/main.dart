import 'package:flutter/material.dart';
import 'package:musiq/src_main/config/themes/theme.dart';
import 'package:musiq/src_main/provider/forgot_password_provider.dart';
import 'package:musiq/src_main/provider/internet_connectivity_provider.dart';
import 'package:musiq/src_main/provider/login_provider.dart';
import 'package:musiq/src_main/provider/register_provider.dart';
import 'package:musiq/src_main/provider/splash_provider.dart';
import 'package:musiq/src_main/route/route.dart';
import 'package:musiq/src_main/route/route_name.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

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
      ],
      builder: (context, child) {
        final splashProvider = Provider.of<SplashProvider>(context);
        final networkProvider =
            Provider.of<InternetConnectivityProvider>(context);
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
