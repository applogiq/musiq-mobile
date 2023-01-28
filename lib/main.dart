import 'dart:io';

import 'package:flutter/material.dart';
import 'package:musiq/src/config/theme.dart';
import 'package:musiq/src/core/provider_list.dart';
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

Future<void> main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providersList,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: themeData(context),
          initialRoute: RouteName.splash,
          onGenerateRoute: Routes.generateRoute,
        );
      },
    );
  }
}
