import 'package:flutter/material.dart';
import 'package:musiq/src/core/enums/enums.dart';
import 'package:musiq/src/core/utils/size_config.dart';
import 'package:musiq/src/features/home/provider/home_provider.dart';
import 'package:musiq/src/features/payment/provider/payment_provider.dart';
import 'package:provider/provider.dart';

import '../../../common_widgets/box/vertical_box.dart';
import '../../../common_widgets/buttons/custom_button.dart';
import '../../../core/constants/constant.dart';
import '../../payment/screen/subscription_screen.dart';

class SubscriptionOnboard extends StatefulWidget {
  const SubscriptionOnboard({super.key});

  @override
  State<SubscriptionOnboard> createState() => _SubscriptionOnboardState();
}

class _SubscriptionOnboardState extends State<SubscriptionOnboard> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      context.read<HomeProvider>().refreshPremiumStatus();
      context.read<PaymentProvider>().changeSubscription(SubscriptionPlan.free);
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(ConstantText.subscription),
      ),
      body: Padding(
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
      ),
      bottomNavigationBar:
          Consumer<PaymentProvider>(builder: (context, pro, _) {
        return GestureDetector(
          onTap: () {
            if (pro.subscriptionPlan != SubscriptionPlan.free) {
              context.read<PaymentProvider>().pay(context);
            } else {
              context.read<HomeProvider>().goToHome(context);
            }
          },
          child: CustomButton(
            label: pro.subscriptionPlan != SubscriptionPlan.free
                ? ConstantText.payNow
                : ConstantText.continueWithFreePlan,
            horizontalMargin: 4,
          ),
        );
      }),
    );
  }
}
