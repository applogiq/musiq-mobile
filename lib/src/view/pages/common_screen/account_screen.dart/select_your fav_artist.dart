import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:musiq/src/helpers/constants/images.dart';
import 'package:musiq/src/view/pages/home/home_screen.dart';
import 'package:musiq/src/view/pages/profile/components/artist_preference_screen.dart';
import 'package:musiq/src/view/widgets/custom_button.dart';

import '../../bottom_navigation_bar.dart';

class SelectYourFavList extends StatelessWidget {
  const SelectYourFavList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([
     SystemUiOverlay.top, //This line is used for showing the bottom bar
  ]);
    return Scaffold(
      appBar: AppBar(
        title: Text("Select your favourite artists"),
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SearchTextWidget(
                  onTap: () {},
                  hint: "Search Artists",
                ),
              ),
              Expanded(
                  child: ListView(
                shrinkWrap: true,
                children: [
                  CustomArtistVerticalList(
                    images: Images().artistPrefList,
                  ),
                ],
              ))
            ],
          ),
        InkWell(
          onTap: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => CustomBottomBar()));
          },
          child: CustomButton(label: "Save"))
        ],
      ),
      // bottomNavigationBar: InkWell(
      //     onTap: () {
      //       Navigator.of(context)
      //           .push(MaterialPageRoute(builder: (context) => HomePage()));
      //     },
      //     child: CustomButton(label: "Save")),
    );
  }
}
