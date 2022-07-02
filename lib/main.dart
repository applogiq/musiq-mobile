import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:musiq/src/helpers/routes/providers_route.dart';
import 'package:musiq/src/helpers/routes/route.dart';
import 'package:musiq/src/helpers/themes/theme.dart';
import 'package:musiq/src/logic/binding/network_binding.dart';

import 'src/view/pages/common_screen/splash_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
// FocusScope.of(context).requestFocus(FocusNode());
    return MultiBlocProvider(
       providers:blocProvidersRoute,
      child: GetMaterialApp(
        initialBinding: NetworkBinding(),
        debugShowCheckedModeBanner: false,
        theme: themeData(context),
        home: SplashScreen(),
        routes: routes,
      ),
    );
  }
}
