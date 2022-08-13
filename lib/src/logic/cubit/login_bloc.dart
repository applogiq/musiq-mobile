import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:musiq/src/helpers/utils/navigation.dart';
import 'package:musiq/src/view/pages/artist_preference/artist_preference.dart';
import 'package:musiq/src/view/pages/common_screen/account_screen.dart/select_your%20fav_artist.dart';
import 'package:rxdart/rxdart.dart';

import '../../constants/api.dart';
import '../../constants/string.dart';
import '../../helpers/utils/validation.dart';
import 'package:http/http.dart' as http;

import '../../model/api_model/artist_model.dart';
import '../../model/api_model/user_model.dart';
part 'login_state.dart';

class LoginBloc extends Cubit<LoginState> with InputValidationMixin {
  LoginBloc() : super(LoginInitialState());
  final userEmailController = BehaviorSubject<String>.seeded("");
  final passwordController = BehaviorSubject<String>.seeded("");
  final validator = BehaviorSubject<bool>.seeded(false);
  final isInvalidCred = BehaviorSubject<bool>.seeded(false);
  final isLoading = BehaviorSubject<bool>.seeded(false);
  final isSuccess = BehaviorSubject<bool>.seeded(false);
  final storage = FlutterSecureStorage();

  Stream<String> get userNameStream => userEmailController.stream;
  Stream<String> get passwordStream => passwordController.stream;
  Stream<bool> get errorStream => isInvalidCred.stream;
  Stream<bool> get loadingStream => isLoading.stream;

  void clearStreams() {
    isInvalidCred.sink.add(false);
    isLoading.sink.add(false);
    validator.sink.add(false);
    isSuccess.sink.add(false);
    updateUserName('');
    updatePassword('');
  }

  dispose() {
    userEmailController.close();
    passwordController.close();
  }

  void updateUserName(String userName) {
    isInvalidCred.sink.add(false);
    if (validator.value == true) {
      if (userName.isEmpty) {
        userEmailController.sink.addError("Field is required");
      } else if (!isEmailValid(userName)) {
        userEmailController.sink.addError("Invalid Email ID");
      } else {
        userEmailController.sink.add(userName);
      }
    } else {
      userEmailController.sink.add(userName);
    }
  }

  void updatePassword(String password) {
    isInvalidCred.sink.add(false);

    if (validator.value == true) {
      if (password.isEmpty) {
        passwordController.sink.addError("Field is required");
      } else {
        passwordController.sink.add(password);
      }
    } else {
      passwordController.sink.add(password);
    }
  }

  passwordTap() async {
    validator.sink.add(true);
    print(userEmailController.value.toString());
    var check1;
    try {
      check1 = await userNameStream.first;
      print(check1);
      updateUserName(check1);
      print("check");
    } catch (err) {
      print(err.toString());
      check1 = err.toString();
    }

    print(check1);
    if (check1 == "") {
      userEmailController.sink.addError("Field is required");
    } else if (check1 == "Invalid Email ID") {
      userEmailController.sink.addError(check1);
    }
  }

  checkEmptyValidation() async {
    var check1;
    var check2;
    try {
      check1 = await userNameStream.first;
    } catch (err) {
      check1 = err.toString();
    }
    try {
      check2 = await passwordStream.first;
    } catch (err) {
      check2 = err.toString();
    }
    if (check1 == "") updateUserName("");
    if (check2 == "") updatePassword("");

    var isValid = await validateForm.toString();
    print("isValid");
    print(isValid);
    if (check1 == "" || check2 == "") {
      return false;
    } else {
      return true;
    }
  }

  void updateValidator(bool val) {
    validator.sink.add(val);
  }

  void updateError() {
    isInvalidCred.sink.add(true);
  }

  Stream<bool> get validateForm => Rx.combineLatest2(
        userNameStream,
        passwordStream,
        (
          a,
          b,
        ) =>
            true,
      );

  loginAPI(BuildContext context) async {
    if (isSuccess == true) {
      isLoading.sink.add(false);
    } else {
      isLoading.sink.add(true);
      try {
        var email = "", password = "";
        Map<String, dynamic> params = {
          "email": userEmailController.stream.value,
          "password": passwordController.stream.value
        };

        print(params);

        var url = Uri.parse(
            APIConstants.BASE_URL.toString() + APIConstants.LOGIN.toString());
        print(url);

        var response = await http.post(url, body: jsonEncode(params), headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
        });
        print(response.statusCode);
        if (response.statusCode == 200) {
          isSuccess.sink.add(true);
          isInvalidCred.sink.add(true);
          var data = jsonDecode(response.body.toString());
          User user = User.fromMap(data);
          print(user.toMap());
          print(user.records.preference.artist.length == 0);
          await storage.deleteAll();

          var userData = user.records.toMap();
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
              value: jsonEncode(user.records.preference.artist));
          await storage.write(
              key: "password_cred", value: passwordController.stream.value);
          var list1 = await storage.read(key: "artist_list");
          print(list1);

          Future.delayed(Duration(milliseconds: 600), () {
            if (user.records.isPreference == false) {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => ArtistPreferenceMain(
                        artist_list: user.records.preference.artist,
                      )));
            } else {
              Navigation.navigateReplaceToScreen(context, "bottom/");
            }
            //   if(user.records.preference.artist.length==0){
            //     Navigation.navigateReplaceToScreen(context, 'selectArtistPref//');
            //  clearStreams();
            //   }else{
            //     Navigation.navigateReplaceToScreen(context, "home/");
            //   }
          });
        } else if (response.statusCode == 404) {
          print("ERRR");
          isInvalidCred.sink.addError(ConstantText.invalidEmailAndPassword);
          isSuccess.sink.add(false);
        } else {
          isSuccess.sink.add(false);
          isInvalidCred.sink.add(true);
        }
        isLoading.sink.add(false);
        return response.statusCode;
      } catch (e) {
        print(e.toString());
        isLoading.sink.add(false);
        return 1;
      }
    }
  }

  Future<ArtistModel> getArtist() async {
    await Future.delayed(Duration(seconds: 2), () {});
    var token = await storage.read(key: "access_token");
    var url = Uri.parse(
      APIConstants.BASE_URL + APIConstants.ARTIST_LIST,
    );
    var header = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      "Authorization": "Bearer $token"
    };
    print(url);
    var res = await http.get(url, headers: header);

    var data = jsonDecode(res.body);
    ArtistModel artistModel = ArtistModel.fromMap(data);
    // print(artistModel.records.toString());
    // print(artistModel.toMap());
    return artistModel;
  }
}
