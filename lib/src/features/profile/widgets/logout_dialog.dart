// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:musiq/src/common_widgets/box/vertical_box.dart';
import 'package:musiq/src/common_widgets/buttons/custom_button.dart';
import 'package:musiq/src/core/constants/images.dart';
import 'package:musiq/src/core/utils/auth.dart';
import 'package:musiq/src/core/utils/navigation.dart';
import 'package:musiq/src/core/utils/size_config.dart';
import 'package:musiq/src/features/auth/provider/register_provider.dart';
import 'package:musiq/src/features/common/screen/onboarding_screen.dart';
import 'package:musiq/src/features/library/widgets/favourite/alert_packages/show_dialog_package.dart';
import 'package:musiq/src/features/payment/provider/payment_provider.dart';
import 'package:musiq/src/features/player/provider/player_provider.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/constant.dart';

showAlertDialog(BuildContext context) {
  showAnimatedDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: const Color.fromRGBO(33, 33, 44, 1),
        title: const Center(child: Text("Sign Out")),
        content: const Text(
          "Are you sure you want to Sign Out?",
          style: TextStyle(fontSize: 12),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              height: getProportionateScreenHeight(44),
              width: getProportionateScreenWidth(120),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: const Color.fromRGBO(255, 255, 255, 0.1)),
              child: const Center(child: Text("Cancel")),
            ),
          ),
          GestureDetector(
            onTap: () async {
              Auth auth = Auth();
              await auth.logOut(context);
              await context.read<PlayerProvider>().removeAllData();
              await context.read<PlayerProvider>().playlist.clear();
              context.read<PlayerProvider>().inQueue = false;

              Provider.of<RegisterProvider>(context, listen: false)
                  .clearError();
              Provider.of<RegisterProvider>(context, listen: false)
                  .isButtonEnable = true;
              await Navigation.removeAllScreenFromStack(
                  context, const OnboardingScreen());
              // context.read<HomeProvider>().goToHome(context);
            },
            child: Container(
              height: getProportionateScreenHeight(44),
              width: getProportionateScreenWidth(120),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: const Color.fromRGBO(254, 86, 49, 1)),
              child: const Center(child: Text("Confirm")),
            ),
          ),
          SizedBox(
            width: getProportionateScreenWidth(5),
          )
        ],
      );
    },
    animationType: DialogTransitionType.slideFromLeft,
    curve: Curves.fastOutSlowIn,
    // duration: const Duration(seconds: 1),
  );
  // showDialog(
  //   context: context,
  //   builder: (BuildContext context) {
  //     return AlertDialog(
  //       backgroundColor: const Color.fromRGBO(33, 33, 44, 1),
  //       title: const Center(child: Text("Sign Out")),
  //       content: const Text(
  //         "Are you sure you want to Sign Out?",
  //         style: TextStyle(fontSize: 12),
  //       ),
  //       actions: [
  //         GestureDetector(
  //           onTap: () {
  //             Navigator.pop(context);
  //           },
  //           child: Container(
  //             height: getProportionateScreenHeight(44),
  //             width: getProportionateScreenWidth(120),
  //             decoration: BoxDecoration(
  //                 borderRadius: BorderRadius.circular(12),
  //                 color: const Color.fromRGBO(255, 255, 255, 0.1)),
  //             child: const Center(child: Text("Cancel")),
  //           ),
  //         ),
  //         GestureDetector(
  //           onTap: () async {
  //             Auth auth = Auth();
  //             await auth.logOut(context);
  //             await context.read<PlayerProvider>().removeAllData();
  //             await context.read<PlayerProvider>().playlist.clear();
  //             context.read<PlayerProvider>().inQueue = false;

  //             Provider.of<RegisterProvider>(context, listen: false)
  //                 .clearError();
  //             Provider.of<RegisterProvider>(context, listen: false)
  //                 .isButtonEnable = true;
  //             await Navigation.removeAllScreenFromStack(
  //                 context, const OnboardingScreen());
  //             // context.read<HomeProvider>().goToHome(context);
  //           },
  //           child: Container(
  //             height: getProportionateScreenHeight(44),
  //             width: getProportionateScreenWidth(120),
  //             decoration: BoxDecoration(
  //                 borderRadius: BorderRadius.circular(12),
  //                 color: const Color.fromRGBO(254, 86, 49, 1)),
  //             child: const Center(child: Text("Confirm")),
  //           ),
  //         ),
  //         SizedBox(
  //           width: getProportionateScreenWidth(5),
  //         )
  //       ],
  //     );
  //   },
  // );
}

showSubscriptionDialog(BuildContext context) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12.0))),
          insetPadding: const EdgeInsets.all(16.0),
          contentPadding: const EdgeInsets.all(0.0),
          backgroundColor: const Color.fromRGBO(33, 33, 44, 1),
          title: Image.asset(
            Images.subscription,
            width: 209,
          ),
          content: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const VerticalBox(height: 24),
                Text(
                  ConstantText.subscriptionExpired,
                  textAlign: TextAlign.center,
                  style: fontWeight600(size: 18.0),
                ),
                const VerticalBox(height: 8),
                Text(
                  ConstantText.subscriptionExpiredContent,
                  textAlign: TextAlign.center,
                  style: fontWeight400(size: 12.0, color: CustomColor.subTitle),
                ),
                const VerticalBox(height: 24),
                GestureDetector(
                    onTap: () {
                      context
                          .read<PaymentProvider>()
                          .viewPlanSubscription(context);
                    },
                    child: const CustomButton(label: ConstantText.viewPlans)),
                InkWell(
                  onTap: () {
                    context
                        .read<PaymentProvider>()
                        .continueWithFreePlanSubscription(context,
                            isFromDialog: true);
                    // Navigation.navigateToScreen(context, navigationString);
                    // Provider.of<LoginProvider>(context, listen: false).isErr();
                  },
                  child: Text(
                    ConstantText.continueWithFreePlan,
                    style: fontWeight500(size: 14.0, color: Colors.red),
                  ),
                ),
              ],
            ),
          ),
          // content: const Text(
          //   "Are you sure you want to Sign Out?",
          //   style: TextStyle(fontSize: 12),
          // ),
          // actions: [
          //   GestureDetector(
          //     onTap: () {
          //       Navigator.pop(context);
          //     },
          //     child: Container(
          //       height: getProportionateScreenHeight(44),
          //       width: getProportionateScreenWidth(120),
          //       decoration: BoxDecoration(
          //           borderRadius: BorderRadius.circular(12),
          //           color: const Color.fromRGBO(255, 255, 255, 0.1)),
          //       child: const Center(child: Text("Cancel")),
          //     ),
          //   ),
          //   GestureDetector(
          //     onTap: () async {
          //       Auth auth = Auth();
          //       await auth.logOut();
          //       context.read<PlayerProvider>().removeAllData();

          //       Provider.of<RegisterProvider>(context, listen: false)
          //           .clearError();
          //       Provider.of<RegisterProvider>(context, listen: false)
          //           .isButtonEnable = true;
          //       await Navigation.removeAllScreenFromStack(
          //           context, const OnboardingScreen());
          //     },
          //     child: Container(
          //       height: getProportionateScreenHeight(44),
          //       width: getProportionateScreenWidth(120),
          //       decoration: BoxDecoration(
          //           borderRadius: BorderRadius.circular(12),
          //           color: const Color.fromRGBO(254, 86, 49, 1)),
          //       child: const Center(child: Text("Confirm")),
          //     ),
          //   ),
          //   SizedBox(
          //     width: getProportionateScreenWidth(5),
          //   )
          // ],
        ),
      );
    },
  );
}
