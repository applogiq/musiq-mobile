import 'package:flutter/material.dart';

import '../../view/pages/common_screen/account_screen.dart/on_boarding_screen.dart';
import 'package:musiq/src/view/pages/bottom_nav_bar/main_page.dart';
import 'package:musiq/src/view/pages/common_screen/account_screen.dart/pages/forgot/forgot_password_main_screen.dart';
import 'package:musiq/src/view/pages/common_screen/account_screen.dart/login_screen.dart';
import 'package:musiq/src/view/pages/common_screen/account_screen.dart/pages/forgot/forgot_password_otp_screen.dart';
import 'package:musiq/src/view/pages/common_screen/account_screen.dart/select_your%20fav_artist.dart';
import 'package:musiq/src/view/pages/common_screen/account_screen.dart/on_boarding_screen.dart';
import 'package:musiq/src/view/pages/common_screen/account_screen.dart/register_screen.dart';

import 'package:musiq/src/view/pages/home/home_screen.dart';
import 'package:musiq/src/view/pages/profile/components/artist_preference_screen.dart';
import 'package:musiq/src/view/pages/profile/components/audio_quality.dart';
import 'package:musiq/src/view/pages/profile/components/my_profile.dart';
import 'package:musiq/src/view/pages/profile/components/preference_screen.dart';

var routes={
          'onboarding/':(BuildContext ctx)=>OnboardingScreen(),
          'login/': (BuildContext ctx) => LoginScreen(),
          'register/': (BuildContext ctx) => RegisterScreen(),
          'bottom/': (BuildContext ctx) => MainPage(),
          // 'selectArtistPref/':(BuildContext ctx)=>SelectYourFavList(),
          'forgotMain/':(BuildContext ctx)=>ForgotPasswordMainScreen(),
          'forgotOTP/':(BuildContext ctx)=>OTPScreen(),
          // 'newPassword/':(BuildContext ctx)=>NewPasswordScreen(),

          'audioQuality': (BuildContext ctx) => AudioQualitySettingScreen(),
          'artistPreference': (BuildContext ctx) => ArtistPreferenceScreen(),
          'myProfile': (BuildContext ctx) => MyProfile(),
          'preferences': (BuildContext ctx) => PreferenceScreen(),
          'home/': (BuildContext ctx) => HomePage(),
        };