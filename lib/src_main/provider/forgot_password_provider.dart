import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:musiq/src/helpers/utils/validation.dart';
import 'package:musiq/src_main/screen/auth_screen/forgot_screen/forgot_otp_screen.dart';

import '../constants/api.dart';
import '../constants/string.dart';
import 'package:http/http.dart' as http;

import '../screen/auth_screen/forgot_screen/new_password.dart';

class ForgotPasswordProvider extends ChangeNotifier with InputValidationMixin {
  String emailAddress = "";
  String emailAddressErrorMessage = "";
  bool isLoad = false;
  String otpErrorMessage = "";
  emailChanged(String value) {
    emailAddress = value;
    if (value.isEmpty) {
      emailAddressErrorMessage = "Field is required";
    } else if (!isEmailValid(value)) {
      emailAddressErrorMessage = ConstantText.invalidEmail;
    } else {
      emailAddressErrorMessage = "";
    }
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
          email: emailAddress,
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
