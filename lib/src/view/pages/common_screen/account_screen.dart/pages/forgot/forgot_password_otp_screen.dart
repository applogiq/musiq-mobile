import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:musiq/src/helpers/constants/color.dart';
import 'package:musiq/src/logic/cubit/forgot/cubit/forgotpassword_cubit.dart';

import '../../../../../../helpers/constants/string.dart';
import '../../../../../../helpers/constants/style.dart';
import '../../../../../widgets/custom_app_bar.dart';
import '../../../../../widgets/custom_button.dart';
import '../../../../../widgets/empty_box.dart';

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
  late ForgotpasswordCubit _forgotpasswordCubit;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _forgotpasswordCubit =ForgotpasswordCubit();
  
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _forgotpasswordCubit.close();
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
              height: MediaQuery.of(context).size.height-200,
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
                        numberOfFields: 6, focusedBorderColor: Colors.transparent,
                        enabledBorderColor: Colors.transparent,
                        borderColor: Colors.transparent,
                        filled: true,
                        fillColor: CustomColor.textfieldBg,
                        showFieldAsBox: true,
                        onCodeChanged: (String code) {
                          print(code);
                          //handle validation or checks here
                        },
                        onSubmit: (otp) {
                          print(otp);
                          otpValue = otp;
                        },
                        //runs when every textfield is filled
                        // onSubmit: (String verificationCode){
                        //       showDialog(
                        //             context: context,
                        //             builder: (context){
                        //             return AlertDialog(
                        //                 title: Text("Verification Code"),
                        //                 content: Text('Code entered is '),
                        //             );
                        // }
                        // );
                        // }, // end onSubmit
                      ),
                    ),
              
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 16, 16, 0),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: InkWell(
                          onTap: () {
                            print(widget.email);
                             _forgotpasswordCubit.resendOtp(context,email:widget.email);
                          },
                          child: Text(
                            ConstantText.resendOTP,
                            style: fontWeight400(color: CustomColor.subTitle2),
                          ),
                        ),
                      ),
                    ),
                     StreamBuilder(stream:_forgotpasswordCubit.errorOTPStream,builder: (context,snap){
                    print(snap.data);
                    return snap.hasError?Container(
                        width: MediaQuery.of(context).size.width,
                        // height: 50,
                        margin: EdgeInsets.symmetric(vertical: 16),
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: snap.hasError
                              ? CustomColor.errorStatusColor
                              : CustomColor.successStatusColor,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.info,
                                color: snap.hasError ? Colors.red : Colors.green),
                            SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              child: Text(
                                snap.hasError
                                    ? snap.error.toString()
                                    : "Login Success",
                                style: fontWeight400(
                                  size: 14.0,
                                  color: CustomColor.subTitle2,
                                ),
                              ),
                            ),
                            InkWell(
                                onTap: () {
                            _forgotpasswordCubit.closeError();
                                },
                                child: Icon(Icons.close))
                          ],
                        ),
                    ):EmptyBox();
                   }),
                   Spacer(),
                    InkWell(
                      onTap: () {
                        if (otpValue.length == 6) {
                          print("DDD");
                          _forgotpasswordCubit.verifyOTP(
                              otpValue, widget.email, context);
                        } else {
                          print("Try Again");
                        }
                        // Navigation.navigateToScreen(context,"newPassword/");
                      },
                      child: StreamBuilder(
                        stream: _forgotpasswordCubit.loadingStream,
                        builder: (context, snapshot) {
                          return snapshot.data==true?CustomButton(label: ConstantText.continueButton,isLoading: true, verticalMargin: 0.0,horizontalMargin: 0.0,): CustomButton(
                            label: ConstantText.continueButton,
                            verticalMargin: 0.0,horizontalMargin: 0.0,
                          );
                        }
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
     StreamBuilder(
       stream: _forgotpasswordCubit.successOTPStream,
       builder: (context, snapshot) {
         return snapshot.data==false?EmptyBox(): Container(
          padding: EdgeInsets.symmetric(horizontal: 12,vertical: 9),
          decoration: BoxDecoration(
            color: CustomColor.subTitle2
            ,borderRadius: BorderRadius.circular(34)
          ),
          child: Text(ConstantText.sendOTPSuccessfully));
       }
     ),
        ],
      ),
    );
  }
}

class ErrorCard extends StatelessWidget {
  const ErrorCard({
    Key? key,
    required ForgotpasswordCubit forgotpasswordCubit,
  })  : _forgotpasswordCubit = forgotpasswordCubit,
        super(key: key);

  final ForgotpasswordCubit _forgotpasswordCubit;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _forgotpasswordCubit.errorOTPStream,
        builder: (context, snapShot) {
          print(snapShot);
          return Text(snapShot.hasError.toString());
        });
  }
}
