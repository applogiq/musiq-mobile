import 'package:flutter/material.dart';
import 'package:musiq/src/constants/string.dart';
import 'package:musiq/src/helpers/utils/validation.dart';

class LoginProvider extends ChangeNotifier with InputValidationMixin {
  String emailAddress = "";
  String emailAddressErrorMessage = "";
  String password = "";
  String passwordErrorMessage = "";
  emailAddressChanged(value) {
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

  passwordChanged(value) {
    password = value;
    if (value.isEmpty) {
      passwordErrorMessage = "Field is required";
    } else {
      passwordErrorMessage = "";
    }
    notifyListeners();
  }

  login() {
    print("hhj");
    print(emailAddress);
    print(password);
  }

  passwordTap() {
    emailAddressChanged(emailAddress);
  }
}
