import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:musiq/src/constants/string.dart';

import '../../../routing/route_name.dart';
import '../../../utils/navigation.dart';
import '../../../utils/validation.dart';
import '../../artist/screens/artist_preference_screen/artist_preference_screen.dart';
import '../domain/models/user_model.dart';
import '../domain/repository/auth_repo.dart';

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
  bool isButtonLoading = false;

  final storage = FlutterSecureStorage();
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

  createAccount(context) async {
    userNameChanged(userName);
    emailChanged(email);
    fullNameChanged(fullName);
    if (password.isEmpty) {
      passwordError = ConstantText.fieldRequired;
    }
    if (confirmPassword.isEmpty) {
      confirmPasswordError = ConstantText.fieldRequired;
    }

    if (fullNameError == "" &&
        emailError == "" &&
        userNameError == "" &&
        passwordError == "" &&
        confirmPasswordError == "") {
      Map params = {
        "username": userName,
        "fullname": fullName,
        "email": email,
        "password": password
      };
      isButtonLoading = true;
      notifyListeners();
      var response = await AuthRepository().register(params);
      print(response.statusCode);
      print(response.body);

      isButtonLoading = false;
      notifyListeners();
      if (response.statusCode == 201) {
        var data = jsonDecode(response.body.toString());
        UserModel user = UserModel.fromMap(data);
        await storeResponseData(user);
        navigateToNextPage(user, context);
      } else if (response.statusCode == 400) {
        var data = jsonDecode(response.body.toString());
        clearError();
        if (data['detail']["message"] == "email already exists") {
          emailError = "Email already exists";
        } else if (data['detail']["message"] == "username already exists") {
          userNameError = "Username already exists";
        }
        notifyListeners();
      }
    } else {
      print("InValid");
    }
  }

  clearError() {
    fullNameError = "";
    userNameError = "";
    emailError = "";
    passwordError = "";
    confirmPasswordError = "";
  }

  storeResponseData(UserModel userModel) async {
    await storage.deleteAll();

    var userData = userModel.records.toMap();
    for (final name in userData.keys) {
      final value = userData[name];
      debugPrint('$name,$value');
      await storage.write(
        key: name,
        value: value.toString(),
      );
    }
    await storage.write(
        key: "artist_list",
        value: jsonEncode(userModel.records.preference.artist));
    await storage.write(key: "password_cred", value: password);
    await storage.write(key: "isLogged", value: "true");
    var list1 = await storage.read(key: "artist_list");
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

  navigateToNextPage(UserModel userModel, context) {
    Future.delayed(Duration(milliseconds: 600), () {
      if (userModel.records.isPreference == false) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => ArtistPreferenceScreen()));
      } else {
        Navigation.navigateReplaceToScreen(context, RouteName.mainScreen);
      }
    });
  }
}
