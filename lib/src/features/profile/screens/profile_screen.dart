import 'package:flutter/material.dart';
import 'package:musiq/src/constants/images.dart';
import 'package:musiq/src/features/profile/widgets/logout_dialog.dart';
import 'package:musiq/src/utils/image_url_generate.dart';
import 'package:provider/provider.dart';

import '../../../common_widgets/buttons/custom_button.dart';
import '../../../constants/color.dart';
import '../../../constants/style.dart';
import '../../../utils/size_config.dart';
import '../provider/profile_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Provider.of<ProfileProvider>(context, listen: false).getProfileDetails();
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
          body: SingleChildScrollView(
            child: SizedBox(
              width: SizeConfig.screenWidth,
              height: SizeConfig.screenHeight - 150,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding:
                        EdgeInsets.only(top: getProportionateScreenHeight(24)),
                    child: Container(
                      height: 120,
                      width: 120,
                      decoration: const BoxDecoration(shape: BoxShape.circle),
                      child:
                          Consumer<ProfileProvider>(builder: (context, pro, _) {
                        return pro.myProfileLoading
                            ? Center(
                                child: Image.asset(
                                'assets/gifs/image_loader2.gif',
                                height: 90,
                              ))
                            : pro.profileAPIModel.records == null
                                ? Image.asset(Images.user_default)
                                : (pro.profileAPIModel.records!.isImage == true
                                    ? CircleAvatar(
                                        backgroundColor: Colors.black,
                                        radius: 65,
                                        backgroundImage: const AssetImage(
                                            'assets/gifs/image_loader2.gif'),
                                        child: CircleAvatar(
                                          radius: 65,
                                          backgroundColor: Colors.transparent,
                                          backgroundImage: NetworkImage(
                                            generateProfileImageUrl(pro
                                                .profileAPIModel
                                                .records!
                                                .registerId),
                                          ),
                                        ),
                                      )
                                    :
                                    // ? CircleAvatar(
                                    //     radius: 50,
                                    //     child: Image.network(
                                    // generateProfileImageUrl(pro
                                    //     .profileAPIModel
                                    //     .records!
                                    //     .registerId),
                                    //       fit: BoxFit.cover,
                                    //       loadingBuilder: (BuildContext context,
                                    //           Widget child,
                                    //           ImageChunkEvent?
                                    //               loadingProgress) {
                                    //         if (loadingProgress == null) {
                                    //           return child;
                                    //         }
                                    //         return Center(
                                    //           child: CircularProgressIndicator(
                                    //             value: loadingProgress
                                    //                         .expectedTotalBytes !=
                                    //                     null
                                    //                 ? loadingProgress
                                    //                         .cumulativeBytesLoaded /
                                    //                     loadingProgress
                                    //                         .expectedTotalBytes!
                                    //                 : null,
                                    //           ),
                                    //         );
                                    //       },
                                    //     ),
                                    //   )

                                    Image.asset(Images.user_default));
                      }),
                      // radius: 50,
                      // backgroundImage: AssetImage(
                      //   Images.user_default,
                      // ),
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
                            title: const Text(
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 18),
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
                    padding:
                        EdgeInsets.only(top: getProportionateScreenHeight(70)),
                    child: const SignOutWidget(),
                  )
                ],
              ),
            ),
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
        context.read<ProfileProvider>().removeMyProfileState();
        Navigator.of(context)
            .pushNamed(ProfileProvider().profileContent[index].navigateScreen);
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


// 33, 33, 44, 1