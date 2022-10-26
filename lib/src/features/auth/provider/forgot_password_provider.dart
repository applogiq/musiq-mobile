import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:musiq/src/common_widgets/loader.dart';
import 'package:musiq/src/features/auth/domain/models/forgot_password.dart';
import 'package:musiq/src/features/auth/domain/models/otp_model.dart';
import 'package:musiq/src/features/auth/screens/login_screen.dart';
import '../../../constants/string.dart';
import '../../../utils/validation.dart';
import '../screens/forgot_screen/forgot_otp_screen.dart';
import '../screens/forgot_screen/new_password.dart';

import 'package:http/http.dart' as http;

class ForgotPasswordProvider extends ChangeNotifier with InputValidationMixin {
  String emailAddress = "";
  String otpStatus = "";
  String emailAddressErrorMessage = "";
  bool isButtonEnable = true;
  bool isLoad = false;
  String otpErrorMessage = "";
  String newPassword = "";
  String newPasswordError = "";
  String confirmPassword = "";
  String confirmPasswordError = "";
  bool   emailButtonLoad = false;
  bool   resentOTPLoad = false;
  bool otpButtonEnable = true;
  bool isResetButtonEnable = true;
  bool resentButtonEnable = true;
  ForgotPasswordModel? forgotPasswordModel;
  OTPvalidation _otp1 = OTPvalidation(
    "",
    "",
  );
  OTPvalidation _otp2 = OTPvalidation(
    "",
    "",
  );
  OTPvalidation _otp3 = OTPvalidation(
    "",
    "",
  );
  OTPvalidation _otp4 = OTPvalidation(
    "",
    "",
  );
  OTPvalidation _otp5 = OTPvalidation(
    "",
    "",
  );
  OTPvalidation _otp6 = OTPvalidation(
    "",
    "",
  );
  OTPvalidation get otp1 => _otp1;
  OTPvalidation get otp2 => _otp2;
  OTPvalidation get otp3 => _otp3;
  OTPvalidation get otp4 => _otp4;
  OTPvalidation get otp5 => _otp5;
  OTPvalidation get otp6 => _otp6;
  var saveEmail = "";
  void showGetvalue() async {
    apiGetvalue("email");
  }

  isClear() {
    _otp1 = OTPvalidation("", "");
    _otp2 = OTPvalidation("", "");
    _otp3 = OTPvalidation("", "");
    _otp4 = OTPvalidation("", "");
    _otp5 = OTPvalidation("", "");
    _otp6 = OTPvalidation("", "");

    notifyListeners();
  }

  FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  void showAPiGetValues() async {
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

  clearOTPError(value) {
    _otp1 = OTPvalidation(value, "");
    notifyListeners();
  }

  void otpValidation(String value) {
    if (otp1.value.isEmpty) {
      _otp1 = OTPvalidation(value, "");
//  otpButtonEnable = false;
    } else {
      _otp1 = OTPvalidation(value, "");
//  otpButtonEnable = true;

    }
    otpButtonenable();
    notifyListeners();
  }

  void otp2validation(String value) {
    if (otp2.value.isEmpty) {
      _otp2 = OTPvalidation(value, "");
    } else {
      _otp2 = OTPvalidation(value, "");

      //  otpButtonEnable = true;
    }
    otpButtonenable();

    notifyListeners();
  }

  otp3validation(String value) {
    if (otp3.value.isEmpty) {
      _otp3 = OTPvalidation(value, "");
    } else {
      _otp3 = OTPvalidation(value, "");
    }
    otpButtonenable();

    notifyListeners();
  }

  otp4validation(String value) {
    if (otp4.value.isEmpty) {
      _otp4 = OTPvalidation(value, "");
    } else {
      _otp4 = OTPvalidation(value, "");
    }
    otpButtonenable();

    notifyListeners();
  }

  otp5validation(String value) {
    if (otp5.value.isEmpty) {
      _otp5 = OTPvalidation(value, "");
    } else {
      _otp5 = OTPvalidation(value, "");
    }
    otpButtonenable();

    notifyListeners();
  }

  otp6validation(String value) {
    if (otp6.value.isEmpty) {
      _otp6 = OTPvalidation(value, "");
    } else {
      _otp6 = OTPvalidation(value, "");
    }
    otpButtonenable();
    notifyListeners();
  }

  clearOTPvalue() {
    _otp1 = OTPvalidation("", "");
    _otp2 = OTPvalidation("", "");
    _otp3 = OTPvalidation("", "");
    _otp4 = OTPvalidation("", "");
    _otp5 = OTPvalidation("", "");
    _otp6 = OTPvalidation("", "");

    notifyListeners();
  }
  otpvalueClearForValidation() {
    _otp1 = OTPvalidation("", "check your OTP");
    _otp2 = OTPvalidation("", "");
    _otp3 = OTPvalidation("", "");
    _otp4 = OTPvalidation("", "");
    _otp5 = OTPvalidation("", "");
    _otp6 = OTPvalidation("", "");

    notifyListeners();
  }

  otpButtonenable() {
    if (otp1.value.isNotEmpty &&
        otp2.value.isNotEmpty &&
        otp3.value.isNotEmpty &&
        otp4.value.isNotEmpty &&
        otp5.value.isNotEmpty &&
        otp6.value.isNotEmpty) {
      otpButtonEnable = false;
    } else {
      otpButtonEnable = true;
    }
    notifyListeners();
  }

  resendOTP(BuildContext context) async {
    try {
      print("1");
     
       resentOTPLoad = true;
       notifyListeners();
      print(emailButtonLoad);
      var response = await http.post(
          Uri.parse("https://api-musiq.applogiq.org/api/v1/users/email"),
          headers: {
            "Content-Type": "application/json",
          },
          body: jsonEncode({"email": emailAddress}));
      forgotPasswordModel =
          ForgotPasswordModel.fromJson(jsonDecode(response.body.toString()));
      saveEmail = forgotPasswordModel!.message.toString();
     
      if (response.statusCode == 200) {
        // LoaderScreen();
    

        isClear();

        showAPiGetValues();
        await saveDetails();
        isClearError();
        clearOTPvalue();
        otpButtonEnable = true;
        resentOTPLoad = false;
        notifyListeners();
      } else {
        print("error");
        otpButtonEnable = true;
      }
    } catch (e) {
      print("1");
      print("uhu${e.toString()}");
    }
    notifyListeners();
  }

  postotp(BuildContext context) async {
    emailButtonLoad = false;
    var storedEmail = await secureStorage.read(key: "email");
    var otp = otp1.value +
        otp2.value +
        otp3.value +
        otp4.value +
        otp5.value +
        otp6.value;
    try {
      print("1");

      var response = await http.post(
          Uri.parse(
              "https://api-musiq.applogiq.org/api/v1/users/email/otp-verify"),
          headers: {
            "Content-Type": "application/json",
          },
          body: jsonEncode({
            "email": storedEmail,
            "otp": otp1.value +
                otp2.value +
                otp3.value +
                otp4.value +
                otp5.value +
                otp6.value
          }));
          print(response.statusCode);
          var b = jsonDecode(response.body.toString());
          print(b);

      if (response.statusCode == 200) {
        print("hi");
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const NewPasswordScreen()));
        emailButtonLoad = true;
        otpButtonEnable = true;
        isclearError();
        clearOTPvalue();
      isResetButtonEnable = true;

        
      }
       else if( response.statusCode == 400){
        print("1");
       var b = jsonDecode(response.body.toString());
        print("2");
        if(b["detail"]["message"] == "check your OTP"){
        print(b);
        _otp1 = OTPvalidation("", "check your OTP");
        otpvalueClearForValidation();
        emailButtonLoad = true;
        otpButtonEnable = true;
        }else{
           _otp1 = OTPvalidation("", "");
           emailButtonLoad = true;
           otpButtonEnable = true;
        }
        // notifyListeners();
       }
      
      else {
        print("error");
        emailButtonLoad = true;
        otpButtonEnable = true;
        clearOTPvalue();
      }
    } catch (e) {
      print("1");
      print("uhu${e.toString()}");
    }
    notifyListeners();
  }

  buttonEnable() {
    if (emailAddress.isNotEmpty && isEmailValid(emailAddress)) {
      isButtonEnable = false;
      emailButtonLoad = true;
    } else {
      isButtonEnable = true;
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

  login(BuildContext context) async {
    emailButtonLoad = false;
    notifyListeners();
    try {
      print("1");

      var response = await http.post(
          Uri.parse("https://api-musiq.applogiq.org/api/v1/users/email"),
          headers: {
            "Content-Type": "application/json",
          },
          body: jsonEncode({"email": emailAddress}));
      forgotPasswordModel =
          ForgotPasswordModel.fromJson(jsonDecode(response.body.toString()));
      saveEmail = forgotPasswordModel!.message.toString();
     

     

      if (response.statusCode == 200) {
        Navigator.push(
            (context), MaterialPageRoute(builder: ((context) => OTPScreens())));
        showAPiGetValues();
        await saveDetails();
        isClearError();
        clearOTPvalue();
        otpButtonEnable = true;
     

      } else if(response.statusCode == 404){
        var b = jsonDecode(response.body.toString());
        if(b["detail"]["message"] == "check your email"){
          emailAddressErrorMessage = "check your email";
        }else{
          emailAddressErrorMessage = "";

        }
      }
      
      
      else {
        print("error");
      }
      emailButtonLoad = true;
    } catch (e) {
      print("1");
      print("uhu${e.toString()}");
    }
    notifyListeners();
  }

  isClearError() {
    emailAddressErrorMessage = "";
    isButtonEnable = true;
    notifyListeners();
  }

  isNotClearError() {
    isButtonEnable = false;
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
        return OTPScreens(
            // email: emailAddress,
            );
      }));
    }
  }

  continueTapped(String otpValue, BuildContext context) {
    print(otpValue);
    if (otpValue.length == 6) {
      print("DDD");
      otpErrorMessage = "";
      // Navigator.of(context).push(MaterialPageRoute(
      //     builder: (context) => NewPasswordScreen(email: emailAddress)));
    } else {
      otpErrorMessage = "Fields are mandatory";
    }
    notifyListeners();
  }

  passwordChanged(value) {
    newPassword = value;
    if (value.isEmpty) {
      newPasswordError = "show toggle with field required";
    } else if (newPassword.isNotEmpty && confirmPassword.isNotEmpty) {
      if (newPassword.toString() == confirmPassword.toString()) {
        if (!validateStructure(newPassword.toString())) {
          newPasswordError = "show toggle";
          confirmPasswordError = "";
        } else {
          newPasswordError = "";
          confirmPasswordError = "";
        }
      } else {
        if (!validateStructure(newPassword.toString())) {
          newPasswordError = "show toggle";
        } else {
          newPasswordError = "";
        }
        confirmPasswordError = ConstantText.passwordNotMatch;
      }
    } else if (!validateStructure(newPassword)) {
      newPasswordError = "show toggle";
    } else {
      newPasswordError = "";
      confirmPasswordError = "";
    }
    resetButtonEnable();
    // buttonEnable();
    notifyListeners();
  }

  confirmPasswordChanged(value) {
    confirmPassword = value;
    if (value.isEmpty) {
      confirmPasswordError = ConstantText.fieldRequired;
      print("1");
    } else if (newPassword != confirmPassword) {
      confirmPasswordError = "Password doesn't match";
    } else {
      confirmPasswordError = "";
    }
    resetButtonEnable();
    notifyListeners();
  }

  resetButtonEnable() {
    bool ppasswordvalidate = newPassword.isNotEmpty && 
        (newPassword.isNotEmpty == confirmPassword.isNotEmpty) && validateStructure(newPassword);
    bool cpass = confirmPassword.isNotEmpty && (newPassword == confirmPassword);
    if (ppasswordvalidate && cpass) {
      isResetButtonEnable = false;
    } else {
      isResetButtonEnable = true;
    }
    notifyListeners();
  }

  passwordTapped() {
    if (!validateStructure(newPassword) || newPassword.isEmpty) {
      newPasswordError = "show toggle";
    } else {
      newPasswordError = "";
    }
    notifyListeners();
  }

  confirmPasswordTapped() {
    passwordChanged(newPassword);
    if (newPassword.isEmpty) {
      newPasswordError = "show toggle with field required";
    } else if (!validateStructure(newPassword)) {
      newPasswordError = "show toggle with invalid";
    }
  }

  updatePassword(BuildContext context) async {
    emailButtonLoad = false;
    notifyListeners();
    var storedEmail = await secureStorage.read(key: "email");
    var response = await http.put(
      Uri.parse(
          "https://api-musiq.applogiq.org/api/v1/users/email/forget-password"),
      headers: {
        "accept": "application/json",
        'Content-Type': 'application/json'
      },
      body: jsonEncode({"email": storedEmail, "password": newPassword}),
    );
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));
      emailButtonLoad = true;
      isclearError();
      isClearError();
      isResetButtonEnable = true;
    } else {
      print("error");
      emailButtonLoad = true;
    }
    notifyListeners();
  }

  isclearError() {
    newPassword = "";
    confirmPassword = "";
    newPasswordError = "";
    confirmPasswordError = "";
    notifyListeners();
  }
}
