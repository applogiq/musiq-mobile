import 'package:flutter/material.dart';
import 'package:musiq/src/routing/route_name.dart';
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
    // TODO: implement initState
    super.initState();
    var provider =
        Provider.of<ArtistPreferenceProvider>(context, listen: false);
    provider.loadData([]);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child:
          Consumer<ArtistPreferenceProvider>(builder: (context, provider, _) {
        return !provider.isLoaded
            ? LoaderScreen()
            : Scaffold(
                appBar: PreferredSize(
                  preferredSize: Size(MediaQuery.of(context).size.width, 80),
                  child: ArtistPreferenceAppBarWidget(),
                ),
                body: ArtistPreferenceScreenBody(
                  artist_list: [],
                ),
                bottomNavigationBar: Consumer<ArtistPreferenceProvider>(
                    builder: (context, pro, _) {
                  return SizedBox(
                    child: pro.userFollowedArtist.length < 3
                        ? EmptyBox()
                        : InkWell(
                            onTap: () async {
                              Navigator.of(context)
                                  .pushReplacementNamed(RouteName.mainScreen);
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
      title: Text("Select 3 or more of your \nfavourite artists"),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: GestureDetector(
            onTap: () {
              // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>SearchScreen()));
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
