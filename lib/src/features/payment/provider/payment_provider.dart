// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:musiq/src/core/enums/enums.dart';
import 'package:musiq/src/features/auth/domain/models/user_model.dart';
import 'package:musiq/src/features/auth/provider/login_provider.dart';
import 'package:musiq/src/features/common/screen/subscription_onboard.dart';
import 'package:musiq/src/features/payment/domain/model/payment_price_model.dart';
import 'package:musiq/src/features/payment/domain/model/payment_success_model.dart';
import 'package:musiq/src/features/payment/domain/repo/payment_repo.dart';
import 'package:musiq/src/features/payment/screen/subscription_success.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/local_storage_constants.dart';
import '../screen/payment_loading_screen.dart';

class PaymentProvider extends ChangeNotifier {
  String currentPlan = "Free";
  bool isPaymentLoad = false;
  bool isSubsciptionLoad = true;
  bool isplanLoad = true;
  //Create Payment repository instance
  PaymentRepository paymentRepository = PaymentRepository();

  String planName = "free";
  int planPrice = 0;
  int planValidity = 0;
  PremiumPriceModel premiumPriceModel = PremiumPriceModel(
      success: false, message: "", records: [], totalrecords: 0);

  //Create FlutterSecureStorage instance
  FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  SubscriptionPlan subscriptionPlan = SubscriptionPlan.threeMonths;

//Create payment API request
  createPayment(BuildContext context, {bool isFromProfile = true}) async {
    isplanLoad = true;
    notifyListeners();
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
          ),
        ),
      );
    }
    isplanLoad = false;
    notifyListeners();
  }

// Confirm payment API call
  confirmPayment(BuildContext context, String orderId, String paymentId,
      String razorpaySignature) async {
    Map params = {};

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
  }

// Subscription toggle in subscription screen
  changeSubscription(SubscriptionPlan sp, String kPlanName, int kPlanPrice,
      int kPlanValidity) {
    subscriptionPlan = sp;
    planName = kPlanName;
    planPrice = kPlanPrice;
    planValidity = kPlanValidity;
    notifyListeners();
  }

// Get all subscription list from API
  getSubscriptionList() async {
    isSubsciptionLoad = true;
    notifyListeners();

    var res = await paymentRepository.getSubscriptionsPlan();
    print(res.body);
    isSubsciptionLoad = false;
    notifyListeners();

    premiumPriceModel.records.clear();

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

// If Razorpay payment success to call paymentSuccess method and Navigate to subscription success screen
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

// Continue with free plan API call and navigate to main screen
  void continueWithFreePlanSubscription(BuildContext context,
      {bool isFromDialog = false}) async {
    isplanLoad = true;
    notifyListeners();
    Map params = {};

    params["premier_status"] = "free";
    isPaymentLoad = true;
    notifyListeners();
    var res = await paymentRepository.createPayment(params);

    if (res.statusCode == 201) {
      log("mickyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy");
      FlutterSecureStorage secureStorage = const FlutterSecureStorage();
      await secureStorage.write(
          key: LocalStorageConstant.subscriptionEndDate, value: null);
      Map<String, String> localData = await secureStorage.readAll();
      context.read<LoginProvider>().emailAddress = localData["email"] ?? "";
      context.read<LoginProvider>().password = localData["password_cred"] ?? "";
      if (localData["email"] != null) {
        await context.read<LoginProvider>().login(context);
      }
      isPaymentLoad = false;
      notifyListeners();
    }

    if (isFromDialog) {
      Navigator.pop(context);
    }
    isplanLoad = false;
    notifyListeners();
  }

// View plan navigtation in subscription end dialog
  void viewPlanSubscription(BuildContext context) async {
    FlutterSecureStorage secureStorage = const FlutterSecureStorage();
    await secureStorage.write(
        key: LocalStorageConstant.subscriptionEndDate, value: null);
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const SubscriptionOnboard()));
  }
}
