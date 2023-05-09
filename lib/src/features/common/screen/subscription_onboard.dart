import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:musiq/src/common_widgets/buttons/custom_button.dart';
import 'package:musiq/src/core/enums/enums.dart';
import 'package:musiq/src/core/utils/size_config.dart';
import 'package:musiq/src/features/home/provider/home_provider.dart';
import 'package:musiq/src/features/library/widgets/favourite/alert_packages/show_dialog_package.dart';
import 'package:musiq/src/features/payment/provider/payment_provider.dart';
import 'package:provider/provider.dart';

import '../../../common_widgets/box/vertical_box.dart';
import '../../../common_widgets/loader.dart';
import '../../../core/constants/constant.dart';
import '../../payment/widgets/flash_image_widget.dart';
import '../../payment/widgets/get_exclusive_content_widget.dart';
import '../../payment/widgets/plan_description_widget.dart';
import '../../payment/widgets/subscription_card.dart';

class SubscriptionOnboard extends StatefulWidget {
  const SubscriptionOnboard({super.key});

  @override
  State<SubscriptionOnboard> createState() => _SubscriptionOnboardState();
}

class _SubscriptionOnboardState extends State<SubscriptionOnboard> {
  bool isbuttonLoad = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      context.read<HomeProvider>().refreshPremiumStatus();

      context.read<PaymentProvider>().getSubscriptionList();
      context
          .read<PaymentProvider>()
          .changeSubscription(SubscriptionPlan.free, "free", 0, 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return WillPopScope(
      onWillPop: () {
        return showAlertDialog(context);
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(ConstantText.subscription),
        ),
        body: Consumer<PaymentProvider>(builder: (context, pro, _) {
          return pro.isSubsciptionLoad
              ? const LoaderScreen()
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ListView(
                    shrinkWrap: true,
                    children: const [
                      VerticalBox(height: 12),
                      FlashImageWidget(),
                      VerticalBox(height: 8),
                      GetExclusiveContentWidget(),
                      VerticalBox(height: 8),
                      GetExclusiveSubtitleWidget(),
                      VerticalBox(height: 44),
                      SubscriptionCard(),
                      VerticalBox(height: 32),
                      PlanDescriptionWidget(),
                    ],
                  ),
                );
        }),
        bottomNavigationBar:
            Consumer<PaymentProvider>(builder: (context, pro, _) {
          return GestureDetector(
              onTap: isbuttonLoad == true
                  ? () {}
                  : () async {
                      isbuttonLoad = true;
                      setState(() {});
                      log("musiqqqqqqqq");
                      if (pro.subscriptionPlan != SubscriptionPlan.free) {
                        await context
                            .read<PaymentProvider>()
                            .createPayment(context, isFromProfile: false);
                      } else {
                        await context.read<HomeProvider>().goToHome(context);
                        await Future.delayed(const Duration(seconds: 4));
                      }
                      isbuttonLoad = false;
                      setState(() {});
                    },
              child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  width: MediaQuery.of(context).size.width,
                  height: 58,
                  decoration: BoxDecoration(
                    color: CustomColor.secondaryColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                      // child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.center,
                      //     children: [
                      //   //         pro.isPaymentLoad && pro.isplanLoad
                      //   //             ? const Padding(
                      //   //                 padding: EdgeInsets.symmetric(
                      //   //                     vertical: 6.0, horizontal: 8),
                      //   //                 child: SizedBox(
                      //   //                   height: 24,
                      //   //                   width: 24,
                      //   //                   child: CircularProgressIndicator(
                      //   //                     color: Colors.white,
                      //   //                     strokeWidth: 3,
                      //   //                   ),
                      //   //                 ),
                      //   //               )
                      //   //             : Text(
                      //   //                 pro.subscriptionPlan != SubscriptionPlan.free
                      //   //                     ? ConstantText.payNow
                      //   //                     : ConstantText.continueWithFreePlan,
                      //   //                 style: fontWeight500(size: 16.0),
                      //   //               )
                      //   //       ],
                      //   //     ),
                      //   //   ),
                      //   // )

                      // ]))));

                      // child: pro.isplanLoad
                      //     ? const Padding(
                      //         padding: EdgeInsets.symmetric(
                      //             vertical: 6.0, horizontal: 8),
                      //         child: SizedBox(
                      //           height: 24,
                      //           width: 24,
                      //           child: CircularProgressIndicator(
                      //             color: Colors.white,
                      //             strokeWidth: 3,
                      //           ),
                      //         ),
                      //       )
                      // :
                      child: isbuttonLoad
                          ? const Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 6.0, horizontal: 8),
                              child: SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 3,
                                ),
                              ),
                            )
                          : CustomButton(
                              height: 100,
                              isLoading: false,
                              label:
                                  pro.subscriptionPlan != SubscriptionPlan.free
                                      ? ConstantText.payNow
                                      : ConstantText.continueWithFreePlan,
                              horizontalMargin: 4,
                            ))));
        }),
      ),
    );
  }
}

showAlertDialog(BuildContext context) {
  showAnimatedDialog(
    context: context,
    barrierDismissible: true,

    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: const Color.fromRGBO(33, 33, 44, 1),
        title: const SizedBox.shrink(),
        content: const Padding(
          padding: EdgeInsets.only(left: 12, right: 12),
          child: Text(
            "Do you want to Exit app?",
            style: TextStyle(fontSize: 16),
          ),
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
              SystemNavigator.pop();
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

    animationType: DialogTransitionType.scale,

    curve: Curves.fastOutSlowIn,

// duration: const Duration(seconds: 1),
  );
}
