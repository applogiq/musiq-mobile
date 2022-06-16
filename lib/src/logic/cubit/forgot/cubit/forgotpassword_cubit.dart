

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musiq/src/helpers/utils/navigation.dart';
import 'package:musiq/src/helpers/utils/validation.dart';
import 'package:musiq/src/view/pages/common_screen/account_screen.dart/pages/forgot/forgot_password_otp_screen.dart';
import 'package:musiq/src/view/pages/common_screen/account_screen.dart/pages/forgot/new_password.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../helpers/constants/api.dart';
import 'package:http/http.dart'as http;
import '../../../../helpers/constants/string.dart';

part 'forgotpassword_state.dart';

class ForgotpasswordCubit extends Cubit<ForgotpasswordState>with InputValidationMixin   {
  ForgotpasswordCubit() : super(ForgotpasswordInitial());
   final userEmailController = BehaviorSubject<String>.seeded("");
  final passwordController = BehaviorSubject<String>.seeded("");
  final confirmPasswordController = BehaviorSubject<String>.seeded("");
   final isLoading=BehaviorSubject<bool>.seeded(false);
   final isError=BehaviorSubject<bool>.seeded(false);
 
  
  Stream<String> get userEmailStream => userEmailController.stream;
  Stream<String> get passwordStream => passwordController.stream;
  Stream<String> get confirmPasswordStream => confirmPasswordController.stream;
  
  Stream<bool> get loadingStream => isLoading.stream;
  Stream<bool> get errorStream => isError.stream;
  void updateUserEmail(String text) {

isError.sink.add(true);
     if(text.isEmpty){
      userEmailController.sink.add("");
      userEmailController.sink.addError(ConstantText.fieldRequired);
    }
    else if(!isEmailValid(text)){

       userEmailController.sink.addError(ConstantText.invalidEmail);
    
    }
    else{
       userEmailController.sink.add(text);
      
    }
  }

  void updateUserNewPassword(String text) {
    print(text);
  passwordController.sink.add(text);
     if(text.isEmpty){
    
      passwordController.sink.add("");
      passwordController.sink.addError(ConstantText.fieldRequired);
      confirmPasswordController.sink.addError("");
    }
    else if(passwordController.value.isNotEmpty&&confirmPasswordController.value.isNotEmpty){
 

      if(passwordController.value.toString()==confirmPasswordController.value.toString()){
        if(!validateStructure(passwordController.value.toString())){
                     passwordController.sink.addError("Invalid Format");

        }
        confirmPasswordController.sink.add(passwordController.value.toString());
        
      }
      else{
         if(!validateStructure(passwordController.value.toString())){
          passwordController.sink.addError("Invalid Format");
        }
        print("Not match");
        confirmPasswordController.sink.addError(ConstantText.passwordNotMatch);

      }
    }
    else if(!validateStructure(passwordController.value.toString())){
          passwordController.sink.addError("Invalid Format");
      
    }
    
}

  void updateUserConfirmPassword(String text) {
  confirmPasswordController.sink.add(text);
  if(text.isEmpty){
    confirmPasswordController.sink.add("");
    confirmPasswordController.sink.addError(ConstantText.fieldRequired);
  }
   if(passwordController.value.isNotEmpty&&confirmPasswordController.value.isNotEmpty){
      if(passwordController.value.toString()==confirmPasswordController.value.toString()){
        print("Match");
      }
      else{
        confirmPasswordController.sink.addError(ConstantText.passwordNotMatch);
      }
    }
  }
void confirmPasswordTap() {
     if(passwordController.value.isEmpty){
      passwordController.sink.addError(ConstantText.fieldRequired);
    }
    else if(!validateStructure(passwordController.value.toString())){
      passwordController.sink.addError(ConstantText.invalidEmail);
    }
  }
   Stream<bool> get validateForm => Rx.combineLatest2(
    confirmPasswordStream,
    passwordStream,
        (a, b,) => true,
  );

  void sendOTP(BuildContext context)async {
    if(userEmailController.value.isEmpty){
      userEmailController.sink.addError(ConstantText.fieldRequired);
    }
    else if(!isEmailValid(userEmailController.value)){
  userEmailController.sink.addError(ConstantText.invalidEmail);
    
    }
    else{
     isLoading.sink.add(true);
    
  Map<String, dynamic> params = {
   "email": userEmailController.stream.value,
 
    };
    print(params);
        var url=Uri.parse(APIConstants.BASE_URL.toString()+APIConstants.SEND_OTP.toString());
   print(url);
   try{

    var response=await http.post(url, body: jsonEncode(params), headers: { 'Content-type': 'application/json',
              'Accept': 'application/json',
              });
print(response.statusCode);
if(response.statusCode==200){
  // Navigation.navigateToScreen(context, "forgotOTP/");
  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>OTPScreen(email: userEmailController.stream.value,)));
  isLoading.sink.add(false);

}
else if(response.statusCode==404){
  isLoading.sink.add(false);
  isError.sink.addError("Email not register");
  print("OOOO");
}
isLoading.sink.add(false);

}

catch(e){print(e.toString());
isLoading.sink.add(false);
}
     }

    
  }
   void verifyOTP(String otpValue, String email,BuildContext context)async {
  //     "email": "shajith2243265@gmail.com",
  // "otp": "337692"
   isLoading.sink.add(true);
    
  Map<String, dynamic> params = {
       "email": email,
  "otp": otpValue
    };
    print(params);
        var url=Uri.parse(APIConstants.BASE_URL.toString()+APIConstants.OTP_VERIFY.toString());
   print(url);
   try{

    var response=await http.post(url, body: jsonEncode(params), headers: { 'Content-type': 'application/json',
              'Accept': 'application/json',
              });
print(response.statusCode);
if(response.statusCode==200){
  // Navigation.navigateToScreen(context, "forgotOTP/");
  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>NewPasswordScreen(email: userEmailController.stream.value,)));
  isLoading.sink.add(false);

}
else if(response.statusCode==400){
  isError.sink.addError("OTP Expired");
  print(isError.value.toString());
  print("NEB");
}
isLoading.sink.add(false);

}

catch(e){print(e.toString());
isLoading.sink.add(false);
}
   }
  


}