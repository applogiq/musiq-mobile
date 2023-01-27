import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:musiq/src/common_widgets/box/vertical_box.dart';
import 'package:musiq/src/common_widgets/buttons/custom_button.dart';
import 'package:provider/provider.dart';

import '../../../../constants/color.dart';
import '../../../../constants/string.dart';
import '../../../../constants/style.dart';
import '../../../../core/package/otp_package/pinput.dart';
import '../../../../utils/size_config.dart';
import '../../../common/screen/offline_screen.dart';
import '../../provider/new_password_provider.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({super.key});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final pinController = TextEditingController();
  final focusNode = FocusNode();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    pinController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    SizeConfig().init(context);
    const focusedBorderColor = Color.fromRGBO(23, 171, 144, 1);
    const fillColor = Color.fromRGBO(243, 246, 249, 0);
    const borderColor = Color.fromRGBO(23, 171, 144, 0.4);

    final defaultPinTheme = PinTheme(
      width: size.width < 400
          ? getProportionateScreenWidth(50.5)
          : getProportionateScreenWidth(40.5),
      height: size.width < 400
          ? getProportionateScreenWidth(50.5)
          : getProportionateScreenWidth(40.5),
      textStyle: const TextStyle(
        fontSize: 22,
        color: Color.fromRGBO(255, 255, 255, 1),
      ),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(255, 255, 255, 0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.transparent),
      ),
    );
    return WillPopScope(
      onWillPop: () async {
        await context
            .read<ForgotPasswordProvider>()
            .forgotPasswordEmailBack(context);
        return true;
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size(double.maxFinite, 80),
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: AppBar(
              toolbarHeight: 64,
              titleSpacing: 0.1,
              leading: InkWell(
                  onTap: () {
                    context
                        .read<ForgotPasswordProvider>()
                        .forgotPasswordEmailBack(context);
                    // Navigator.of(context).pop();
                    // // provider.clearOTPError("");
                    // // provider.isNotClearError();
                    // //  provider.buttonEnable();
                    // fieldOne.clear();
                    // fieldTwo.clear();
                    // fieldThree.clear();
                    // fieldfour.clear();
                    // fieldFive.clear();
                    // fieldSix.clear();
                    // FocusScope.of(context).unfocus();
                  },
                  child: const Icon(Icons.arrow_back_ios_rounded)),
              title: Text(ConstantText.otp),
            ),
          ),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(16)),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height - 200,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            "An OTP has been sent to ${context.read<ForgotPasswordProvider>().emailAddress}. \nPlease enter the OTP below"),
                        const VerticalBox(height: 32),
                        SizedBox(
                          width: size.width,
                          child: Form(
                            key: formKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Consumer<ForgotPasswordProvider>(
                                    builder: (context, pro, _) {
                                  return Directionality(
                                    textDirection: TextDirection.ltr,
                                    child: Pinput(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      length: 6,
                                      controller: pinController,
                                      focusNode: focusNode,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                      ],
                                      defaultPinTheme: defaultPinTheme,
                                      hapticFeedbackType:
                                          HapticFeedbackType.lightImpact,
                                      onCompleted: (pin) {
                                        debugPrint('onCompleted: $pin');
                                        if (pin.length == 6) {
                                          // context
                                          //     .read<SetUpProvider>()
                                          //     .removeState();

                                          // pro.loginButtonEnabled(true);
                                          // pro.login(context, pin);
                                        } else {
                                          print("Invalid");
                                        }
                                      },
                                      onChanged: (value) {
                                        context
                                            .read<ForgotPasswordProvider>()
                                            .otpErrorMessage = "";
                                        if (value.length == 6) {
                                          pro.continueOTPButtonStatus(true);
                                        } else {
                                          pro.continueOTPButtonStatus(false);
                                        }
                                      },
                                      cursor: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.only(
                                                bottom: 9),
                                            width: 22,
                                            height: 1,
                                            color: const Color.fromRGBO(
                                                5, 31, 50, 0.8),
                                          ),
                                        ],
                                      ),
                                      focusedPinTheme: defaultPinTheme.copyWith(
                                        decoration: defaultPinTheme.decoration!
                                            .copyWith(
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          color: const Color.fromRGBO(
                                              255, 255, 255, 0.1),
                                        ),
                                      ),
                                      submittedPinTheme:
                                          defaultPinTheme.copyWith(
                                        decoration: defaultPinTheme.decoration!
                                            .copyWith(
                                          color: const Color.fromRGBO(
                                              255, 255, 255, 0.1),
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                      ),
                                      pinputAutovalidateMode:
                                          PinputAutovalidateMode.onSubmit,
                                      errorPinTheme:
                                          defaultPinTheme.copyBorderWith(
                                        border:
                                            Border.all(color: Colors.redAccent),
                                      ),
                                    ),
                                  );
                                }),
                              ],
                            ),
                          ),
                        ),
                        Consumer<ForgotPasswordProvider>(
                            builder: (context, pro, _) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                    child: Text(
                                  pro.otpErrorMessage,
                                  style: const TextStyle(color: Colors.red),
                                )),
                                pro.isTimerShow
                                    ? Text(
                                        "00:" "${pro.countTimer}",
                                        style: fontWeight400(
                                            color: CustomColor.subTitle2),
                                      )
                                    : InkWell(
                                        onTap: () {
                                          pinController.clear();

                                          pro.resendOTPTapped();
                                          // print(widget.email);
                                          // // _forgotpasswordCubit.resendOtp(context,
                                          //     email: widget.email);
                                        },
                                        child: Text(
                                          ConstantText.resendOTP,
                                          style: fontWeight400(
                                              color: CustomColor.subTitle2),
                                        ),
                                      ),
                              ],
                            ),
                          );
                        }),
                        const Spacer(),
                        Consumer<ForgotPasswordProvider>(
                            builder: (context, pro, _) {
                          return GestureDetector(
                            onTap: () {
                              pro.continueOTPButtonTapped(
                                  pinController.text, context);
                            },
                            child: CustomButton(
                              label: ConstantText.continueButton,
                              horizontalMargin: 0,
                              isValid: pro.isOTPButtonEnable,
                              isLoading: pro.isOTPLoading,
                            ),
                          );
                        }),
                        const Spacer(),
                        const Spacer(),
                      ]),
                ),
              ),
            ),
            Provider.of<InternetConnectionStatus>(context) ==
                    InternetConnectionStatus.disconnected
                ? const OfflineScreen()
                : const SizedBox.shrink()
          ],
        ),
      ),
    );
  }
}
