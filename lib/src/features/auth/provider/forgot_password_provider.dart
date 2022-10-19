import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:musiq/src/common_widgets/text/forgot_password.dart';
import 'package:musiq/src/features/auth/domain/models/forgot_password.dart';
import 'package:musiq/src/features/auth/domain/models/otp_model.dart';

import '../../../constants/string.dart';
import '../../../utils/validation.dart';
import '../screens/forgot_screen/forgot_otp_screen.dart';
import '../screens/forgot_screen/new_password.dart';
import 'package:http/http.dart' as http;

class ForgotPasswordProvider extends ChangeNotifier with InputValidationMixin {
  String emailAddress = "";
  String emailAddressErrorMessage = "";
  bool isButtonEnable=true;
  bool isLoad = false;
  String otpErrorMessage = "";
  ForgotPasswordModel?forgotPasswordModel;
   OTPvalidation _otp1 = OTPvalidation("", "",) ;
  OTPvalidation _otp2 = OTPvalidation("", "",);
  OTPvalidation _otp3= OTPvalidation("", "",);
  OTPvalidation _otp4 = OTPvalidation("", "",);
  OTPvalidation _otp5 = OTPvalidation("", "",);
  OTPvalidation _otp6 = OTPvalidation("", "",);
   OTPvalidation get otp1 => _otp1;
  OTPvalidation get otp2 => _otp2;
  OTPvalidation get otp3 => _otp3;
  OTPvalidation get otp4 => _otp4;
  OTPvalidation get otp5 => _otp5;
  OTPvalidation get otp6 => _otp6;
 var saveEmail="";
 void showGetvalue()async{
  apiGetvalue("email");
 }
 isClear(String value){
  otp1.value=="";
  otp2.value=="";
  otp3.value=="";
  otp4.value=="";
  otp5.value=="";
  otp6.value=="";
  notifyListeners();
 }

   FlutterSecureStorage secureStorage= const FlutterSecureStorage();
  void showAPiGetValues() async{
   apiGetvalue("email");
  }
   Future<void> _save(String key, String value) async {
    await secureStorage.write(key: key, value: value);
  }
 
  Future<String> apiGetvalue(String key) async {
    return await secureStorage.read(key: key) ?? "";
  }
  saveDetails() async {
   _save("email", emailAddress);
  }
 void otpValidation(String value){
    if(otp1.value.isEmpty
   
    ){
_otp1=OTPvalidation(value, "");
    }else{
_otp1=OTPvalidation(value, "Field is required");

    }
   notifyListeners();
  }

  otp2validation(String value){
    if(otp2.value.isNotEmpty){
      _otp2=OTPvalidation(value, "");
    }else{
      _otp2=OTPvalidation(value, "");
    }
 notifyListeners();
  }
    otp3validation(String value){
    if(otp3.value.isNotEmpty){
      _otp3=OTPvalidation(value, "");
    }else{
      _otp3=OTPvalidation(value, "");
    }
 notifyListeners();
  }

     otp4validation(String value){
    if(otp4.value.isNotEmpty){
      _otp4=OTPvalidation(value, "");
    }else{
      _otp4=OTPvalidation(value, "");
    }
 notifyListeners();
  }
  otp5validation(String value){
    if(otp5.value.isNotEmpty){
      _otp5=OTPvalidation(value, "");
    }else{
      _otp5=OTPvalidation(value, "");
    }
 notifyListeners();
  }
  otp6validation(String value){
    if(otp6.value.isNotEmpty){
      _otp6=OTPvalidation(value, "");
    }else{
      _otp6=OTPvalidation(value, "");
    }
 notifyListeners();
  }
  postotp()async{
        var storedEmail = await secureStorage.read(key: "email");
      var otp=otp1.value+otp2.value+otp3.value+otp4.value+otp5.value+otp6.value;
try {
              print("1");

      var response = await http.post(
          Uri.parse("https://api-musiq.applogiq.org/api/v1/users/email/otp-verify"),
          headers: {
            "Content-Type": "application/json",
                     },
          body: jsonEncode(
              {"email": storedEmail,
              "otp": otp1.value+otp2.value+otp3.value+otp4.value+otp5.value+otp6.value
              })
              );
          
              print(otp);
              print("2");
              print(response.statusCode);
              print(response.body);
              print("3");
              if(response.statusCode == 200){
       print("hi");
                            //  isClear();

              }
   }catch(e){
    print("1");
    print("uhu${e.toString()}");
   }
   notifyListeners();
  }
 
