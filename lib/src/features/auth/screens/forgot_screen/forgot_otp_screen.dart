import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:musiq/src/features/auth/screens/forgot_screen/new_password.dart';
import 'package:musiq/src/features/auth/screens/otp_field.dart';
import 'package:musiq/src/features/auth/widgets/otp_widget.dart';
import 'package:musiq/src/utils/size_config.dart';
import 'package:provider/provider.dart';

import '../../../../common_widgets/app_bar.dart';
import '../../../../common_widgets/buttons/custom_elevated_button.dart';
import '../../../../constants/color.dart';
import '../../../../constants/string.dart';
import '../../../../constants/style.dart';
import '../../provider/forgot_password_provider.dart';

class OTPScreens extends StatefulWidget {
  OTPScreens({
    Key? key,
    this.email = "",
  }) : super(key: key);
  String email;

  @override
  State<OTPScreens> createState() => _OTPScreensState();
}

class _OTPScreensState extends State<OTPScreens> {
  final TextEditingController fieldOne = TextEditingController();
  final TextEditingController fieldTwo = TextEditingController();
  final TextEditingController fieldThree = TextEditingController();
  final TextEditingController fieldfour = TextEditingController();
  final TextEditingController fieldFive = TextEditingController();
  final TextEditingController fieldSix = TextEditingController(); 
  bool otpButtonEnable = true;
  String otpValue = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    fieldOne.dispose();
    fieldTwo.dispose();
    fieldThree.dispose();
    fieldfour.dispose();
    fieldFive.dispose();
    fieldSix.dispose();
    ForgotPasswordProvider().isClear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<ForgotPasswordProvider>(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size(double.maxFinite, 80),
        child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: AppBar(
              toolbarHeight: 64,
              titleSpacing: 0.1,
              leading: InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                    // provider.clearOTPError("");
                     provider.isNotClearError();
                    //  provider.buttonEnable();
                    fieldOne.clear();
                              fieldTwo.clear();
                              fieldThree.clear();
                              fieldfour.clear();
                              fieldFive.clear();
                              fieldSix.clear();
                              FocusScope.of(context).unfocus();
                  },
                  child: const Icon(Icons.arrow_back_ios_rounded)),
              title: Text(ConstantText.otp),
            )),
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height - 200,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: getProportionateScreenWidth(16)),
                    child: InkWell(
                        onTap: () {},
                        child:  Text(
                            "An OTP has been sent to ${provider.emailAddress}. \nPlease enter the OTP below")),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: getProportionateScreenWidth(16)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 45,
                          width: 46,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: const Color.fromRGBO(255, 255, 255, 0.1),
                          ),
                          child: Center(
                            child: TextField(
                              controller: fieldOne,
                              textAlign: TextAlign.center,
                              decoration: const InputDecoration(
                                  border: InputBorder.none),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(1),
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              style: const TextStyle(color: Colors.white),
                              cursorColor: Colors.white,
                              //  autofocus: true,
                              onChanged: (value) {
                                provider.otpValidation(value);
                                if (value.length == 1) {
                                  FocusScope.of(context).nextFocus();
                                } else if (value.length == 0) {
                                  FocusScope.of(context).unfocus();
                                }else if(fieldOne.text.isNotEmpty&&
                                         fieldOne.text.isNotEmpty&&
                                         fieldOne.text.isNotEmpty&&
                                         fieldOne.text.isNotEmpty&&
                                         fieldOne.text.isNotEmpty&&
                                         fieldOne.text.isNotEmpty
                                  ) {
                                   otpButtonEnable = true;
                                }else{
                                   otpButtonEnable = false;
                                  
                                }
                              },
                            ),
                          ),
                        ),
                        Container(
                          height: 45,
                          width: 46,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: const Color.fromRGBO(255, 255, 255, 0.1),
                          ),
                          child: Center(
                            child: TextField(
                              controller: fieldTwo,

                              textAlign: TextAlign.center,
                              decoration: const InputDecoration(
                                  border: InputBorder.none),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(1),
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              style: const TextStyle(color: Colors.white),
                              cursorColor: Colors.white,
                              //  autofocus: true,
                              onChanged: (value) {
                                provider.otp2validation(value);
                                print(value);
                                if (value.length == 1) {
                                  FocusScope.of(context).nextFocus();
                                } else if (value.length == 0) {
                                  FocusScope.of(context).previousFocus();
                                }else if(fieldOne.text.isNotEmpty&&
                                         fieldOne.text.isNotEmpty&&
                                         fieldOne.text.isNotEmpty&&
                                         fieldOne.text.isNotEmpty&&
                                         fieldOne.text.isNotEmpty&&
                                         fieldOne.text.isNotEmpty
                                  ) {
                                   otpButtonEnable = true;
                                }else{
                                   otpButtonEnable = false;
                                  
                                }
                              },
                            ),
                          ),
                        ),
                        Container(
                          height: 45,
                          width: 46,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: const Color.fromRGBO(255, 255, 255, 0.1),
                          ),
                          child: Center(
                            child: TextField(
                              controller: fieldThree,
                              textAlign: TextAlign.center,
                              decoration: const InputDecoration(
                                  border: InputBorder.none),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(1),
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              style: const TextStyle(color: Colors.white),
                              cursorColor: Colors.white,
                              //  autofocus: true,
                              onChanged: (value) {
                                provider.otp3validation(value);
                                print(value);
                                if (value.length == 1) {
                                  FocusScope.of(context).nextFocus();
                                } else if (value.length == 0) {
                                  FocusScope.of(context).previousFocus();
                                }else if(fieldOne.text.isNotEmpty&&
                                         fieldOne.text.isNotEmpty&&
                                         fieldOne.text.isNotEmpty&&
                                         fieldOne.text.isNotEmpty&&
                                         fieldOne.text.isNotEmpty&&
                                         fieldOne.text.isNotEmpty
                                  ) {
                                   otpButtonEnable = true;
                                }else{
                                   otpButtonEnable = false;
                                  
                                }
                              },
                            ),
                          ),
                        ),
                        Container(
                          height: 45,
                          width: 46,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: const Color.fromRGBO(255, 255, 255, 0.1),
                          ),
                          child: Center(
                            child: TextField(
                              controller: fieldfour,

                              textAlign: TextAlign.center,
                              decoration: const InputDecoration(
                                  border: InputBorder.none),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(1),
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              style: const TextStyle(color: Colors.white),
                              cursorColor: Colors.white,
                              //  autofocus: true,
                              onChanged: (value) {
                                provider.otp4validation(value);
                                print(value);
                                if (value.length == 1) {
                                  FocusScope.of(context).nextFocus();
                                } else if (value.length == 0) {
                                  FocusScope.of(context).previousFocus();
                                }else if(fieldOne.text.isNotEmpty&&
                                         fieldOne.text.isNotEmpty&&
                                         fieldOne.text.isNotEmpty&&
                                         fieldOne.text.isNotEmpty&&
                                         fieldOne.text.isNotEmpty&&
                                         fieldOne.text.isNotEmpty
                                  ) {
                                   otpButtonEnable = true;
                                }else{
                                   otpButtonEnable = false;
                                  
                                }
                              },
                            ),
                          ),
                        ),
                        Container(
                          height: 45,
                          width: 46,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: const Color.fromRGBO(255, 255, 255, 0.1),
                          ),
                          child: Center(
                            child: TextField(
                              controller: fieldFive,
                              textAlign: TextAlign.center,
                              decoration: const InputDecoration(
                                  border: InputBorder.none),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(1),
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              style: const TextStyle(color: Colors.white),
                              cursorColor: Colors.white,
                              //  autofocus: true,
                              onChanged: (value) {
                                provider.otp5validation(value);
                                print(value);
                                if (value.length == 1) {
                                  FocusScope.of(context).nextFocus();
                                } else if (value.length == 0) {
                                  FocusScope.of(context).previousFocus();
                                }else if(fieldOne.text.isNotEmpty&&
                                         fieldOne.text.isNotEmpty&&
                                         fieldOne.text.isNotEmpty&&
                                         fieldOne.text.isNotEmpty&&
                                         fieldOne.text.isNotEmpty&&
                                         fieldOne.text.isNotEmpty
                                  ) {
                                   otpButtonEnable = true;
                                }else{
                                   otpButtonEnable = false;
                                  
                                }
                              },
                            ),
                          ),
                        ),
                        Container(
                          height: 45,
                          width: 46,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: const Color.fromRGBO(255, 255, 255, 0.1),
                          ),
                          child: Center(
                            child: TextField(
                              controller: fieldSix,
                              textAlign: TextAlign.center,
                              decoration: const InputDecoration(
                                  border: InputBorder.none),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(1),
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              style: const TextStyle(color: Colors.white),
                              cursorColor: Colors.white,
                              //  autofocus: true,
                              onChanged: (value) {
                                provider.otp6validation(value);
                                print(value);
                                if (value.length == 1) {
                                  FocusScope.of(context).unfocus();
                                } else if (value.length == 0) {
                                  FocusScope.of(context).previousFocus();
                                }else if(fieldOne.text.isNotEmpty&&
                                         fieldOne.text.isNotEmpty&&
                                         fieldOne.text.isNotEmpty&&
                                         fieldOne.text.isNotEmpty&&
                                         fieldOne.text.isNotEmpty&&
                                         fieldOne.text.isNotEmpty
                                  ) {
                                   otpButtonEnable = true;
                                }else{
                                   otpButtonEnable = false;
                                  
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: getProportionateScreenWidth(16)),
                        child: Text(
                         "",
                          style: const TextStyle(
                              color: Color.fromRGBO(234, 41, 41, 1)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 16, 16, 0),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                             
                              provider.resendOTP(context);
                               fieldOne.clear();
                              fieldTwo.clear();
                              fieldThree.clear();
                              fieldfour.clear();
                              fieldFive.clear();
                              fieldSix.clear();
                              FocusScope.of(context).unfocus();

                              // OTPScreen();
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
                  const Spacer(),
                  Consumer<ForgotPasswordProvider>(
                      builder: (context, provider, _) {
                    return Padding(
                      padding:  EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(16)),
                      child:
            
           provider.otpButtonEnable?Container(
                              height: getProportionateScreenHeight(52),
                              width: double.maxFinite,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: const Color.fromRGBO(96, 20, 20, 1)),
                              child: Center(
                                child: Text(
                                  "Continue",
                                  style: fontWeight500(
                                      size: 16.0,
                                      color:
                                          const Color.fromRGBO(255, 255, 255, 0.75)),
                                ),
                              ),
                            ):InkWell(
                              onTap: () {
                                 provider.postotp(context);
                                   fieldOne.clear();
                              fieldTwo.clear();
                              fieldThree.clear();
                              fieldfour.clear();
                              fieldFive.clear();
                              fieldSix.clear();
                              FocusScope.of(context).unfocus();
                          provider.continueTapped(otpValue, context);
                         
                              },
                              child: Container(
                                height: getProportionateScreenHeight(52),
                                width: double.maxFinite,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: const Color.fromRGBO(254, 86, 49, 1)),
                                child: Center(
                                  child:provider.emailButtonLoad? Text(
                                    "Continue",
                                    style: fontWeight500(
                                        size: 16.0,
                                        color:
                                            const Color.fromRGBO(255, 255, 255, 0.75)),
                                  ):CircularProgressIndicator(color: Colors.white,)
                                ),
                              ),
                            )              
                      
                      
                    );
                  }),
                  Spacer()
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
