import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:musiq/src/common_widgets/box/vertical_box.dart';
import 'package:musiq/src/common_widgets/loader.dart';
import 'package:musiq/src/core/constants/images.dart';
import 'package:musiq/src/core/enums/enums.dart';
import 'package:musiq/src/features/home/provider/home_provider.dart';
import 'package:musiq/src/features/payment/provider/payment_provider.dart';
import 'package:provider/provider.dart';

import '../../../common_widgets/box/horizontal_box.dart';
import '../../../common_widgets/buttons/custom_button.dart';
import '../../../core/constants/constant.dart';
import '../../../core/utils/size_config.dart';

class SubscriptionsScreen extends StatefulWidget {
  const SubscriptionsScreen({super.key});

  @override
  State<SubscriptionsScreen> createState() => _SubscriptionsScreenState();
}

class _SubscriptionsScreenState extends State<SubscriptionsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      context.read<PaymentProvider>().getSubscriptionList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: getProportionateScreenHeight(70),
        title: const Text(ConstantText.subscription),
        titleSpacing: 0.1,
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back_ios)),
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
            context.read<PaymentProvider>().pay(context);
          },
          child: CustomButton(
            isValid: (pro.subscriptionPlan != SubscriptionPlan.free &&
                    pro.isSubsciptionLoad == false)
                ? true
                : false,
            label: ConstantText.payNow,
            horizontalMargin: 0,
          ),
        );
      }),
    );
  }
}

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
          ),
          const HorizontalBox(width: 4),
          SubscriptionPlanCard(
            subscriptionPlan: SubscriptionPlan.threeMonths,
            selectedSubscriptionPlan: SubscriptionPlan.free,
            imageAsset: Images.starImage,
            planName: pro.premiumPriceModel.records[0].title,
            planPrice: pro.premiumPriceModel.records[0].price.toString(),
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
            comparedPrice:
                pro.premiumPriceModel.records[1].comparePrice.toString(),
          )
        ],
      );
    });
  }
}

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
  }) : super(key: key);
  final SubscriptionPlan subscriptionPlan;
  final bool isBestSeller;
  final String imageAsset;
  final String planName;
  final String planPrice;
  final String comparedPrice;
  final SubscriptionPlan selectedSubscriptionPlan;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Consumer<PaymentProvider>(builder: (context, pro, _) {
        return GestureDetector(
          onTap: () {
            pro.changeSubscription(subscriptionPlan);
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
                        selectedSubscriptionPlan == subscriptionPlan
                            ? Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 6),
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

class GetExclusiveSubtitleWidget extends StatelessWidget {
  const GetExclusiveSubtitleWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        ConstantText.getExclusiveSubTopic,
        textAlign: TextAlign.center,
        style: fontWeight400(size: 12.0, color: CustomColor.subTitle),
      ),
    );
  }
}

class GetExclusiveContentWidget extends StatelessWidget {
  const GetExclusiveContentWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        ConstantText.getExclusiveContent,
        style: fontWeight600(size: 26.0),
      ),
    );
  }
}

class FlashImageWidget extends StatelessWidget {
  const FlashImageWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFF23232D),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Image.asset(
          Images.flashImage,
          height: 24,
          width: 24,
        ),
      ),
    );
  }
}

class PlanDescriptionWidget extends StatelessWidget {
  const PlanDescriptionWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 3,
              child: Text(
                ConstantText.features,
                style: fontWeight600(size: 14.0),
              ),
            ),
            Expanded(
              child: Center(
                  child: Text(
                ConstantText.free,
                style: fontWeight600(size: 14.0),
              )),
            ),
            Expanded(
              child: Text(
                ConstantText.premium,
                style: fontWeight600(size: 14.0),
              ),
            ),
          ],
        ),
        const VerticalBox(height: 12),
        const FeatureRowWidget(
            featureLabel: ConstantText.adFreeSong,
            freeIcon: Icons.close,
            premiumIcon: Icons.check),
        const VerticalBox(height: 16),
        const FeatureRowWidget(
            featureLabel: ConstantText.unlimitedStreaming,
            freeIcon: Icons.check,
            premiumIcon: Icons.check),
        const VerticalBox(height: 16),
        const FeatureRowWidget(
            featureLabel: ConstantText.access,
            freeIcon: Icons.close,
            premiumIcon: Icons.check),
      ],
    );
  }
}

class FeatureRowWidget extends StatelessWidget {
  const FeatureRowWidget({
    Key? key,
    required this.featureLabel,
    required this.freeIcon,
    required this.premiumIcon,
  }) : super(key: key);
  final String featureLabel;
  final IconData freeIcon;
  final IconData premiumIcon;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Text(
            featureLabel,
            style: fontWeight400(
              color: CustomColor.subTitle,
            ),
          ),
        ),
        Expanded(
          child: Align(
              alignment: Alignment.center,
              child: Center(child: Icon(freeIcon))),
        ),
        Expanded(
          child: Icon(premiumIcon),
        ),
      ],
    );
  }
}
