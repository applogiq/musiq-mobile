import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:musiq/src/features/common/screen/offline_screen.dart';
import 'package:provider/provider.dart';

import '../../../../common_widgets/buttons/custom_button.dart';
import '../../../../common_widgets/container/empty_box.dart';
import '../../../../common_widgets/loader.dart';
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
    var provider =
        Provider.of<ArtistPreferenceProvider>(context, listen: false);
    provider.loadData([]);
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
                      body: ArtistPreferenceScreenBody(
                        artist_list: const [],
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
                                  child: CustomButton(label: "Save")),
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
            onTap: () {},
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
