import 'package:flutter/material.dart';
import 'package:musiq/src_main/provider/artist_provider.dart';
import 'package:musiq/src_main/screen/artist_preference_screen/artist_preference_body.dart';
import 'package:musiq/src_main/widgets/buttons/custom_button.dart';
import 'package:musiq/src_main/widgets/container/empty_box.dart';
import 'package:musiq/src_main/widgets/loader.dart';
import 'package:provider/provider.dart';

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
                bottomNavigationBar: 4 < 3
                    ? EmptyBox()
                    : InkWell(
                        onTap: () async {
                          // Navigator.of(context).pushReplacement(
                          //     MaterialPageRoute(
                          //         builder: (context) => MainPage()));
                        },
                        child: CustomButton(label: "Save")),
              );
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
