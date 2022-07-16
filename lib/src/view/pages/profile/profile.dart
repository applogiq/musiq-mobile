import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:musiq/src/helpers/constants/color.dart';
import 'package:musiq/src/helpers/constants/images.dart';
import 'package:musiq/src/helpers/constants/style.dart';
import 'package:musiq/src/helpers/utils/image_url_generate.dart';
import 'package:musiq/src/helpers/utils/navigation.dart';
import 'package:musiq/src/logic/controller/profile_controller.dart';
import 'package:musiq/src/model/profile_model.dart';
import 'package:musiq/src/view/pages/profile/components/my_profile.dart';

import '../../../helpers/utils/auth.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/empty_box.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProfileController profileController = Get.put(ProfileController());
    profileController.loadProfile();
    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Obx(() {
            return profileController.isImage.value == true
                ? CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.transparent,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(60),
                      child: Image.network(
                        generateProfileImageUrl(
                            profileController.registerId.value),
                        height: 120,
                        width: 120,
                        fit: BoxFit.cover,
                        frameBuilder: (_, image, loadingBuilder, __) {
                          if (loadingBuilder == null) {
                            return const SizedBox(
                              height: 120,
                              child: Center(
                                  child: CircularProgressIndicator(
                                color: Colors.grey,
                              )),
                            );
                          }
                          return image;
                        },
                        loadingBuilder: (BuildContext context, Widget image,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) return image;
                          return SizedBox(
                            height: 120,
                            child: Center(
                              child: CircularProgressIndicator(
                                color: Colors.grey,
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            ),
                          );
                        },
                        errorBuilder: (_, __, ___) => Image.asset(
                          Images.user_default,
                          height: 120,
                          width: 120,
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    ),
                  )
                : CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage(
                      Images.user_default,
                    ),
                  );
          }),

          // Obx(() {
          //   return Container(
          //     margin: EdgeInsets.symmetric(vertical: size.height * 0.034),
          //     height: 120,
          //     width: 120,
          //     clipBehavior: Clip.antiAlias,
          //     decoration: BoxDecoration(
          //       shape: BoxShape.circle,
          //     ),
          //     child: profileController.isImage.value == true
          //         ? Image.network(
          // generateProfileImageUrl(
          //     profileController.registerId.value),
          //             fit: BoxFit.cover)
          //         : Image.asset(
          //             Images.user_default,
          //             fit: BoxFit.fitHeight,
          //           ),
          //   );
          // }),

          ProfileNavigationTile(profileController: profileController),
          ListTile(
            onTap: () {
              profileController.isAboutOpen.toggle();
              // Navigator.of(context).pushNamed(
              //     profileController.profileContent[index].navigateScreen);
            },
            trailing: Obx(() => profileController.isAboutOpen.value
                ? RotatedBox(
                    quarterTurns: 1,
                    child: Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 20,
                    ),
                  )
                : Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 20,
                  )),
            title: Text(
              "About",
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color:
                      //  profileController.profileContent[index].isHighLight
                      //     ? CustomColor.secondaryColor
                      //     :
                      Colors.white),
            ),
          ),
          Obx(() => profileController.isAboutOpen.value
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Column(
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
                )
              : EmptyBox()),
          SizedBox(
            height: size.height * 0.12,
          ),
          SignOutWidget(),
          // ListView.builder(
          //     physics: BouncingScrollPhysics(),
          //     shrinkWrap: true,
          //     itemBuilder: (context, index) {
          //       return ListTile(
          //         onTap: () {
          //           Navigator.of(context)
          //               .pushNamed(profileController.profileContent[index].navigateScreen);
          //         },
          //         trailing: profileController.profileContent[index].isArrow
          //             ? Icon(
          //                 Icons.arrow_forward_ios_rounded,
          //                 size: 20,
          //               )
          //             : Container(height: 0, width: 0),
          //         title: Text(
          //           profileController.profileContent[index].title,
          //           style: TextStyle(
          //               fontWeight: FontWeight.w500,
          //               color: profileController.profileContent[index].isHighLight
          //                   ? CustomColor.secondaryColor
          //                   : Colors.white),
          //         ),
          //       );
          //     },
          //     itemCount:profileController. profileContent.length),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 18),
          //   child: Column(
          //     // mainAxisAlignment: MainAxisAlignment.start
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       AboutUsTextWidget(
          //         title: "Terms of use",
          //       ),
          //       AboutUsTextWidget(
          //         title: "Privacy policy",
          //       ),
          //       Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //         children: [
          //           AboutUsTextWidget(
          //             title: "Version :",
          //           ),
          //           AboutUsTextWidget(
          //             title: "2.30.23",
          //           ),
          //         ],
          //       ),
          //     ],
          //   ),
          // ),
        ]),
      ),
    );
  }
}

class ProfileNavigationTile extends StatelessWidget {
  const ProfileNavigationTile({
    Key? key,
    required this.profileController,
  }) : super(key: key);

  final ProfileController profileController;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () {
              Navigator.of(context).pushNamed(
                  profileController.profileContent[index].navigateScreen);
            },
            trailing: profileController.profileContent[index].isArrow
                ? Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 20,
                  )
                : Container(height: 0, width: 0),
            title: Text(
              profileController.profileContent[index].title,
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: profileController.profileContent[index].isHighLight
                      ? CustomColor.secondaryColor
                      : Colors.white),
            ),
          );
        },
        itemCount: profileController.profileContent.length);
  }
}

class SignOutWidget extends StatelessWidget {
  SignOutWidget({
    Key? key,
  }) : super(key: key);
  Auth auth = Auth();
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        var isLog = await auth.logOut();
        print(isLog.toString());
        if (isLog) {
          Navigation.navigateReplaceToScreen(context, "login/");
        }
        print("SIGNOUT");
      },
      child: CustomButton(
        label: "Sign Out",
      ),
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
