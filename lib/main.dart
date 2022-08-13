import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:musiq/src/config/themes/theme.dart';
import 'package:musiq/src/helpers/routes/providers_route.dart';
import 'package:musiq/src/helpers/routes/route.dart';
import 'package:musiq/src/logic/binding/network_binding.dart';
import 'package:musiq/src/provider/splash_provider.dart';
import 'package:musiq/src/view/pages/artist_preference/artist_preference.dart';
import 'package:provider/provider.dart';

import 'src/view/pages/bottom_nav_bar/main_page.dart';
import 'src/view/pages/common_screen/splash_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
       ChangeNotifierProvider(create: (BuildContext context) =>SplashProvider(),),
      
    ],
     builder: (context,child){
        final splashProvider=Provider.of<SplashProvider>(context);
        return  MaterialApp(
          debugShowCheckedModeBanner: false
          ,
        theme:themeData(context),
        
        // home:loginProvider.isLogged?HomeScreen(): const LoginScreen(),
        home:splashProvider.isLogged?splashProvider.isArtistPreference? const MainPage():ArtistPreferenceMain(artist_list: [],): const SplashScreen(),
        routes: routes,
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
