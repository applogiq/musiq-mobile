import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:musiq/src/common_widgets/box/vertical_box.dart';
import 'package:musiq/src/common_widgets/loader.dart';
import 'package:musiq/src/core/enums/enums.dart';
import 'package:musiq/src/features/auth/provider/login_provider.dart';
import 'package:musiq/src/features/payment/provider/payment_provider.dart';
import 'package:provider/provider.dart';

import '../../../common_widgets/buttons/custom_button.dart';
import '../../../core/constants/constant.dart';
import '../../../core/constants/local_storage_constants.dart';
import '../../../core/utils/size_config.dart';
import '../../library/screens/playlist/view_playlist_screen.dart';
import '../widgets/flash_image_widget.dart';
import '../widgets/get_exclusive_content_widget.dart';
import '../widgets/plan_description_widget.dart';
import '../widgets/subscription_card.dart';

class SubscriptionsScreen extends StatefulWidget {
  const SubscriptionsScreen({super.key});

  @override
  State<SubscriptionsScreen> createState() => _SubscriptionsScreenState();
}

class _SubscriptionsScreenState extends State<SubscriptionsScreen> {
  bool isSubscriptionEnable = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      context.read<PaymentProvider>().getSubscriptionList();
      await subscriptionCheck(context);
    });
  }

  subscriptionCheck(BuildContext context) async {
    FlutterSecureStorage secureStorage = const FlutterSecureStorage();
    var subscriptionEndDate =
        await secureStorage.read(key: LocalStorageConstant.subscriptionEndDate);

    if (subscriptionEndDate != null) {
      DateTime endDate = DateTime.parse(subscriptionEndDate);
      DateTime now = DateTime.now();
      if (endDate.compareTo(now) < 0) {
        isSubscriptionEnable = true;
      } else {
        isSubscriptionEnable = false;
      }
    } else {
      isSubscriptionEnable = true;
    }
    setState(() {});
  }

  getPayNowState(LoginProvider loginProvider, PaymentProvider pro) {
    if (pro.subscriptionPlan != SubscriptionPlan.free &&
        pro.isSubsciptionLoad == false &&
        loginProvider.userModel!.records.subscriptionEndDate == null) {
      return true;
    } else if (pro.subscriptionPlan != SubscriptionPlan.free &&
        pro.isSubsciptionLoad == false &&
        DateTime.parse(loginProvider.userModel!.records.subscriptionEndDate
                    .toString())
                .compareTo(DateTime.now()) <
            0) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Scaffold(
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
          print(!isSubscriptionEnable);
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
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Consumer<LoginProvider>(builder: (context, loginProvider, _) {
              return Consumer<PaymentProvider>(builder: (context, pro, _) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: GestureDetector(
                    onTap: getPayNowState(loginProvider, pro)
                        ? () {
                            context
                                .read<PaymentProvider>()
                                .createPayment(context);
                          }
                        : () {},
                    child: CustomButton(
                      height: 55,
                      isValid:
                          getPayNowState(loginProvider, pro) ? true : false,
                      label: ConstantText.payNow,
                      horizontalMargin: 0,
                    ),
                  ),
                );
              });
            }),
            const BottomMiniPlayer(),
          ],
        ),
      ),
    );
  }
}
