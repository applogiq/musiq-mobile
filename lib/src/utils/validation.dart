import 'package:flutter/material.dart';

mixin InputValidationMixin {
  bool isPasswordValid(String password) => password.length >= 8;

  bool isEmailValid(String email) {
    debugPrint("email");
    debugPrint(email);
    bool emailValid = RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
        .hasMatch(email);
    // debugPrint(emailValid);
    return emailValid;
  }

  bool passwordMatch(String password, String confirmPassword) {
    bool match = false;
    if (password == confirmPassword) {
      match = true;
    }
    return match;
  }

  bool isPhoneNumberValid(String email) {
    bool phoneNumberValid =
        RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)').hasMatch(email);
    // debugPrint(phoneNumberValid);
    return phoneNumberValid;
  }

  bool isFirstNameValid(String email) {
    bool firstNameValid = RegExp('[a-zA-Z]').hasMatch(email);
    // debugPrint(firstNameValid);
    return firstNameValid;
  }

  bool validateStructure(String value) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(value);
  }
}
