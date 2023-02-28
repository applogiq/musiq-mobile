// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:musiq/src/common_widgets/loader.dart';
import 'package:musiq/src/core/constants/constant.dart';
import 'package:musiq/src/features/payment/provider/payment_provider.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentLoadingScreen extends StatefulWidget {
  final int amount;
  final bool isFromProfile;

  final String orderId;
  const PaymentLoadingScreen(
      {super.key,
      required this.amount,
      required this.orderId,
      this.isFromProfile = true});

  @override
  State<PaymentLoadingScreen> createState() => _PaymentLoadingScreenState();
}

class _PaymentLoadingScreenState extends State<PaymentLoadingScreen> {
  // Create razorpay instance
  late Razorpay _razorpay;
  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    // Payment process function call with amount and order id
    paymentProcess(widget.amount, widget.orderId);
    // Handle payment success function call listener
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    // Handle payment error function call listener
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    // Handle external wallet function call listener
    // _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

// Razor pay payment process method and theme set
  paymentProcess(int amount, String orderId) {
    var options = {
      'key': RazorPayConstant.razoryPayKey,
      'amount': amount,
      'name': 'MusiQ',
      'description': 'Monthly subscription',
      'order_id': orderId,
      'retry': {'enabled': true, 'max_count': 1},
      'theme': {
        'hide_topbar': true,
        'backdrop_color': "#16151C",
        "color": "#16151C"
      },
      'send_sms_hash': true,
    };
    print(options);
    _razorpay.open(options);
  }

// After payment success this function call, confirm payment and navigate to payment success screen
  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    await context.read<PaymentProvider>().confirmPayment(
        context, response.orderId!, response.paymentId!, response.signature!);

    context
        .read<PaymentProvider>()
        .paymentSuccess(context, isFromProfile: widget.isFromProfile);
  }

// After payment error this function call
  void _handlePaymentError(PaymentFailureResponse response) {
    Navigator.pop(context);
  }

  // void _handleExternalWallet(ExternalWalletResponse response) async {}

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: const Center(
        child: LoaderScreen(),
      ),
    );
  }
}
