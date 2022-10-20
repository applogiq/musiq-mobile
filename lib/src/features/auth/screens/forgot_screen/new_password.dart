import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:musiq/src/common_widgets/app_bar.dart';
import 'package:musiq/src/common_widgets/buttons/custom_elevated_button.dart';
import 'package:musiq/src/common_widgets/text_field/custom_password_text_field.dart';
import 'package:musiq/src/constants/string.dart';
import 'package:musiq/src/constants/style.dart';
import 'package:musiq/src/features/auth/provider/forgot_password_provider.dart';
import 'package:musiq/src/features/auth/provider/new_password_provider.dart';
import 'package:musiq/src/utils/size_config.dart';
import 'package:provider/provider.dart';

class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({Key? key, }) : super(key: key);
  // final String email;

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  // late ForgotpasswordCubit _forgotpasswordCubit;
  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    super.dispose();
    // _forgotpasswordCubit.close();
  }

  @override
  Widget build(BuildContext context) {
    var newProvider= Provider.of<ForgotPasswordProvider>(context);
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size(double.maxFinite, 80),
          child: Padding(
            padding: EdgeInsets.only(top: 8.0),
            child:AppBar(
      toolbarHeight: 64,
      titleSpacing: 0.1,
      leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          newProvider.clearOTPvalue();
          newProvider.otpButtonEnable = true;
          },
          child: Icon(Icons.arrow_back_ios_rounded)),
      title: Text("Reset Password",style: TextStyle(color: Colors.white),),
      
    )
          ),
        ),
body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      // newProvider.updatePassword();
                    },
                    child: Text(
                      ConstantText.resetPassswordTitle,
                      style: fontWeight400(size: 14.0),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 24.0),
                  child: PasswordTextFieldWithError(
                      isPassword: true,
                      errorMessage: newProvider.newPasswordError,
                      label: ConstantText.resetPassswordNew,
                      onTap: () {
                    newProvider.passwordTapped();
                      },
                      isValidatorEnable: true,
                      onChange: (value) {
                    newProvider.passwordChanged(value);
                      }),
                ),
                PasswordTextFieldWithError(
                    isPassword: true,
                    errorMessage: newProvider.confirmPasswordError,
                    label: ConstantText.confirmPassword,
                    onTap: () {
                    newProvider.confirmPasswordTapped();
                
                    },
                    isValidatorEnable: true,
                    onChange: (value) {
                    newProvider.confirmPasswordChanged(value);
                    }),

                    
                Padding(
                  padding: const EdgeInsets.only(top: 60),
                  child:newProvider.isResetButtonEnable?Container(
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
                                 newProvider.updatePassword(context);
                          // provider.continueTapped(otpValue, context);
                         
                              },
                              child: Container(
                                height: getProportionateScreenHeight(52),
                                width: double.maxFinite,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: const Color.fromRGBO(254, 86, 49, 1)),
                                child: Center(
                                  child:newProvider.emailButtonLoad? Text(
                                    "Continues",
                                    style: fontWeight500(
                                        size: 16.0,
                                        color:
                                            const Color.fromRGBO(255, 255, 255, 0.75)),
                                  ):CircularProgressIndicator(color: Colors.white,)
                                ),
                              ),
                            )            
                      
                      //  CustomElevatedButton(
                      //    onTap: () {
                      //     newProvider.updatePassword(context);
                      //    },
                      //    label: ConstantText.resetPasssword,
                      //    isLoading: false,
                      //    verticalMargin: 0.0,
                      //    horizontalMargin: 0.0,
                      //  )
                  
                )
              ],
            ),
          ),
        ), 








        );
  }
}
