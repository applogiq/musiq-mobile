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
  var _forgotpasswordCubit;
  var routes;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _forgotpasswordCubit = BlocProvider.of<ForgotpasswordCubit>(context);
    // _forgotpasswordCubit.clearStreams;
    print("SSSSSSSSSSSSSSSSSRRRRRRRRRRRRRRRRRR");

    print(_forgotpasswordCubit.userEmailController.stream.value.toString());

    // if (routes != null) {
    //   email = routes["email"];
    //   print("DDDD");
    // }
    // print("ssss");
    // print(email.toString());
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
      body: SingleChildScrollView(
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
                  child: InkWell(onTap: (){
                    print(widget.email);
                  //  _forgotpasswordCubit.sendOTP(context,widget.email);
                  },
                    child: Text(
                      ConstantText.resendOTP,
                      style: fontWeight400(color:CustomColor.subTitle2 ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 100.0),
                child: InkWell(
                  onTap: () {
                    if (otpValue.length == 6) {
                      print("DDD");
                      _forgotpasswordCubit
                          .verifyOTP(otpValue, widget.email, context);
                    } else {
                      print("Try Again");
                    }
                    // Navigation.navigateToScreen(context,"newPassword/");
                  },
                  child: CustomButton(
                    label: ConstantText.continueButton,
                    margin: 0.0,
                  ),
                ),
              ),
            ],
          ),
        ),
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
