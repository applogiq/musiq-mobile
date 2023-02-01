// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:musiq/src/features/auth/domain/repository/auth_repo.dart';
import 'package:musiq/src/features/auth/provider/login_provider.dart';
import 'package:musiq/src/features/auth/screens/login_screen.dart';
import 'package:musiq/src/routing/route_name.dart';
import 'package:musiq/src/utils/navigation.dart';
import 'package:musiq/src/utils/validation.dart';
import 'package:provider/provider.dart';

import '../../../constants/string.dart';

class ForgotPasswordProvider extends ChangeNotifier with InputValidationMixin {
  String confirmPassword = "";
  String confirmPasswordErrorMessage = "";
  int countTimer = 30;
  String emailAddress = "";
  String emailAddressErrorMessage = "";
  bool isEmailButtonEnable = false;
  bool isEmailLoading = false;
  bool isOTPButtonEnable = false;
  bool isOTPLoading = false;
  bool isResetButtonEnable = false;
  bool isResetLoading = false;
  bool isTimerShow = false;
  String newPassword = "";
  String newPasswordErrorMessage = "";
  final oneSecond = const Duration(seconds: 1);
  String otpErrorMessage = "";
  Timer? timer;

  void emailChanged(String value) {
    emailAddress = value;
    if (value.isEmpty) {
      emailAddressErrorMessage = "Field is required";
      buttonEmailStatus(false);
    } else if (!isEmailValid(value)) {
      emailAddressErrorMessage = ConstantText.invalidEmail;
      buttonEmailStatus(false);
    } else {
      emailAddressErrorMessage = "";
      buttonEmailStatus(true);
    }
    // buttonEnable();
    notifyListeners();
  }

  void emailVerfied(
    BuildContext context,
  ) async {
    buttonEmailStatus(false);
    buttonLoader(true);
    notifyListeners();
    Map params = {"email": emailAddress};
    var res = await AuthRepository().emailVerfication(params);
    log(res.body);
    if (res.statusCode == 200) {
      emailAddressErrorMessage = "";
      otpErrorMessage = "";
      isOTPButtonEnable = false;
      buttonEmailStatus(false);
      Navigation.navigateToScreen(context, RouteName.forgotPasswordOTP);
    } else if (res.statusCode == 404) {
      emailAddressErrorMessage = ConstantText.incorrectEmail;
      buttonEmailStatus(true);
    }
    buttonLoader(false);
    notifyListeners();
  }

  void clearOTPError(String s) {}

  buttonEmailStatus(bool status) {
    isEmailButtonEnable = status;
  }

  buttonOTPStatus(bool status) {
    isOTPButtonEnable = status;
  }

  buttonLoader(bool status) {
    isEmailLoading = status;
  }

  void navigateToNext(BuildContext context) {
    Navigation.navigateToScreen(context, RouteName.forgotPasswordOTP);
  }

  startTimer() {
    timer = Timer.periodic(oneSecond, (timer) {
      if (countTimer == 0) {
        timer.cancel();
        isTimerShow = false;
        notifyListeners();
      } else {
        countTimer--;
        notifyListeners();
      }
    });
  }

  continueOTPButtonStatus(bool status) {
    isOTPButtonEnable = status;
    notifyListeners();
  }

  continueOTPButtonTapped(String otpValue, BuildContext context) async {
    isOTPLoading = true;
    notifyListeners();
    Map params = {"email": emailAddress, "otp": otpValue};
    var res = await AuthRepository().otpVerfication(params);
    log(res.body);
    log(res.statusCode.toString());
    if (res.statusCode == 200) {
      isOTPButtonEnable = false;
      otpErrorMessage = "";
      newPassword = "";
      confirmPassword = "";
      confirmPasswordErrorMessage = "";
      newPasswordErrorMessage = "";
      isResetButtonEnable = false;
      Navigation.navigateToScreen(
          context, RouteName.forgotPasswordChangePassword);
    } else if (res.statusCode == 400) {
      otpErrorMessage = ConstantText.invalidOTP;
      isOTPButtonEnable = true;
    }
    isOTPLoading = false;

    notifyListeners();
  }

