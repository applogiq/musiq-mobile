import 'package:flutter/material.dart';
import 'package:musiq/src/routing/route.dart';
import 'package:musiq/src/routing/route_name.dart';
import 'package:provider/provider.dart';

import 'config/theme.dart';
import 'core/provider_list.dart';

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