  buttonEnable(){

    if(emailAddress.isNotEmpty&&isEmailValid(emailAddress)){
     isButtonEnable=false;
    }else{
     isButtonEnable=true;
    }
    notifyListeners();
  }
  emailChanged(String value) {
    emailAddress = value;
    if (value.isEmpty) {
      emailAddressErrorMessage = "Field is required";
    } else if (!isEmailValid(value)) {
      emailAddressErrorMessage = ConstantText.invalidEmail;
    
    } else {
      emailAddressErrorMessage = "";
    }
    buttonEnable();
    notifyListeners();
  }
 login(BuildContext context)async{
   try {
              print("1");

      var response = await http.post(
          Uri.parse("https://api-musiq.applogiq.org/api/v1/users/email"),
          headers: {
            "Content-Type": "application/json",
                     },
          body: jsonEncode(
              {"email": emailAddress})
              );
              forgotPasswordModel=ForgotPasswordModel.fromJson(jsonDecode(response.body.toString()));
              saveEmail=forgotPasswordModel!.message.toString();
              print(saveEmail);
              
              // print("2");
              // print(response.statusCode);
             print(response.body);
              // print("3");
              if(response.statusCode == 200){

              Navigator.push((context), MaterialPageRoute(builder: ((context) => OTPScreen())));
              showAPiGetValues();
            await saveDetails();
              isClearError();
              }else{
                print("error");
              }
   }catch(e){
    print("1");
    print("uhu${e.toString()}");
   }
   notifyListeners();
 }

  isClearError(){
    emailAddressErrorMessage = "";
    isButtonEnable=true;
    notifyListeners();
  }
   isNotClearError(){
    isButtonEnable=false;
    notifyListeners();
  }

  sendOTP(
    BuildContext context,
  ) async {
    if (emailAddress.isEmpty) {
      emailAddressErrorMessage = ConstantText.fieldRequired;
    } else if (!isEmailValid(emailAddress.toString())) {
      emailAddressErrorMessage = ConstantText.invalidFormat;
    } else {
      Navigator.of(context).push(MaterialPageRoute(builder: (_) {
        return OTPScreen(
          // email: emailAddress,
        );
      }));
    }
    //   else {
    //     isLoad = true;
    //     notifyListeners();

    //     Map<String, dynamic> params = {
    //       "email": emailAddress,
    //     };
    //     print(params);
    //     var url = Uri.parse(
    //         APIConstants.BASE_URL.toString() + APIConstants.SEND_OTP.toString());
    //     print(url);
    //     try {
    //       var response = await http.post(url, body: jsonEncode(params), headers: {
    //         'Content-type': 'application/json',
    //         'Accept': 'application/json',
    //       });
    //       print(response.statusCode);
    //       isLoad = false;
    //       if (response.statusCode == 200) {
    //         Navigator.of(context).push(MaterialPageRoute(builder: (_) {
    //           return OTPScreen();
    //         }));
    //       } else if (response.statusCode == 404) {
    //         emailAddressErrorMessage = "Email not register";
    //       }
    //     } catch (e) {
    //       print(e.toString());
    //       isLoad = false;
    //     }
    //   }
    //   notifyListeners();
  }

  continueTapped(String otpValue, BuildContext context) {
    print(otpValue);
    if (otpValue.length == 6) {
      print("DDD");
      otpErrorMessage = "";
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => NewPasswordScreen(email: emailAddress)));
    } else {
      otpErrorMessage = "Fields are mandatory";
    }
    notifyListeners();
  }
}
