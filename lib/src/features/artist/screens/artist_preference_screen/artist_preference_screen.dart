import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:musiq/src/features/search/provider/search_provider.dart';
import 'package:provider/provider.dart';

import '../../../../common_widgets/buttons/custom_button.dart';
import '../../../../common_widgets/container/empty_box.dart';
import '../../../../common_widgets/loader.dart';
import '../../../../enums/search_status.dart';
import '../../../../routing/route_name.dart';
import '../../../../utils/navigation.dart';
import '../../../common/screen/offline_screen.dart';
import '../../../search/screens/search_screen.dart';
import '../../provider/artist_provider.dart';
import 'artist_preference_body.dart';

class ArtistPreferenceScreen extends StatefulWidget {
  const ArtistPreferenceScreen({Key? key}) : super(key: key);

  @override
  State<ArtistPreferenceScreen> createState() => _ArtistPreferenceScreenState();
}

class _ArtistPreferenceScreenState extends State<ArtistPreferenceScreen> {
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
                                    pro.navigateToHome(context);
                                  },
                                  child: const CustomButton(label: "Save")),
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
