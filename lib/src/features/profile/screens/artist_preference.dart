import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:musiq/src/features/library/screens/playlist/view_playlist_screen.dart';
import 'package:provider/provider.dart';

import '../../../common_widgets/loader.dart';
import '../../artist/provider/artist_provider.dart';
import '../../artist/screens/artist_preference_screen/artist_preference_body.dart';
import '../../common/screen/offline_screen.dart';

class ProfileArtistPreferenceScreen extends StatefulWidget {
  const ProfileArtistPreferenceScreen({super.key});

  @override
  State<ProfileArtistPreferenceScreen> createState() =>
      _ProfileArtistPreferenceScreenState();
}

class _ProfileArtistPreferenceScreenState
    extends State<ProfileArtistPreferenceScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var provider =
          Provider.of<ArtistPreferenceProvider>(context, listen: false);
      provider.loadData([]);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Provider.of<InternetConnectionStatus>(context) ==
            InternetConnectionStatus.disconnected
        ? const OfflineScreen()
        : Scaffold(
            bottomNavigationBar: BottomMiniPlayer(),
            appBar: AppBar(
              automaticallyImplyLeading: true,
              title: const Text("Artist Preference"),
            ),
            body: Consumer<ArtistPreferenceProvider>(
              builder: (context, pro, _) {
                return !pro.isLoaded
                    ? const LoaderScreen()
                    : const ArtistPreferenceScreenBody(
                        artistList: [],
                      );
              },
            ),
          );
  }
}
