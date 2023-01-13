import 'package:flutter/material.dart';
import 'package:musiq/src/features/artist/provider/artist_provider.dart';
import 'package:musiq/src/features/artist/screens/artist_preference_screen/artist_preference_body.dart';
import 'package:provider/provider.dart';

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
      Provider.of<ArtistPreferenceProvider>(context, listen: false).loadData();
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
        body: ArtistPreferenceScreenBody(
          artist_list: const [],
        ));
  }
}
