import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:musiq/src/common_widgets/buttons/custom_button.dart';
import 'package:musiq/src/common_widgets/container/empty_box.dart';
import 'package:musiq/src/common_widgets/loader.dart';
import 'package:musiq/src/core/enums/enums.dart';
import 'package:musiq/src/core/routing/route_name.dart';
import 'package:musiq/src/core/utils/navigation.dart';
import 'package:musiq/src/features/artist/provider/artist_provider.dart';
import 'package:musiq/src/features/artist/screens/artist_preference_screen/artist_preference_body.dart';
import 'package:musiq/src/features/common/screen/offline_screen.dart';
import 'package:musiq/src/features/search/provider/search_provider.dart';
import 'package:musiq/src/features/search/screens/search_screen.dart';
import 'package:provider/provider.dart';

class MusicArtistPreferenceScreen extends StatefulWidget {
  const MusicArtistPreferenceScreen({Key? key}) : super(key: key);

  @override
  State<MusicArtistPreferenceScreen> createState() =>
      _MusicArtistPreferenceScreenState();
}

class _MusicArtistPreferenceScreenState
    extends State<MusicArtistPreferenceScreen> {
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
        : SafeArea(
            child: Consumer<ArtistPreferenceProvider>(
                builder: (context, provider, _) {
              return !provider.isLoaded
                  ? const LoaderScreen()
                  : Scaffold(
                      appBar: PreferredSize(
                        preferredSize:
                            Size(MediaQuery.of(context).size.width, 80),
                        child: const ArtistPreferenceAppBarWidget(),
                      ),
                      body: const ArtistPreferenceScreenBody(
                        artistList: [],
                      ),
                      bottomNavigationBar: Consumer<ArtistPreferenceProvider>(
                          builder: (context, pro, _) {
                        return SizedBox(
                          child: pro.userFollowedArtist.length < 3
                              ? const EmptyBox()
                              : InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                    // pro.navigateToHome(context);
                                  },
                                  child: const CustomButton(
                                      label: "Back to preference screen")),
                        );
                      }));
            }),
          );
  }
}

class ArtistPreferenceAppBarWidget extends StatelessWidget {
  const ArtistPreferenceAppBarWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: 80,
      title: const Text("Select 3 or more of your \nfavourite artists"),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: GestureDetector(
            onTap: () {
              context.read<SearchProvider>().resetState();
              Navigation.navigateToScreen(context, RouteName.search,
                  args: SearchRequestModel(
                      searchStatus: SearchStatus.artistPreference));
            },
            child: Image.asset(
              "assets/icons/search.png",
              height: 18,
              width: 18,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
