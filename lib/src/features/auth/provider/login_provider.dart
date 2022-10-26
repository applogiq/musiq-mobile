import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:musiq/src/constants/string.dart';
import 'package:musiq/src/features/common/screen/main_screen.dart';

import '../../../routing/route_name.dart';
import '../../../utils/navigation.dart';
import '../../../utils/validation.dart';
import '../domain/models/user_model.dart';
import '../domain/repository/auth_repo.dart';

class LoginProvider extends ChangeNotifier with InputValidationMixin {
  String emailAddress = "";
  String emailAddressErrorMessage = "";
  String password = "";
  String passwordErrorMessage = "";
  final storage = FlutterSecureStorage();

  bool isLoginButtonEnable = false;
  bool isShowStatus = false;
  bool isErrorStatus = false;
  bool isLoading = false;
  bool isSuccess = false;
  changeErrorStatus() {
    isShowStatus = false;
    isErrorStatus = false;
  }
  isErr(){
     emailAddressErrorMessage = "";
      passwordErrorMessage = "";
    
    notifyListeners();
  }

  emailAddressChanged(value) {
    emailAddress = value;
    if (value.isEmpty) {
      emailAddressErrorMessage = "Field is required";
    } else if (!isEmailValid(value)) {
      emailAddressErrorMessage = ConstantText.invalidEmail;
    } else {
      emailAddressErrorMessage = "";
    }

    validate();
    notifyListeners();
  }

  passwordChanged(value) {
    RegExp regex =
        RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
    password = value;
    if (value.isEmpty) {
      passwordErrorMessage = "Field is required";
    } else if(!regex.hasMatch(value)){
      passwordErrorMessage = "Enter valid password";
     
    }
    
    else {
      passwordErrorMessage = "";
    }
    validate();
    notifyListeners();
  }
  

  validate() {
    changeErrorStatus();
    bool emailValidate = emailAddress.isNotEmpty && isEmailValid(emailAddress);
    if (emailValidate && password.isNotEmpty) {
      isLoginButtonEnable = true;
    } else {
      isLoginButtonEnable = false;
    }

    notifyListeners();
  }

  login(context) async {
    Map params = {"email": emailAddress, "password": password};
    isLoading = true;
    notifyListeners();
    var response = await AuthRepository().login(params);
    isLoading = false;
    notifyListeners();
    print(response.statusCode);
    if (response.statusCode == 200) {
      isShowStatus = true;
      isErrorStatus = false;
      
      print(response.body);
      var data = jsonDecode(response.body.toString());
      UserModel user = UserModel.fromMap(data);
      await storeResponseData(user);
      
      navigateToNextPage(user, context);

    await Future.delayed(Duration(seconds: 2));
      isLoginButtonEnable=false;
      isShowStatus=false;
       emailAddress="";
      password=""; 
          emailAddressErrorMessage = "";
      passwordErrorMessage = "";
    } else if (response.statusCode == 404) {
      isShowStatus = true;
      isErrorStatus = true;
      isSuccess = false;
    }
    notifyListeners();
  }

  passwordTap() {
    // emailAddressChanged(emailAddress);
    if(emailAddress.isEmpty){
    emailAddressErrorMessage = "Field is required";

    }
   else if (!isEmailValid(emailAddress)) {
      emailAddressErrorMessage = ConstantText.invalidEmail;
    }
    else{
    emailAddressErrorMessage = "";

    }
    notifyListeners();
    
  }

  void closeDialog() {
    isShowStatus = false;
    notifyListeners();
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
        //  await storage.write(
        // key: "access_token",
        // value: jsonEncode(userModel.records.accessToken.toString()));
        //   await storage.write(
        // key: "id",
        // value: jsonEncode(userModel.records.id.toString()));
    await storage.write(key: "password_cred", value: password);
    await storage.write(key: "isLogged", value: "true");
    var list1 = await storage.read(key: "artist_list");
  }

  navigateToNextPage(UserModel userModel, context) {
    Future.delayed(Duration(milliseconds: 600), () {
      if (userModel.records.isPreference == false) {
        // Navigator.of(context).pushReplacement(MaterialPageRoute(
        //     builder: (context) => ArtistPreferenceMain(
        //           artist_list: userModel.records.preference.artist,
        //         )));
      } else {
        // Navigation.navigateReplaceToScreen(context, RouteName.mainScreen);
      
       Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>MainScreen()), (route) => false);
      }
    });
  }
}
