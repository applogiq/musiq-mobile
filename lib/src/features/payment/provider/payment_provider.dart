import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:musiq/src/core/enums/enums.dart';
import 'package:musiq/src/features/payment/screen/payment_loading_screen.dart';
import 'package:musiq/src/features/payment/screen/subscription_screen.dart';
import 'package:musiq/src/features/payment/screen/subscription_success.dart';

import '../../../core/constants/local_storage_constants.dart';

class PaymentProvider extends ChangeNotifier {
  SubscriptionPlan subscriptionPlan = SubscriptionPlan.threeMonths;
  changeSubscription(SubscriptionPlan sp) {
    subscriptionPlan = sp;
    notifyListeners();
  }

  void pay(BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const PaymentLoadingScreen()));
  }

  void paymentSuccess(BuildContext context) async {
    FlutterSecureStorage secureStorage = const FlutterSecureStorage();
    await secureStorage.write(
        key: LocalStorageConstant.subscriptionEndDate, value: null);
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const SubscriptionSuccess()));
  }

  void continueWithFreePlanSubscription(BuildContext context) async {
    FlutterSecureStorage secureStorage = const FlutterSecureStorage();
    await secureStorage.write(
        key: LocalStorageConstant.subscriptionEndDate, value: null);
    Navigator.pop(context);
  }

  void viewPlanSubscription(BuildContext context) async {
    FlutterSecureStorage secureStorage = const FlutterSecureStorage();
    await secureStorage.write(
        key: LocalStorageConstant.subscriptionEndDate, value: null);
    Navigator.pop(context);

    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const SubscriptionsScreen()));
  }
}
