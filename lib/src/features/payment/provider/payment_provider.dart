import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:musiq/src/core/enums/enums.dart';
import 'package:musiq/src/features/payment/screen/subscription_success.dart';

class PaymentProvider extends ChangeNotifier {
  SubscriptionPlan subscriptionPlan = SubscriptionPlan.threeMonths;
  changeSubscription(SubscriptionPlan sp) {
    subscriptionPlan = sp;
    notifyListeners();
  }

  void pay(BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const SubscriptionSuccess()));
  }
}
