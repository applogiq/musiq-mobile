import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:musiq/src/helpers/constants/color.dart';
import 'package:musiq/src/helpers/themes/theme.dart';
import 'package:musiq/src/view/pages/bottom_navigation_bar.dart';
import 'package:musiq/src/view/pages/common_screen/splash_screen.dart';
import 'package:musiq/src/view/pages/profile/components/artist_preference_screen.dart';
import 'package:musiq/src/view/pages/profile/components/audio_quality.dart';
import 'package:musiq/src/view/pages/profile/components/my_profile.dart';
import 'package:musiq/src/view/pages/profile/components/preference_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: themeData(context),
      home: SplashScreen(),
      routes: {
        'audioQuality': (BuildContext ctx) => AudioQualitySettingScreen(),
        'artistPreference': (BuildContext ctx) => ArtistPreferenceScreen(),
        'myProfile': (BuildContext ctx) => MyProfile(),
        'preferences': (BuildContext ctx) => PreferenceScreen(),
        // 'about': (BuildContext ctx) => PageC(),
      },
    );
  }
}
