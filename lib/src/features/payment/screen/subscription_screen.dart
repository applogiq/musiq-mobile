import 'package:flutter/material.dart';
import 'package:musiq/src/common_widgets/box/horizontal_box.dart';
import 'package:musiq/src/core/constants/images.dart';

import '../../../core/constants/constant.dart';
import '../../../core/utils/size_config.dart';

class SubscriptionsScreen extends StatelessWidget {
  const SubscriptionsScreen({super.key});

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
                // pro.clearError();
              },
              child: const Icon(Icons.arrow_back_ios)),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ListView(
            shrinkWrap: true,
            children: [
              Center(
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
              ),
              Center(
                child: Text(
                  ConstantText.getExclusiveContent,
                  style: fontWeight600(size: 26.0),
                ),
              ),
              Center(
                child: Text(
                  ConstantText.getExclusiveSubTopic,
                  textAlign: TextAlign.center,
                  style: fontWeight400(size: 12.0, color: CustomColor.subTitle),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      height: 172,
                      decoration: BoxDecoration(
                        color: const Color(0xFF23232D),
                        borderRadius: BorderRadius.circular(12),
                      ),
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
                                Images.chartImage,
                                height: 24,
                                width: 24,
                              ),
                            ),
                            const Text(ConstantText.free),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  ConstantText.rupee,
                                  style: fontWeight400(size: 18.0),
                                ),
                                Text(
                                  ConstantText.freePlanPrice,
                                  style: fontWeight600(size: 24.0),
                                ),
                              ],
                            ),
                            1 == 1
                                ? Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6),
                                    decoration: BoxDecoration(
                                        color: const Color(0xFF2E2E3D),
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    child: const Text(ConstantText.currentPlan))
                                : const SizedBox.shrink()
                          ],
                        ),
                      ),
                    ),
                  ),
                  const HorizontalBox(width: 12),
                  Expanded(
                    child: Container(
                      height: 172,
                      decoration: BoxDecoration(
                        color: const Color(0xFF23232D),
                        borderRadius: BorderRadius.circular(12),
                      ),
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
                                Images.starImage,
                                height: 24,
                                width: 24,
                              ),
                            ),
                            const Text(ConstantText.threeMonthsPlan),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  ConstantText.rupee,
                                  style: fontWeight400(size: 18.0),
                                ),
                                Text(
                                  ConstantText.threeMonthsPlanPrice,
                                  style: fontWeight600(size: 24.0),
                                ),
                              ],
                            ),
                            1 == 0
                                ? Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6),
                                    decoration: BoxDecoration(
                                        color: const Color(0xFF2E2E3D),
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    child: const Text(ConstantText.currentPlan))
                                : const SizedBox.shrink()
                          ],
                        ),
                      ),
                    ),
                  ),
                  const HorizontalBox(width: 12),
                  Expanded(
                    child: Container(
                      height: 172,
                      decoration: BoxDecoration(
                        color: const Color(0xFF23232D),
                        borderRadius: BorderRadius.circular(12),
                      ),
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
                                Images.medalStarImage,
                                height: 24,
                                width: 24,
                              ),
                            ),
                            const Text(ConstantText.sixMonthsPlan),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  ConstantText.rupee,
                                  style: fontWeight400(size: 18.0),
                                ),
                                Text(
                                  ConstantText.sixMonthsPlanPrice,
                                  style: fontWeight600(size: 24.0),
                                ),
                              ],
                            ),
                            1 == 0
                                ? Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6),
                                    decoration: BoxDecoration(
                                        color: const Color(0xFF2E2E3D),
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    child: const Text(ConstantText.currentPlan))
                                : const SizedBox.shrink()
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ));
  }
}
