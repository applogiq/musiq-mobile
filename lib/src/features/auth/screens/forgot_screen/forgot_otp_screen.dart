import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:provider/provider.dart';

import '../../../../common_widgets/app_bar.dart';
import '../../../../common_widgets/buttons/custom_elevated_button.dart';
import '../../../../constants/color.dart';
import '../../../../constants/string.dart';
import '../../../../constants/style.dart';
import '../../provider/forgot_password_provider.dart';

class OTPScreen extends StatefulWidget {
  OTPScreen({
    Key? key,
    this.email = "",
  }) : super(key: key);
  String email;

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  String otpValue = "";
  // late ForgotpasswordCubit _forgotpasswordCubit;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _forgotpasswordCubit = ForgotpasswordCubit();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // _forgotpasswordCubit.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(double.maxFinite, 80),
        child: Padding(
          padding: EdgeInsets.only(top: 8.0),
          child: CustomAppBarWidget(
            title: ConstantText.otp,
          ),
        ),
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height - 200,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "An OTP has been sent to ${widget.email}.\nPlease enter the OTP below",
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 24.0),
                      child: OtpTextField(
                        borderRadius: BorderRadius.circular(8.0),
                        // margin: EdgeInsets.only(right: 16),
                        fieldWidth: 46,
                        numberOfFields: 6,
                        focusedBorderColor: Colors.transparent,
                        enabledBorderColor: Colors.transparent,
                        borderColor: Colors.transparent,
                        filled: true,
                        fillColor: CustomColor.textfieldBg,
                        showFieldAsBox: true,
                        onCodeChanged: (String code) {
                          print(code);
                        },
                        onSubmit: (otp) {
                          print(otp);
                          otpValue = otp;
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Consumer<ForgotPasswordProvider>(
                            builder: (context, provider, _) {
                          return provider.otpErrorMessage == ""
                              ? SizedBox.shrink()
                              : Padding(
                                  padding:
                                      const EdgeInsets.only(left: 8.0, top: 16),
                                  child: Text(
                                    "Fields are mandatory",
                                    style: const TextStyle(color: Colors.red),
                                  ),
                                );
                        }),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 16, 16, 0),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: InkWell(
                              onTap: () {
                                print(widget.email);
                                // // _forgotpasswordCubit.resendOtp(context,
                                //     email: widget.email);
                              },
                              child: Text(
                                ConstantText.resendOTP,
                                style:
                                    fontWeight400(color: CustomColor.subTitle2),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    // StreamBuilder(
                    //     stream: _forgotpasswordCubit.errorOTPStream,
                    //     builder: (context, snap) {
                    //       print(snap.data);
                    //       return snap.hasError
                    //           ? Container(
                    //               width: MediaQuery.of(context).size.width,
                    //               // height: 50,
                    //               margin: EdgeInsets.symmetric(vertical: 16),
                    //               padding: EdgeInsets.all(12),
                    //               decoration: BoxDecoration(
                    //                 color: snap.hasError
                    //                     ? CustomColor.errorStatusColor
                    //                     : CustomColor.successStatusColor,
                    //                 borderRadius: BorderRadius.circular(8.0),
                    //               ),
                    //               child: Row(
                    //                 children: [
                    //                   Icon(Icons.info,
                    //                       color: snap.hasError
                    //                           ? Colors.red
                    //                           : Colors.green),
                    //                   SizedBox(
                    //                     width: 8,
                    //                   ),
                    //                   Expanded(
                    //                     child: Text(
                    //                       snap.hasError
                    //                           ? snap.error.toString()
                    //                           : "Login Success",
                    //                       style: fontWeight400(
                    //                         size: 14.0,
                    //                         color: CustomColor.subTitle2,
                    //                       ),
                    //                     ),
                    //                   ),
                    //                   InkWell(
                    //                       onTap: () {
                    //                         // _forgotpasswordCubit.closeError();
                    //                       },
                    //                       child: Icon(Icons.close))
                    //                 ],
                    //               ),
                    //             )
                    //           : EmptyBox();
                    //     }),

                    Spacer(),
                    Consumer<ForgotPasswordProvider>(
                        builder: (context, provider, _) {
                      return CustomElevatedButton(
                        horizontalMargin: 4,
                        label: ConstantText.continueButton,
                        onTap: () {
                          provider.continueTapped(otpValue, context);
                        },
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),
          // StreamBuilder(
          //     stream: _forgotpasswordCubit.successOTPStream,
          //     builder: (context, snapshot) {
          //       return snapshot.data == false
          //           ? EmptyBox()
          //           : Container(
          //               padding:
          //                   EdgeInsets.symmetric(horizontal: 12, vertical: 9),
          //               decoration: BoxDecoration(
          //                   color: CustomColor.subTitle2,
          //                   borderRadius: BorderRadius.circular(34)),
          //               child: Text(ConstantText.sendOTPSuccessfully));
          //     }),
        ],
      ),
    );
  }
}

// class ErrorCard extends StatelessWidget {
//   const ErrorCard({
//     Key? key,
//     required ForgotpasswordCubit forgotpasswordCubit,
//   })  : _forgotpasswordCubit = forgotpasswordCubit,
//         super(key: key);

//   final ForgotpasswordCubit _forgotpasswordCubit;

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder(
//         stream: _forgotpasswordCubit.errorOTPStream,
//         builder: (context, snapShot) {
//           print(snapShot);
//           return Text(snapShot.hasError.toString());
//         });
//   }
// }
