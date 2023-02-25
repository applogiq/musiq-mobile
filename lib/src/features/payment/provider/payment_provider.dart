import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:musiq/src/core/enums/enums.dart';
import 'package:musiq/src/features/auth/domain/models/user_model.dart';
import 'package:musiq/src/features/auth/provider/login_provider.dart';
import 'package:musiq/src/features/payment/domain/model/payment_price_model.dart';
import 'package:musiq/src/features/payment/domain/model/payment_success_model.dart';
import 'package:musiq/src/features/payment/domain/repo/payment_repo.dart';
import 'package:musiq/src/features/payment/screen/subscription_screen.dart';
import 'package:musiq/src/features/payment/screen/subscription_success.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/local_storage_constants.dart';
import '../screen/payment_loading_screen.dart';

class PaymentProvider extends ChangeNotifier {
  PaymentRepository paymentRepository = PaymentRepository();
  FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  bool isSubsciptionLoad = true;
  String currentPlan = "Free";
  String planName = "free";
  int planPrice = 0;
  int planValidity = 0;
  SubscriptionPlan subscriptionPlan = SubscriptionPlan.threeMonths;
  PremiumPriceModel premiumPriceModel = PremiumPriceModel(
      success: false, message: "", records: [], totalrecords: 0);

  createPayment(BuildContext context, {bool isFromProfile = true}) async {
    Map params = {};
    params["payment_price"] = planPrice * 100;
    params["premier_status"] = planName;
    var res = await paymentRepository.createPayment(params);

    if (res.statusCode == 201) {
      var data = jsonDecode(res.body);
      PaymentSuccessModel successModel = PaymentSuccessModel.fromMap(data);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PaymentLoadingScreen(
                    amount: successModel.records.paymentPrice,
                    orderId: successModel.records.razorpayOrderId,
                    isFromProfile: isFromProfile,
                  )));
    }
  }

  confirmPayment(BuildContext context, String orderId, String paymentId,
      String razorpaySignature) async {
    Map params = {};
    // params["payment_price"] = planPrice * 100;
    params["premier_status"] = planName;
    params["validity"] = planValidity;
    params["razorpay_order_id"] = orderId;
    params["razorpay_payment_id"] = paymentId;
    params["razorpay_signature"] = razorpaySignature;
    print(params);

    var res = await paymentRepository.confirmPayment(params);
    print(res.statusCode);
    print(res.body);
    if (res.statusCode == 200) {
      var data = jsonDecode(res.body);
      UserModel userModel = UserModel.fromMap(data);
      print("SSFFF");
      print(userModel.records.subscriptionEndDate);
      await secureStorage.write(
          key: LocalStorageConstant.subscriptionEndDate,
          value: userModel.records.subscriptionEndDate.toString());
      print(await secureStorage.read(
          key: LocalStorageConstant.subscriptionEndDate));
      context.read<LoginProvider>().changeUserModel(userModel);
    }
    // if (res.statusCode == 201) {

    //   Navigator.push(
    //       context,
    //       MaterialPageRoute(
    //           builder: (context) => PaymentLoadingScreen(
    //                 amount: successModel.records.paymentPrice,
    //                 orderId: successModel.records.razorpayOrderId,
    //               )));
    // }
  }

  changeSubscription(SubscriptionPlan sp, String kPlanName, int kPlanPrice,
      int kPlanValidity) {
    subscriptionPlan = sp;

    planName = kPlanName;
    planPrice = kPlanPrice;
    planValidity = kPlanValidity;
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
      planName = premiumPriceModel.records[0].title;
      planPrice = premiumPriceModel.records[0].price;
      subscriptionPlan = SubscriptionPlan.threeMonths;

      planValidity = premiumPriceModel.records[0].validity;
      currentPlan = await secureStorage.read(key: "premium_status") ?? "Free";
      print(currentPlan);
      notifyListeners();
    }

    notifyListeners();
  }

  void pay(BuildContext context) {
    print(planName);
    print(planPrice);
  }

  void paymentSuccess(BuildContext context, {bool isFromProfile = true}) async {
    await secureStorage.write(
        key: LocalStorageConstant.isOnboardFree, value: "true");
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SubscriptionSuccess(
                  isFromProfile: isFromProfile,
                )));
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
