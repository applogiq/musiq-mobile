

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musiq/src/helpers/utils/navigation.dart';
import 'package:musiq/src/helpers/utils/validation.dart';
import 'package:musiq/src/view/pages/common_screen/account_screen.dart/login_screen.dart';
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
   final isOTPError=BehaviorSubject<bool>.seeded(false);
   final isOTPSend=BehaviorSubject<bool>.seeded(false);
 
  
  Stream<String> get userEmailStream => userEmailController.stream;
  Stream<String> get passwordStream => passwordController.stream;
  Stream<String> get confirmPasswordStream => confirmPasswordController.stream;
  
  Stream<bool> get loadingStream => isLoading.stream;
  Stream<bool> get errorStream => isError.stream;
  Stream<bool> get errorOTPStream => isOTPError.stream;
  Stream<bool> get successOTPStream => isOTPSend.stream;
  clearStreams() {
      isError.close();
      isLoading.close();
      isOTPError.close();
     userEmailController.close();
     passwordController.close();
     confirmPasswordController.close();
print("STREAMS CLEAR");
  }
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
                     passwordController.sink.addError("show toggle");

        }
        confirmPasswordController.sink.add(passwordController.value.toString());
        
      }
      else{
         if(!validateStructure(passwordController.value.toString())){
          passwordController.sink.addError("show toggle");
        }
        print("Not match");
        confirmPasswordController.sink.addError(ConstantText.passwordNotMatch);

      }
    }
    else if(!validateStructure(passwordController.value.toString())){
          passwordController.sink.addError("show toggle");
      
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
      passwordController.sink.addError(ConstantText.invalidFormat);
    }
  }
   Stream<bool> get validateForm => Rx.combineLatest2(
    confirmPasswordStream,
    passwordStream,
        (a, b,) => true,
  );

   sendOTP(BuildContext context, {String email=""})async {
    if(userEmailController.value.isEmpty){
      userEmailController.sink.addError(ConstantText.fieldRequired);
    }
    else if(!isEmailValid(userEmailController.value)){
  userEmailController.sink.addError(ConstantText.invalidFormat);
    
    }
    else{
     isLoading.sink.add(true);
    
  Map<String, dynamic> params = {
   "email":email.isEmpty? userEmailController.stream.value:email,
 
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
    isLoading.sink.add(false);
  // Navigation.navigateToScreen(context, "forgotOTP/");
 //  if(email.isEmpty){
 Navigator.of(context).push(MaterialPageRoute(builder: (_){
    return OTPScreen(email:email.length==0?userEmailController.stream.value.toString():email ,);
  }));
 
//  }


}
else if(response.statusCode==404){
  isLoading.sink.add(false);
  isError.sink.addError("Email not register");
 
}
isLoading.sink.add(false);

}

catch(e){print(e.toString());
isLoading.sink.add(false);
}
     }

    
  }



closeError(){
  isOTPError.sink.add(false);
}


//     verifyOTP(String otpValue, String email,BuildContext context)async {
  
//    isLoading.sink.add(true);
//    isOTPError.sink.add(true);
    
//   Map<String, dynamic> params = {
//        "email": email,
//         "otp": otpValue
//     };
//         var url=Uri.parse(APIConstants.BASE_URL.toString()+APIConstants.OTP_VERIFY.toString());
//    try{

//     var response=await http.post(url, body: jsonEncode(params), headers: { 'Content-type': 'application/json',
//               'Accept': 'application/json',
//               });
//               print(response.statusCode);
// if(response.statusCode==200){
//    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>NewPasswordScreen(email: email,)));
//   isLoading.sink.add(false);

// }
// else if(response.statusCode==400){
  
//   isOTPError.sink.add(true);
//   print(isOTPError.value.toString());
// var message=jsonDecode(response.body);
// print(message["detail"]["message"]);
// if(message["detail"]["message"]=="check your OTP"){
//   print("INVALID OTP");
// }
// else if(message["detail"]["message"]=="OTP expired"){
//   print("SSSS");
// }
 
// }
// isLoading.sink.add(false);
 
// }

// catch(e){print(e.toString());
// isLoading.sink.add(false);
// isOTPError.sink.addError("Email not register");
 
