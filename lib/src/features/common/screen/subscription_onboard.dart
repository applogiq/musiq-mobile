import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:musiq/src/core/enums/enums.dart';
import 'package:musiq/src/core/utils/size_config.dart';
import 'package:musiq/src/features/home/provider/home_provider.dart';
import 'package:musiq/src/features/payment/provider/payment_provider.dart';
import 'package:provider/provider.dart';

import '../../../common_widgets/box/vertical_box.dart';
import '../../../common_widgets/buttons/custom_button.dart';
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
            onTap: () {
              if (pro.subscriptionPlan != SubscriptionPlan.free) {
                context
                    .read<PaymentProvider>()
                    .createPayment(context, isFromProfile: false);
              } else {
                context.read<HomeProvider>().goToHome(context);
              }
            },
            child: CustomButton(
              isLoading: pro.isPaymentLoad,
              label: pro.subscriptionPlan != SubscriptionPlan.free
                  ? ConstantText.payNow
                  : ConstantText.continueWithFreePlan,
              horizontalMargin: 4,
            ),
          );
        }),
      ),
    );
  }
}

showAlertDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: const Color.fromRGBO(33, 33, 44, 1),
        title: const SizedBox.shrink(),
        content: const Padding(
          padding: EdgeInsets.only(left: 12),
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
              // Auth auth = Auth();
              // await auth.logOut(context);
              // await context.read<PlayerProvider>().removeAllData();
              // await context.read<PlayerProvider>().playlist.clear();
              // context.read<PlayerProvider>().inQueue = false;

              // Provider.of<RegisterProvider>(context, listen: false)
              //     .clearError();
              // Provider.of<RegisterProvider>(context, listen: false)
              //     .isButtonEnable = true;
              // await Navigation.removeAllScreenFromStack(
              //     context, const OnboardingScreen());
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
  );
}
