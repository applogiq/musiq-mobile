import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:musiq/src/helpers/constants/color.dart';
import 'package:musiq/src/logic/cubit/forgot/cubit/forgotpassword_cubit.dart';
import 'package:musiq/src/logic/cubit/register/register_cubit.dart';

import '../../../../../../helpers/constants/string.dart';
import '../../../../../../helpers/constants/style.dart';
import '../../../../../../helpers/utils/navigation.dart';
import '../../../../../widgets/custom_app_bar.dart';
import '../../../../../widgets/custom_button.dart';

class OTPScreen extends StatelessWidget {
   OTPScreen({Key? key, required this.email}) : super(key: key);
  final String email;
  String otpValue="";
  @override
  Widget build(BuildContext context) {
    ForgotpasswordCubit _forgotpasswordCubit=ForgotpasswordCubit();

    return Scaffold(
      appBar: PreferredSize(
            preferredSize: Size(double.maxFinite, 80),
            child: Padding(
              padding: EdgeInsets.only(top:8.0),
              child: CustomAppBarWidget(
                title: ConstantText.otp,
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(children: [
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("An OTP has been sent to $email. Please enter the OTP below",textAlign: TextAlign.justify,),
                ),
                Padding(
                  padding: const EdgeInsets.only(top:24.0),
                  child: OtpTextField(
                    borderRadius: BorderRadius.circular(8.0),
                    margin: EdgeInsets.only(right: 16),
                    fieldWidth: 50,
        numberOfFields: 6,
enabledBorderColor: Colors.transparent,
        borderColor: Colors.transparent,
        filled: true,
        fillColor: CustomColor.textfieldBg,
        showFieldAsBox: true, 
        onCodeChanged: (String code) {
          print(code);
              //handle validation or checks here           
        },
        onSubmit: (otp){
          print(otp);
          otpValue=otp;
        },
        //runs when every textfield is filled
        // onSubmit: (String verificationCode){
        //       showDialog(
        //             context: context,
        //             builder: (context){
        //             return AlertDialog(
        //                 title: Text("Verification Code"),
        //                 content: Text('Code entered is $verificationCode'),
        //             );
                    // }
              // );
        // }, // end onSubmit
    ),
                ),
           Padding(padding: EdgeInsets.fromLTRB(0,16,16,0),
           child: Align(
        alignment: Alignment.centerRight,
        child: IntrinsicWidth(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                ConstantText.resendOTP,
                style: fontWeight400(),
              ),
              Container(margin: EdgeInsets.only(top: 2),height: 1,color: Colors.white,)
            ],
          ),
        ),
      ),
           ),
           StreamBuilder(stream: _forgotpasswordCubit.errorStream,builder: (context,snapShot){
            
            return Text(snapShot.hasError?"SSSSSSSSSSSSSSSSS":"");
           }),
           Padding(
             padding: const EdgeInsets.only(top:100.0),
             child: InkWell(
               onTap: (){
                if(otpValue.length==6){
                  ForgotpasswordCubit().verifyOTP(otpValue,email,context);
                }
                else{
                  print("Try Again");
                }
                    // Navigation.navigateToScreen(context,"newPassword/");
                  },
               child: CustomButton(label: ConstantText.continueButton,margin: 0.0,),
             ),
           ),
            ],),
          ),
    );
  }
}