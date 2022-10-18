import 'package:flutter/cupertino.dart';
import 'package:musiq/src/constants/string.dart';
import 'package:musiq/src/utils/validation.dart';

class NewPasswordProcvider extends ChangeNotifier with InputValidationMixin{
String password="";
String passwordError="";
String confirmPassword="";
String confirmPasswordError="";
passwordChanged(value){
password = value;
    if (value.isEmpty) {
      passwordError = "show toggle with field required";
    } 
    else if (password.isNotEmpty && confirmPassword.isNotEmpty) {
      if (password.toString() == confirmPassword.toString()) {
        if (!validateStructure(password.toString())) {
          passwordError = "show toggle";
          confirmPasswordError = "";
        } else {
          passwordError = "";
          confirmPasswordError = "";
        }
      }
       else {

        if (!validateStructure(password.toString())) {
          passwordError = "show toggle";
        }
        confirmPasswordError = ConstantText.passwordNotMatch;
      }
    } 
    else if (!validateStructure(password)) {
      passwordError = "show toggle";
    } 
    else {
      passwordError = "";
      confirmPasswordError = "";
    }

    notifyListeners();
}
 confirmPasswordChanged(value) {
    confirmPassword = value;
    if (value.isEmpty) {
      confirmPasswordError = ConstantText.fieldRequired;
    } 
    notifyListeners();
  }

 passwordTapped() {
 
    if (!validateStructure(password) || password.isEmpty) {
      passwordError = "show toggle";
    } else {
      passwordError = "";
    }
    notifyListeners();
  }
    confirmPasswordTapped() {
   passwordChanged(password);
    if (password.isEmpty) {
      passwordError = "show toggle with field required";
    } else if (!validateStructure(password)) {
      passwordError = "show toggle with invalid";
    }
  }
}