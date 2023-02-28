import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/constant.dart';
import '../../../core/enums/enums.dart';
import '../provider/payment_provider.dart';

class SubscriptionPlanCard extends StatelessWidget {
  const SubscriptionPlanCard({
    Key? key,
    required this.subscriptionPlan,
    this.isBestSeller = false,
    required this.imageAsset,
    required this.planName,
    required this.planPrice,
    required this.selectedSubscriptionPlan,
    required this.comparedPrice,
    required this.planValidity,
  }) : super(key: key);
  final SubscriptionPlan subscriptionPlan;
  final bool isBestSeller;
  final String imageAsset;
  final String planName;
  final String planPrice;
  final String comparedPrice;
  final SubscriptionPlan selectedSubscriptionPlan;
  final int planValidity;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Consumer<PaymentProvider>(builder: (context, pro, _) {
        return GestureDetector(
          onTap: () {
            pro.changeSubscription(
                subscriptionPlan, planName, int.parse(planPrice), planValidity);
          },
          child: SizedBox(
            height: 190,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  height: 172,
                  decoration: BoxDecoration(
                      color: const Color(0xFF23232D),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: pro.subscriptionPlan == subscriptionPlan
                              ? CustomColor.secondaryColor
                              : Colors.black,
                          width: 1)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2E2E3D),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Image.asset(
                            imageAsset,
                            height: 24,
                            width: 24,
                          ),
                        ),
                        Text(planName),
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(ConstantText.rupee,
                                    style: GoogleFonts.portLligatSans(
                                        textStyle: const TextStyle(
                                      fontSize: 18.0,
                                    ))
                                    // style: fontWeight400(size: 18.0),
                                    ),
                                Text(
                                  planPrice,
                                  style: fontWeight600(size: 24.0),
                                ),
                              ],
                            ),
                            subscriptionPlan != SubscriptionPlan.free
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(ConstantText.rupee,
                                          style: GoogleFonts.portLligatSans(
                                            textStyle: fontWeight400(
                                                size: 14.0,
                                                color: CustomColor.subTitle),
                                          )
                                          // style: fontWeight400(size: 18.0),
                                          ),
                                      Text(
                                        comparedPrice,
                                        style: TextStyle(
                                          color: CustomColor.subTitle,
                                          fontSize: 14.0,
                                          decoration:
                                              TextDecoration.lineThrough,
                                        ),
                                      ),
                                    ],
                                  )
                                : const SizedBox.shrink(),
                          ],
                        ),
                        (planName.toLowerCase() ==
                                context
                                    .read<PaymentProvider>()
                                    .currentPlan
                                    .toLowerCase())
                            ? Container(
                                margin: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                decoration: BoxDecoration(
                                    color: const Color(0xFF2E2E3D),
                                    borderRadius: BorderRadius.circular(12)),
                                child: Text(
                                  ConstantText.currentPlan,
                                  style: fontWeight400(size: 12.0),
                                ))
                            : const SizedBox.shrink()
                      ],
                    ),
                  ),
                ),
                subscriptionPlan == SubscriptionPlan.threeMonths
                    ? Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        decoration: BoxDecoration(
                            color: CustomColor.secondaryColor,
                            borderRadius: BorderRadius.circular(12)),
                        child: Text(
                          ConstantText.bestSeller,
                          style: fontWeight400(size: 12.0),
                        ),
                      )
                    : const SizedBox.shrink()
              ],
            ),
          ),
        );
      }),
    );
  }
}
