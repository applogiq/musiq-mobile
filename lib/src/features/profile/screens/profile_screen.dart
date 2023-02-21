import 'dart:io';

import 'package:flutter/material.dart';
import 'package:musiq/src/features/payment/screen/subscription_screen.dart';
import 'package:musiq/src/features/profile/screens/my_profile_screen.dart';
import 'package:musiq/src/features/profile/screens/preference_screen.dart';
import 'package:provider/provider.dart';

import '../../../common_widgets/buttons/custom_button.dart';
import '../../../core/constants/color.dart';
import '../../../core/constants/images.dart';
import '../../../core/constants/style.dart';
import '../../../core/utils/size_config.dart';
import '../provider/profile_provider.dart';
import '../widgets/logout_dialog.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String imageUrl = "";
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<ProfileProvider>(context, listen: false)
          .getProfileDetails();

      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 70,
            title: const Text("Profile"),
          ),
          body: ListView(
            shrinkWrap: true,
            children: [
              Padding(
                padding: EdgeInsets.only(top: getProportionateScreenHeight(24)),
                child: Container(
                  height: 120,
                  width: 120,
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  child: Consumer<ProfileProvider>(builder: (context, pro, _) {
                    print("-------------->");
                    print(pro.imageUrl);
                    return pro.myProfileLoading
                        ? Center(
                            child: Image.asset(
                            'assets/gifs/image_loader2.gif',
                            height: 90,
                          ))
                        : pro.profileAPIModel.records == null
                            ? Image.asset(Images.userDefault)
                            : (pro.profileAPIModel.records!.isImage == true
                                ? CircleAvatar(
                                    backgroundColor: Colors.black,
                                    radius: 65,
                                    backgroundImage: const AssetImage(
                                        'assets/gifs/image_loader2.gif'),
                                    child: pro.imageUrl != null
                                        ? CircleAvatar(
                                            radius: 65,
                                            backgroundColor: Colors.transparent,
                                            backgroundImage: FileImage(
                                              File(pro.imageUrl!),
                                            ),
                                          )
                                        : const CircleAvatar(
                                            radius: 65,
                                            backgroundColor: Colors.white,
                                          ),
                                  )
                                : Image.asset(Images.userDefault));
                  }),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: getProportionateScreenHeight(48)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                      ProfileProvider().profileContent.length,
                      (index) => ProfileListTile(
                            index: index,
                          ))
                    ..add(
                      const Padding(
                        padding: EdgeInsets.only(left: 23),
                        child: AboutUsTextWidget(
                          title: "Free plan",
                        ),
                      ),
                    ),
                ),
              ),
              Consumer<ProfileProvider>(builder: (context, provider, _) {
                return Column(
                  children: [
                    ListTile(
                        onTap: () {
                          provider.aboutToggle();
                        },
                        title: const Text(
                          "About",
                          style: TextStyle(
                              fontWeight: FontWeight.w500, color: Colors.white),
                        ),
                        trailing: provider.isAboutOpen
                            ? const RotatedBox(
                                quarterTurns: 1,
                                child: Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 20,
                                ),
                              )
                            : const Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 20,
                              )),
                    provider.isAboutOpen
                        ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 18),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const AboutUsTextWidget(
                                  title: "Terms of use",
                                ),
                                const AboutUsTextWidget(
                                  title: "Privacy policy",
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: const [
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
                        : const SizedBox(),
                  ],
                );
              }),
              Padding(
                padding: EdgeInsets.only(top: getProportionateScreenHeight(70)),
                child: const SignOutWidget(),
              )
            ],
          )),
    );
  }
}

class SignOutWidget extends StatelessWidget {
  const SignOutWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        showAlertDialog(context);
      },
      child: const CustomButton(
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
      onTap: () async {
        var pro = context.read<ProfileProvider>();
        pro.removeMyProfileState();
        print(pro.profileContent[index].navigateScreen);
        if (index == 0) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const MyProfile()));
        } else if (index == 1) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const PreferenceScreen()));
        } else {
          // Navigator.of(context, rootNavigator: true).pushReplacement(
          //     MaterialPageRoute(
          //         builder: (context) => const SubscriptionsScreen()));

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const SubscriptionsScreen()));
        }
        // Navigation.navigateToScreen(context, "myProfile");
      },
      trailing: const Icon(
        Icons.arrow_forward_ios_rounded,
        size: 20,
      ),
      title: Text(
        ProfileProvider().profileContent[index].title,
        style:
            const TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
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
