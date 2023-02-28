import 'package:flutter/material.dart';
import 'package:musiq/src/features/payment/widgets/subscription_plan_card.dart';
import 'package:provider/provider.dart';

import '../../../common_widgets/box/horizontal_box.dart';
import '../../../core/constants/constant.dart';
import '../../../core/constants/images.dart';
import '../../../core/enums/enums.dart';
import '../../home/provider/home_provider.dart';
import '../provider/payment_provider.dart';

class SubscriptionCard extends StatelessWidget {
  const SubscriptionCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<PaymentProvider>(builder: (context, pro, _) {
      return Row(
        children: [
          SubscriptionPlanCard(
            subscriptionPlan: SubscriptionPlan.free,
            selectedSubscriptionPlan:
                context.read<HomeProvider>().getPremierStatus(),
            imageAsset: Images.chartImage,
            planName: ConstantText.free,
            planPrice: "0",
            comparedPrice: '0',
            planValidity: 0,
          ),
          const HorizontalBox(width: 4),
          SubscriptionPlanCard(
            subscriptionPlan: SubscriptionPlan.threeMonths,
            selectedSubscriptionPlan: SubscriptionPlan.free,
            imageAsset: Images.starImage,
            planName: pro.premiumPriceModel.records[0].title,
            planPrice: pro.premiumPriceModel.records[0].price.toString(),
            planValidity: pro.premiumPriceModel.records[0].validity,
            comparedPrice:
                pro.premiumPriceModel.records[0].comparePrice.toString(),
          ),
          const HorizontalBox(width: 4),
          SubscriptionPlanCard(
            selectedSubscriptionPlan: SubscriptionPlan.free,
            subscriptionPlan: SubscriptionPlan.sixMonths,
            imageAsset: Images.medalStarImage,
            planName: pro.premiumPriceModel.records[1].title,
            planPrice: pro.premiumPriceModel.records[1].price.toString(),
            planValidity: pro.premiumPriceModel.records[1].validity,
            comparedPrice:
                pro.premiumPriceModel.records[1].comparePrice.toString(),
          )
        ],
      );
    });
  }
}
