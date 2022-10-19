import 'package:flutter/material.dart';
import 'package:musiq/src/features/auth/provider/login_provider.dart';
import 'package:musiq/src/features/auth/provider/register_provider.dart';
import 'package:musiq/src/features/common/provider/bottom_navigation_bar_provider.dart';
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
            title: const Text("Profile"),
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
                                      children: [
                                        const AboutUsTextWidget(
                                          title: "Version :",
                                        ),
                                        const AboutUsTextWidget(
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
          // Navigation.navigateReplaceToScreen(context, RouteName.login);
       showAlertDialog(context);
          // Provider.of<LoginProvider>(context,listen: false).isShowStatus == fa;
        }
//           Provider.of<BottomNavigationBarProvider>(context,listen: false).indexes();
//          print(Provider.of<BottomNavigationBarProvider>(context,listen: false).indexes()
// );
//  Provider.of<BottomNavigationBarProvider>(context,listen: false).indexes();
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
      trailing: const Icon(
        Icons.arrow_forward_ios_rounded,
        size: 20,
      ),
      title: Text(
        ProfileProvider().profileContent[index].title,
        style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
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
showAlertDialog(BuildContext context) {  
 
  AlertDialog alert = AlertDialog(  
    backgroundColor:Color.fromRGBO(33, 33, 44, 1),
    title: Center(child: Text("Sign Out")),  
    
    content: Text("Are you sure you want to Sign Out?",style: TextStyle(fontSize: 12),),  
    actions: [  
      GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          height: getProportionateScreenHeight(44),
          width: getProportionateScreenWidth(120),
          child: Center(child: Text("Cancel")),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12),color: Color.fromRGBO(255, 255, 255, 0.1)),
        ),
      ) ,
       GestureDetector(
        onTap: () {
          Navigation.navigateReplaceToScreen(context, RouteName.login); 
      Provider.of<BottomNavigationBarProvider>(context,listen: false).indexes();
      Provider.of<RegisterProvider>(context,listen: false).clearError(); 
      Provider.of<RegisterProvider>(context,listen: false).isButtonEnable=true;       
        },
         child: Container(
          height: getProportionateScreenHeight(44),
          width: getProportionateScreenWidth(120),
          child: Center(child: Text("Confirm")),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12),color: Color.fromRGBO(254, 86, 49, 1)),
             ),
       ) ,
      SizedBox(width: getProportionateScreenWidth(5),)
    ],  
  );  
  
  
  showDialog(  
    context: context,  
    builder: (BuildContext context) {  
      return alert;  
    },  
  );  
}  
// 33, 33, 44, 1