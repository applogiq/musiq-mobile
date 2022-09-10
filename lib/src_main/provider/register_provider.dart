import 'package:flutter/material.dart';
import 'package:musiq/src/constants/string.dart';
import 'package:musiq/src/helpers/utils/validation.dart';

class RegisterProvider extends ChangeNotifier with InputValidationMixin {
  String fullName = "";
  String fullNameError = "";
  String email = "";
  String emailError = "";
  String userName = "";
  String userNameError = "";

  String password = "";
  String passwordError = "";
  String confirmPassword = "";
  String confirmPasswordError = "";

  fullNameChanged(value) {
    fullName = value;
    if (value.isEmpty) {
      fullNameError = ConstantText.fieldRequired;
    } else {
      fullNameError = "";
    }
    notifyListeners();
  }

  emailChanged(value) {
    email = value;
    if (value.isEmpty) {
      emailError = ConstantText.fieldRequired;
    } else if (!isEmailValid(value)) {
      emailError = ConstantText.invalidEmail;
    } else {
      emailError = "";
    }
    notifyListeners();
  }

  emailTapped() {
    fullNameChanged(fullName);
  }

  userNameTapped() {
    fullNameChanged(fullName);
    emailChanged(email);
  }

  userNameChanged(value) {
    userName = value;
    if (value.isEmpty) {
      userNameError = ConstantText.fieldRequired;
    } else if (value.contains(" ")) {
      userNameError = ConstantText.invalidUserName;
    } else {
      userNameError = "";
    }
    notifyListeners();
  }

  passwordChanged(value) {
    password = value;
    if (value.isEmpty) {
      passwordError = "show toggle with field required";
    } else if (password.isNotEmpty && confirmPassword.isNotEmpty) {
      if (password.toString() == confirmPassword.toString()) {
        if (!validateStructure(password.toString())) {
          passwordError = "show toggle";
          confirmPasswordError = "";
        } else {
          passwordError = "";
          confirmPasswordError = "";
        }
      } else {
        if (!validateStructure(password.toString())) {
          passwordError = "show toggle";
        }
        confirmPasswordError = ConstantText.passwordNotMatch;
      }
    } else if (!validateStructure(password)) {
      passwordError = "show toggle";
    } else {
      passwordError = "";
      confirmPasswordError = "";
    }

    notifyListeners();
  }

  passwordTapped() {
    userNameChanged(userName);
    emailChanged(email);
    fullNameChanged(fullName);
    if (!validateStructure(password) || password.isEmpty) {
      passwordError = "show toggle";
    } else {
      passwordError = "";
    }
    notifyListeners();
  }

  confirmPasswordChanged(value) {
    confirmPassword = value;
    if (value.isEmpty) {
      confirmPasswordError = ConstantText.fieldRequired;
    } else if (password != confirmPassword) {
      confirmPasswordError = ConstantText.passwordNotMatch;
    } else {
      confirmPasswordError = "";
    }
    notifyListeners();
  }

  createAccount() async {
    userNameChanged(userName);
    emailChanged(email);
    fullNameChanged(fullName);
    if (password.isEmpty) {
      passwordError = ConstantText.fieldRequired;
    }
    if (confirmPassword.isEmpty) {
      confirmPasswordError = ConstantText.fieldRequired;
    }
  }

  confirmPasswordTapped() {
    userNameChanged(userName);
    emailChanged(email);
    fullNameChanged(fullName);
    if (password.isEmpty) {
      passwordError = "show toggle with field required";
    } else if (!validateStructure(password)) {
      passwordError = "show toggle with invalid";
    }
  }
}
