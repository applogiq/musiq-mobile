import 'package:flutter/cupertino.dart';
import 'package:musiq/src/common_widgets/loader.dart';
import 'package:musiq/src/core/constants/constant.dart';
import 'package:musiq/src/features/payment/provider/payment_provider.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentLoadingScreen extends StatefulWidget {
  final int amount;
  final bool isFromProfile;
  // final int validity;
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
  late Razorpay _razorpay;
  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    paymentProcess(widget.amount, widget.orderId);
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  paymentProcess(int amount, String orderId) {
    print("amount");
    print(amount);
    var options = {
      'key': RazorPayConstant.razoryPayKey,
      'amount': amount,
      'name': 'MusiQ',
      'description': 'Monthly subscription',
      'order_id': orderId,
      'retry': {'enabled': true, 'max_count': 1},
      'external': {
        'wallets': ['gpay', 'paytm']
      },
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

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    print(response.orderId);
    print(response.paymentId);
    print(response.signature);
    print(response.orderId);
    await context.read<PaymentProvider>().confirmPayment(
        context, response.orderId!, response.paymentId!, response.signature!);
    context
        .read<PaymentProvider>()
        .paymentSuccess(context, isFromProfile: widget.isFromProfile);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Navigator.pop(context);
    print(response.toString());
  }

  void _handleExternalWallet(ExternalWalletResponse response) async {
    print("External");
    print(response.walletName);
    print(response.toString());
    await Future.delayed(const Duration(seconds: 3), () {});
    context.read<PaymentProvider>().paymentSuccess(context);
  }

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
