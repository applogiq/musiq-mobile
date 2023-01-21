import 'package:flutter/material.dart';
import 'package:musiq/src/features/home/provider/artist_view_all_provider.dart';
import 'package:musiq/src/features/home/provider/view_all_provider.dart';
import 'package:musiq/src/features/library/provider/library_provider.dart';
import 'package:musiq/src/features/player/provider/player_provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../features/artist/provider/artist_provider.dart';
import '../features/auth/provider/login_provider.dart';
import '../features/auth/provider/new_password_provider.dart';
import '../features/auth/provider/register_provider.dart';
import '../features/common/provider/bottom_navigation_bar_provider.dart';
import '../features/common/provider/internet_connectivity_provider.dart';
import '../features/common/provider/splash_provider.dart';
import '../features/home/provider/home_provider.dart';
import '../features/profile/provider/profile_provider.dart';

List<SingleChildWidget> providersList = [
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
    create: (BuildContext context) => ArtistViewAllProvider(),
  ),
  ChangeNotifierProvider(
    create: (BuildContext context) => ViewAllProvider(),
  ),
];
