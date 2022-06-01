import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:musiq/src/helpers/constants/color.dart';
import 'package:musiq/src/model/profile_model.dart';
import 'package:musiq/src/view/pages/profile/components/my_profile.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({Key? key}) : super(key: key);
  List<ProfileModel> profileContent = [
    ProfileModel(
        title: "My Profile", isArrow: true, navigateScreen: "myProfile"),
    ProfileModel(
        title: "Preferences", isArrow: true, navigateScreen: "preferences"),
    ProfileModel(title: "About", navigateScreen: "myProfile"),
    ProfileModel(
        title: "Sign out", isHighLight: true, navigateScreen: "myProfile"),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(children: [
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
                fit: BoxFit.cover,
              ),
            ),
            ListView.separated(
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
                        : SizedBox(height: 0, width: 0),
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
                separatorBuilder: (context, index) {
                  return Divider(
                    height: 1,
                  );
                },
                itemCount: profileContent.length)
            // ListTile(
            //   title: Text("My Profile"),
            //   trailing: Icon(Icons.arrow_forward_ios),
            // ),
            // ListTile(
            //   title: Text("Preferences"),
            //   trailing: Icon(Icons.arrow_forward_ios),
            // ),
            // ListTile(
            //   title: Text("About"),
            // ),

            // ListTile(
            //   title: Text(
            //     "Sign out",
            //     style: TextStyle(color: CustomColor.secondaryColor),
            //   ),
            // )
          ]),
        ),
      ),
    );
  }
}
