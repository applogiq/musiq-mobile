import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:musiq/src/helpers/constants/color.dart';
import 'package:musiq/src/helpers/constants/style.dart';
import 'package:musiq/src/model/profile_model.dart';
import 'package:musiq/src/view/pages/profile/components/my_profile.dart';

import '../../widgets/custom_button.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({Key? key}) : super(key: key);
  List<ProfileModel> profileContent = [
    ProfileModel(
        title: "My Profile", isArrow: true, navigateScreen: "myProfile"),
    ProfileModel(
        title: "Preferences", isArrow: true, navigateScreen: "preferences"),
    ProfileModel(
        title: "Contact us", isArrow: true, navigateScreen: "myProfile"),
    ProfileModel(title: "About", isArrow: false, navigateScreen: "myProfile"),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: ListView(shrinkWrap: true, children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 34),
          height: 120,
          width: 120,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: Image.network(
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQOvIuFVvPFU596919Aj3EZMWryh0BAgjXX16N1kBboyn9Algcsl_hdUApl6j8qBcTE2nI&usqp=CAU",
            fit: BoxFit.fitHeight,
          ),
        ),
        ListView.builder(
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return ListTile(
                onTap: () {
                  Navigator.of(context)
                      .pushNamed(profileContent[index].navigateScreen);
                },
                trailing: profileContent[index].isArrow
                    ? Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 20,
                      )
                    : Container(height: 0, width: 0),
                title: Text(
                  profileContent[index].title,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: profileContent[index].isHighLight
                          ? CustomColor.secondaryColor
                          : Colors.white),
                ),
              );
            },
            itemCount: profileContent.length),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.start
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AboutUsTextWidget(
                title: "Terms of use",
              ),
              AboutUsTextWidget(
                title: "Privacy policy",
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AboutUsTextWidget(
                    title: "Version :",
                  ),
                  AboutUsTextWidget(
                    title: "2.30.23",
                  ),
                ],
              ),
            ],
          ),
        ),
        CustomButton(
          label: "Sign Out",
        )
      ]),
    );
  }
}

class AboutUsTextWidget extends StatelessWidget {
  const AboutUsTextWidget({
    Key? key,
    required this.title,
  }) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: fontWeight500(size: 14.0, color: CustomColor.playIconBg),
    );
  }
}
