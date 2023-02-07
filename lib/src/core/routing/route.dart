import 'package:flutter/material.dart';

import '../../features/artist/screens/artist_preference_screen/artist_preference_screen.dart';
import '../../features/auth/screens/forgot_screen/forgot_main_screen.dart';
import '../../features/auth/screens/forgot_screen/forgot_otp_screen.dart';
import '../../features/auth/screens/forgot_screen/new_password.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/register_screen.dart';
import '../../features/common/screen/error_screen.dart';
import '../../features/common/screen/main_screen.dart';
import '../../features/common/screen/onboarding_screen.dart';
import '../../features/common/screen/splash_screen.dart';
import '../../features/home/domain/model/artist_view_all_model.dart';
import '../../features/home/screens/artist_view_all/artist_view_all_screen.dart';
import '../../features/home/screens/artist_view_all/artist_view_all_song_list_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/home/screens/view_all/view_all_song_list_screen.dart';
import '../../features/library/screens/library.dart';
import '../../features/player/screen/add_playlist_screen.dart';
import '../../features/player/screen/player_screen/player_screen.dart';
import '../../features/player/screen/song_info_screen.dart';
import '../../features/profile/screens/artist_preference.dart';
import '../../features/profile/screens/image_crop_screen.dart';
import '../../features/profile/screens/my_profile_screen.dart';
import '../../features/profile/screens/preference_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../features/search/screens/search_screen.dart';
import '../enums/view_all_status.dart';
import 'route_name.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case RouteName.login:
        return MaterialPageRoute(
            builder: (BuildContext context) => const LoginScreen());
      case RouteName.splash:
        return MaterialPageRoute(
            builder: (BuildContext context) => const SplashScreen());
      case RouteName.mainScreen:
        return MaterialPageRoute(
            builder: (BuildContext context) => const MainScreen());
      case RouteName.artistPreference:
        return MaterialPageRoute(
            builder: (BuildContext context) => const ArtistPreferenceScreen());
      case RouteName.forgotPassword:
        return MaterialPageRoute(
            builder: (BuildContext context) =>
                const ForgotPasswordMainScreen());
      case RouteName.onboarding:
        return MaterialPageRoute(
            builder: (BuildContext context) => const OnboardingScreen());
      case RouteName.register:
        return MaterialPageRoute(
            builder: (BuildContext context) => const RegisterScreen());
      case RouteName.home:
        return MaterialPageRoute(
            builder: (BuildContext context) => const HomeScreen());
      case RouteName.myProfile:
        return MaterialPageRoute(
            builder: (BuildContext context) => const MyProfile());
      case RouteName.preference:
        return MaterialPageRoute(
            builder: (BuildContext context) => const PreferenceScreen());
      case RouteName.library:
        return MaterialPageRoute(
            builder: (BuildContext context) => const LibraryScreen());
      case RouteName.addPlaylist:
        if (args is String) {
          return MaterialPageRoute(
              builder: (BuildContext context) => AddToPlaylistScreen(
                    songId: int.parse(args),
                  ));
        }
        return MaterialPageRoute(
            builder: (BuildContext context) => const ErrorScreen());

      case RouteName.forgotPasswordOTP:
        return MaterialPageRoute(
            builder: (BuildContext context) => const OTPScreen());
      case RouteName.forgotPasswordChangePassword:
        return MaterialPageRoute(
            builder: (BuildContext context) => const NewPasswordScreen());
      case RouteName.crop:
        return MaterialPageRoute(
            builder: (BuildContext context) => const ImageCrop());
      case RouteName.search:
        if (args is SearchRequestModel) {
          return MaterialPageRoute(
              builder: (BuildContext context) => SearchScreen(
                    searchRequestModel: args,
                  ));
        }
        return MaterialPageRoute(
            builder: (BuildContext context) => const ErrorScreen());
      case RouteName.profile:
        return MaterialPageRoute(
            builder: (BuildContext context) => const ProfileScreen());
      case RouteName.profileArtistPreference:
        return MaterialPageRoute(
            builder: (BuildContext context) =>
                const ProfileArtistPreferenceScreen());
      case RouteName.artistViewAllScreen:
        return MaterialPageRoute(
            builder: (BuildContext context) => const ArtistViewAllScreen());
      case RouteName.player:
        // if (args is PlayerModel) {
        return MaterialPageRoute(
            builder: (BuildContext context) => const PlayerScreen(
                // playerModel: args,
                ));
      // }
      // return MaterialPageRoute(
      //     builder: (BuildContext context) => const ErrorScreen());

      case RouteName.songInfo:
        if (args is int) {
          return MaterialPageRoute(
              builder: (BuildContext context) => SongInfoScreen(
                    id: args,
                  ));
        }
        return MaterialPageRoute(
            builder: (BuildContext context) => const ErrorScreen());

      case RouteName.artistViewAllSongListScreen:
        if (args is ArtistViewAllModel) {
          return MaterialPageRoute(
              builder: (BuildContext context) => ArtistViewAllSongListScreen(
                    artistViewAllModel: args,
                  ));
        }

        return MaterialPageRoute(
            builder: (BuildContext context) => const ErrorScreen());
      case RouteName.viewAllScreen:
        if (args is ViewAllStatus) {
          return MaterialPageRoute(
              builder: (BuildContext context) => ViewAllSongListScreen(
                    status: args,
                  ));
        }

        return MaterialPageRoute(
            builder: (BuildContext context) => const ErrorScreen());

      default:
        return MaterialPageRoute(
            builder: (BuildContext context) => const ErrorScreen());
    }
  }
}
