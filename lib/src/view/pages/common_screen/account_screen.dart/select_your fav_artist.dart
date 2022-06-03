import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:musiq/src/helpers/constants/images.dart';
import 'package:musiq/src/view/pages/home/home_screen.dart';
import 'package:musiq/src/view/pages/profile/components/artist_preference_screen.dart';
import 'package:musiq/src/view/widgets/custom_button.dart';

class SelectYourFavList extends StatelessWidget {
  const SelectYourFavList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select your favourite artists"),
      ),
      body: Column(
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
      bottomNavigationBar: InkWell(
          onTap: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => HomePage()));
          },
          child: CustomButton(label: "Save")),
    );
  }
}
