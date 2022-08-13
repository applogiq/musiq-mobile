import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:musiq/src/logic/controller/artist_preference_controller.dart';
import 'package:musiq/src/view/pages/bottom_nav_bar/main_page.dart';
import 'package:musiq/src/view/pages/common_screen/offline_screen.dart';
import 'package:musiq/src/view/pages/home/components/widget/loader.dart';


import '../../../logic/controller/network_controller.dart';

import '../../../widgets/custom_button.dart';
import '../../../widgets/empty_box.dart';
import '../common_screen/account_screen.dart/select_your fav_artist.dart';
import 'artist_preference_body.dart';

class ArtistPreferenceMain extends StatelessWidget {
  ArtistPreferenceMain({Key? key, required this.artist_list}) : super(key: key);
  List? artist_list = [];

  @override
  Widget build(BuildContext context) {
    final NetworkController _networkController = Get.find<NetworkController>();
    final ArtistPreferenceController artistPreferenceController =
        Get.put(ArtistPreferenceController());
    artistPreferenceController.loadData(artist_list!);
    return Obx(() => _networkController.connectionType.value == 0
        ? OfflineScreen()
        : artistPreferenceController.isLoaded.value
            ? Scaffold(
                appBar: PreferredSize(
                  preferredSize: Size(MediaQuery.of(context).size.width, 80),
                  child: ArtistPreferenceAppBarWidget(),
                ),
                bottomNavigationBar:
                    artistPreferenceController.userFollowedArtist.length < 3
                        ? EmptyBox()
                        : InkWell(
                            onTap: () async {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) => MainPage()));
//             isLoad=true;
//             setState(() {
//               isLoad;
//             });
//             Future.delayed(Duration(seconds: 2),(){
// isLoad=false;
//             setState(() {
//               isLoad;
//             Navigator.of(context)
//                 .pushReplacement(MaterialPageRoute(builder: (context) => CustomBottomBar()));
//             });
//             });
                            },
                            child: CustomButton(label: "Save")),
                body: ArtistPreferenceScreenBody(
                  artist_list: artist_list,
                ),
              )
            : LoaderScreen());
  }
}
