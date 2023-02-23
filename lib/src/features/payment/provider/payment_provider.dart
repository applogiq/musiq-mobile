import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:musiq/src/core/enums/enums.dart';
import 'package:musiq/src/features/payment/domain/model/payment_price_model.dart';
import 'package:musiq/src/features/payment/domain/repo/payment_repo.dart';
import 'package:musiq/src/features/payment/screen/payment_loading_screen.dart';
import 'package:musiq/src/features/payment/screen/subscription_screen.dart';
import 'package:musiq/src/features/payment/screen/subscription_success.dart';

import '../../../core/constants/local_storage_constants.dart';

class PaymentProvider extends ChangeNotifier {
  PaymentRepository paymentRepository = PaymentRepository();
  bool isSubsciptionLoad = true;
  SubscriptionPlan subscriptionPlan = SubscriptionPlan.threeMonths;
  PremiumPriceModel premiumPriceModel = PremiumPriceModel(
      success: false, message: "", records: [], totalrecords: 0);

  createPayment(int paymentPrice, String status) async {
    Map params = {};
    params["payment_price"] = paymentPrice;
    params["premier_status"] = status;
    var res = await paymentRepository.createPayment(params);
    print(res.statusCode);
    print(res.body);
  }

  changeSubscription(SubscriptionPlan sp) {
    subscriptionPlan = sp;
    notifyListeners();
  }

  getSubscriptionList() async {
    isSubsciptionLoad = true;
    notifyListeners();
    var res = await paymentRepository.getSubscriptionsPlan();
    print(res.body);
    isSubsciptionLoad = false;
    notifyListeners();

    premiumPriceModel.records.clear();
    // albumListModel.records.clear();

    if (res.statusCode == 200) {
      var data = jsonDecode(res.body);
      premiumPriceModel = PremiumPriceModel.fromMap(data);
    }
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
