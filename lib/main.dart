import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:musiq/src/helpers/constants/color.dart';
import 'package:musiq/src/helpers/themes/theme.dart';
import 'package:musiq/src/logic/cubit/forgot/cubit/forgotpassword_cubit.dart';
import 'package:musiq/src/view/pages/bottom_navigation_bar.dart';
import 'package:musiq/src/view/pages/common_screen/account_screen.dart/pages/forgot/forgot_password_main_screen.dart';
import 'package:musiq/src/view/pages/common_screen/account_screen.dart/login_screen.dart';
import 'package:musiq/src/view/pages/common_screen/account_screen.dart/pages/forgot/forgot_password_otp_screen.dart';
import 'package:musiq/src/view/pages/common_screen/account_screen.dart/pages/forgot/new_password.dart';
import 'package:musiq/src/view/pages/common_screen/account_screen.dart/select_your%20fav_artist.dart';
import 'package:musiq/src/view/pages/common_screen/account_screen.dart/on_boarding_screen.dart';
import 'package:musiq/src/view/pages/common_screen/account_screen.dart/register_screen.dart';
import 'package:musiq/src/view/pages/common_screen/splash_screen.dart';
import 'package:musiq/src/view/pages/home/components/pages/view_all_screen.dart';
import 'package:musiq/src/view/pages/home/home_screen.dart';
import 'package:musiq/src/view/pages/profile/components/artist_preference_screen.dart';
import 'package:musiq/src/view/pages/profile/components/audio_quality.dart';
import 'package:musiq/src/view/pages/profile/components/my_profile.dart';
import 'package:musiq/src/view/pages/profile/components/preference_screen.dart';

import 'src/logic/cubit/login_bloc.dart';
import 'src/logic/cubit/register/register_cubit.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
// FocusScope.of(context).requestFocus(FocusNode());
    return MultiBlocProvider(
       providers: [
          BlocProvider<LoginBloc>(create: (context) => LoginBloc()),
           BlocProvider<RegisterCubit>(create: (context) => RegisterCubit()),
           BlocProvider<ForgotpasswordCubit>(create: (context) => ForgotpasswordCubit()),
       ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: themeData(context),
        home: SplashScreen(),
        routes: {
          'onboarding/':(BuildContext ctx)=>OnboardingScreen(),
          'login/': (BuildContext ctx) => LoginScreen(),
          'register/': (BuildContext ctx) => RegisterScreen(),
          'selectArtistPref/':(BuildContext ctx)=>SelectYourFavList(),
          'forgotMain/':(BuildContext ctx)=>ForgotPasswordMainScreen(),
          'forgotOTP/':(BuildContext ctx)=>OTPScreen(),
          // 'newPassword/':(BuildContext ctx)=>NewPasswordScreen(),

          'audioQuality': (BuildContext ctx) => AudioQualitySettingScreen(),
          'artistPreference': (BuildContext ctx) => ArtistPreferenceScreen(),
          'myProfile': (BuildContext ctx) => MyProfile(),
          'preferences': (BuildContext ctx) => PreferenceScreen(),
          'home/': (BuildContext ctx) => HomePage(),
        },
      ),
    );
  }
}
