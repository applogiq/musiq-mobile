import 'package:flutter/material.dart';
import 'package:musiq/src/common_widgets/loader.dart';
import 'package:provider/provider.dart';

import '../../artist/provider/artist_provider.dart';
import '../../artist/screens/artist_preference_screen/artist_preference_body.dart';

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
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text("Artist Preference"),
      ),
      body: Consumer<ArtistPreferenceProvider>(builder: (context, pro, _) {
        return !pro.isLoaded
            ? const LoaderScreen()
            : ArtistPreferenceScreenBody(
                artist_list: const [],
              );
      }),
      // body: ArtistPreferenceScreenBody(
      //   artist_list: const [],
      // ),
    );
  }
}
