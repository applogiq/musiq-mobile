import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:musiq/src/features/common/provider/pop_up_provider.dart';
import 'package:musiq/src/features/payment/provider/payment_provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../features/artist/provider/artist_provider.dart';
import '../features/auth/provider/forgot_password_provider.dart';
import '../features/auth/provider/login_provider.dart';
import '../features/auth/provider/register_provider.dart';
import '../features/common/provider/bottom_navigation_bar_provider.dart';
import '../features/common/provider/splash_provider.dart';
import '../features/home/provider/artist_view_all_provider.dart';
import '../features/home/provider/home_provider.dart';
import '../features/home/provider/view_all_provider.dart';
import '../features/library/provider/library_provider.dart';
import '../features/player/provider/player_provider.dart';
import '../features/profile/provider/profile_provider.dart';
import '../features/search/provider/search_provider.dart';

List<SingleChildWidget> providersList = [
  StreamProvider(
    initialData: InternetConnectionStatus.connected,
    create: (_) {
      var iC = InternetConnectionChecker.createInstance(
        checkTimeout: const Duration(seconds: 5),
        checkInterval: const Duration(seconds: 5),
      );
      return iC.onStatusChange;
    },
  ),
  ChangeNotifierProvider(
    create: (BuildContext context) => SplashProvider(),
  ),
  ChangeNotifierProvider(
    create: (BuildContext context) => PopUpProvider(),
  ),
  // ChangeNotifierProvider(
  //   create: (BuildContext context) => InternetConnectivityProvider(),
  // ),
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
  ChangeNotifierProvider(
    create: (BuildContext context) => HomeProvider(),
  ),
  ChangeNotifierProvider(
    create: (BuildContext context) => LibraryProvider(),
  ),
  ChangeNotifierProvider(
    create: (BuildContext context) => PlayerProvider(),
  ),
  ChangeNotifierProvider(
    create: (BuildContext context) => PaymentProvider(),
  ),
  ChangeNotifierProvider(
    create: (BuildContext context) => ArtistViewAllProvider(),
  ),
  ChangeNotifierProvider(
    create: (BuildContext context) => ViewAllProvider(),
  ),
  ChangeNotifierProvider(
    create: (BuildContext context) => SearchProvider(),
  ),
];