// }
//      }
   
  void verifyOTP(String otpValue, String email, BuildContext context)async {
    print(otpValue);
    print(email);
       isLoading.sink.add(true);
      Map<String, dynamic> params = {
       "email": email,
        "otp": otpValue
    };
        var url=Uri.parse(APIConstants.BASE_URL.toString()+APIConstants.OTP_VERIFY.toString());
print(url);
      try{

    var response=await http.post(url, body: jsonEncode(params), headers: { 'Content-type': 'application/json',
              'Accept': 'application/json',
              });
              print(response.statusCode);
              if(response.statusCode==200){
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>NewPasswordScreen(email: email)));
                isOTPError.sink.add(false);
                isLoading.sink.add(false);
              }
              else if(response.statusCode==400){

       var message=jsonDecode(response.body);
print(message["detail"]["message"]);
if(message["detail"]["message"]=="check your OTP"){
    isOTPError.sink.addError(ConstantText.invalidOTP);
     
}
else if(message["detail"]["message"]=="OTP expired"){
  isOTPError.sink.addError(ConstantText.expiredOTP);
     }
              }
      }
      catch(e){
        print(e.toString());
      }
await Future.delayed(Duration(milliseconds: 700),(){
       isLoading.sink.add(false);

});
  }



//   void changePassword(String email, String password,BuildContext context)async {
  
//    isLoading.sink.add(true);
//    isError.sink.add(true);
    
//   Map<String, dynamic> params = {
//        "email": email,
//         "password": password
//     };
//     print(params);
//         var url=Uri.parse(APIConstants.BASE_URL.toString()+APIConstants.PASSWORD_CHANGE.toString());
//    try{

//     var response=await http.put(url, body: jsonEncode(params), headers: { 'Content-type': 'application/json',
//               'Accept': 'application/json',
//               });
//               print(response.statusCode);
// if(response.statusCode==200){
//    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>LoginScreen()));
//   isLoading.sink.add(false);

// }
// else if(response.statusCode==400){
//   isLoading.sink.add(false);
//   print("ERRR");
//   try{
// isError.sink.addError("Email not register");
// print("ERRRR12");print(isError.error);
  
//   }
//    catch(e)
//    {
// print("ERRRR1");
//    }
 
// }
// isLoading.sink.add(false);
 
// }

// catch(e){print(e.toString());
// isLoading.sink.add(false);
// isError.sink.addError("Email not register");
 
// }
//      }

void passwordTap() {
  
    if(passwordController.value.isEmpty){
      passwordController.sink.addError("show toggle");
    }
    else if(!validateStructure(passwordController.value.toString())){
       passwordController.sink.addError("show toggle");
   
    }
  }

  void resendOtp(BuildContext context, {required String email})async {
    print("RESEND OTP");
    print(email);
     Map<String, dynamic> params = {
   "email":email,
 
    };
    print(params);
        var url=Uri.parse(APIConstants.BASE_URL.toString()+APIConstants.SEND_OTP.toString());
   print(url);
   try{

    var response=await http.post(url, body: jsonEncode(params), headers: { 'Content-type': 'application/json',
              'Accept': 'application/json',
              });
              print(response.statusCode);
              print(response.body);
              if(response.statusCode==200){
isOTPSend.sink.add(true);
Future.delayed(Duration(seconds: 2),(){
  isOTPSend.sink.add(false);
});
              }
  }
  catch(e){
    print(e.toString());
  }}

  void changePassword(String email, String password, BuildContext context) async{
    isLoading.sink.add(true);
    Map<String, dynamic> params = {
       "email": email,
        "password": password
    };
    print(params);
        var url=Uri.parse(APIConstants.BASE_URL.toString()+APIConstants.PASSWORD_CHANGE.toString());
        print(url);
        try{
              var response=await http.put(url, body: jsonEncode(params), headers: { 'Content-type': 'application/json',
              'Accept': 'application/json',
              });
              print(response.statusCode);
              if(response.statusCode==200){
isLoading.sink.add(false);
  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>LoginScreen(passwordReset: true,)));

              }
              else{
                isLoading.sink.add(false);

              }
        }
        catch(e){
          print(e.toString());
          isLoading.sink.add(false);

        }
 
  }
}