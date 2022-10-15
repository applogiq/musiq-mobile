import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common_widgets/buttons/custom_button.dart';
import '../../../constants/color.dart';
import '../../../constants/images.dart';
import '../../../constants/style.dart';
import '../../../routing/route_name.dart';
import '../../../utils/auth.dart';
import '../../../utils/navigation.dart';
import '../../../utils/size_config.dart';
import '../provider/profile_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 70,
            title: Text("Profile"),
          ),
          body: SingleChildScrollView(
            child: SizedBox(
              width: SizeConfig.screenWidth,
              height: SizeConfig.screenHeight - 120,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding:
                        EdgeInsets.only(top: getProportionateScreenHeight(24)),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage(
                        Images.user_default,
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(top: getProportionateScreenHeight(48)),
                    child: Column(
                      children: List.generate(
                          ProfileProvider().profileContent.length,
                          (index) => ProfileListTile(
                                index: index,
                              )),
                    ),
                  ),
                  Consumer<ProfileProvider>(builder: (context, provider, _) {
                    return Column(
                      children: [
                        ListTile(
                            onTap: () {
                              provider.aboutToggle();
                            },
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
                            trailing: provider.isAboutOpen
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
                        provider.isAboutOpen
                            ? Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 18),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
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
                            : SizedBox(),
                      ],
                    );
                  }),
                  Padding(
                    padding:
                        EdgeInsets.only(top: getProportionateScreenHeight(70)),
                    child: SignOutWidget(),
                  )
                ],
              ),
            ),
          )),
    );
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
          Navigation.navigateReplaceToScreen(context, RouteName.login);
        }

        print("SIGNOUT");
      },
      child: CustomButton(
        label: "Sign Out",
      ),
    );
  }
}

class ProfileListTile extends StatelessWidget {
  const ProfileListTile({
    Key? key,
    required this.index,
  }) : super(key: key);
  final int index;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.of(context)
            .pushNamed(ProfileProvider().profileContent[index].navigateScreen);
      },
      trailing: Icon(
        Icons.arrow_forward_ios_rounded,
        size: 20,
      ),
      title: Text(
        ProfileProvider().profileContent[index].title,
        style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
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
