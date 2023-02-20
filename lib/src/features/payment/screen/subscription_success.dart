import 'package:flutter/material.dart';
import 'package:musiq/src/common_widgets/box/vertical_box.dart';
import 'package:musiq/src/core/constants/images.dart';
import 'package:provider/provider.dart';

import '../../../common_widgets/buttons/custom_button.dart';
import '../../../core/constants/constant.dart';
import '../../../core/utils/size_config.dart';
import '../provider/payment_provider.dart';

class SubscriptionSuccess extends StatelessWidget {
  const SubscriptionSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: getProportionateScreenHeight(70),
        title: const Text(ConstantText.subscription),
        titleSpacing: 0.1,
        leading: InkWell(onTap: () {}, child: const Icon(Icons.arrow_back_ios)),
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              Images.subscriptionSuccess,
              height: 137,
            ),
            const VerticalBox(height: 32),
            Text(
              ConstantText.enjoyPremium,
              style: fontWeight600(size: 26.0),
            ),
            const VerticalBox(height: 8),
            Text(
              ConstantText.enjoyPremiumContent,
              textAlign: TextAlign.center,
              style: fontWeight400(size: 12.0, color: CustomColor.subTitle),
            ),
          ],
        ),
      ),
      bottomNavigationBar: GestureDetector(
        onTap: () {
          context.read<PaymentProvider>().pay(context);
        },
        child: const CustomButton(
          label: ConstantText.listenNow,
          horizontalMargin: 0,
        ),
      ),
    );
  }
}