  void resendOTPTapped() async {
    otpErrorMessage = "";
    isTimerShow = true;
    countTimer = 30;
    notifyListeners();
    startTimer();
    Map params = {"email": emailAddress};
    var res = await AuthRepository().emailVerfication(params);
  }

  passwordTapped() {
    if (!validateStructure(newPassword) || newPassword.isEmpty) {
      newPasswordErrorMessage = "show toggle";
    } else {
      newPasswordErrorMessage = "";
    }
    notifyListeners();
  }

  confirmPasswordTapped() {
    passwordChanged(newPassword);
    if (newPassword.isEmpty) {
      newPasswordErrorMessage = "show toggle with field required";
    } else if (!validateStructure(newPassword)) {
      newPasswordErrorMessage = "show toggle with invalid";
    }
    notifyListeners();
  }

  passwordChanged(value) {
    newPassword = value;
    if (value.isEmpty) {
      newPasswordErrorMessage = "show toggle with field required";
    } else if (newPassword.isNotEmpty && confirmPassword.isNotEmpty) {
      if (newPassword.toString() == confirmPassword.toString()) {
        if (!validateStructure(newPassword.toString())) {
          newPasswordErrorMessage = "show toggle";
          confirmPasswordErrorMessage = "";
        } else {
          newPasswordErrorMessage = "";
          confirmPasswordErrorMessage = "";
        }
      } else {
        if (!validateStructure(newPassword.toString())) {
          newPasswordErrorMessage = "show toggle";
        } else {
          newPasswordErrorMessage = "";
        }
        confirmPasswordErrorMessage = ConstantText.passwordNotMatch;
      }
    } else if (!validateStructure(newPassword)) {
      newPasswordErrorMessage = "show toggle";
    } else {
      newPasswordErrorMessage = "";
      confirmPasswordErrorMessage = "";
    }
    resetButtonEnable();
    // buttonEnable();
    notifyListeners();
  }

  confirmPasswordChanged(value) {
    confirmPassword = value;
    if (value.isEmpty) {
      confirmPasswordErrorMessage = ConstantText.fieldRequired;
    } else if (newPassword != confirmPassword) {
      confirmPasswordErrorMessage = "Password doesn't match";
    } else {
      confirmPasswordErrorMessage = "";
    }
    resetButtonEnable();
    notifyListeners();
  }

  resetButtonEnable() {
    bool ppasswordvalidate = newPassword.isNotEmpty &&
        (newPassword.isNotEmpty == confirmPassword.isNotEmpty) &&
        validateStructure(newPassword);
    bool cpass = confirmPassword.isNotEmpty && (newPassword == confirmPassword);
    if (ppasswordvalidate && cpass) {
      isResetButtonEnable = true;
    } else {
      isResetButtonEnable = false;
    }
    notifyListeners();
  }

  resetPassword(BuildContext context) async {
    isResetLoading = true;
    isResetButtonEnable = false;
    notifyListeners();
    Map params = {"email": emailAddress, "password": newPassword};
    var response = await AuthRepository().passwordChanged(params);

    if (response.statusCode == 200) {
      isResetButtonEnable = false;
      context.read<LoginProvider>().isPasswordReset = true;
      context.read<LoginProvider>().resetPasswordTimer();
      notifyListeners();

      Navigation.removeAllScreenFromStack(context, const LoginScreen());
    } else {
      isResetButtonEnable = true;
    }
    isResetLoading = false;
    notifyListeners();
  }

  forgotPasswordEmailBack(BuildContext context) {
    isEmailButtonEnable = true;
    Navigator.pop(context);
    notifyListeners();
  }

  forgotPasswordOTPBack(BuildContext context) {
    isOTPButtonEnable = true;
    Navigator.pop(context);
    notifyListeners();
  }
}
