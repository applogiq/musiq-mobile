// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:musiq/src/constants/string.dart';
import 'package:musiq/src/features/common/screen/main_screen.dart';
import 'package:provider/provider.dart';

import '../../../../objectbox.g.dart';
import '../../../utils/validation.dart';
import '../../common/provider/bottom_navigation_bar_provider.dart';
import '../domain/models/user_model.dart';
import '../domain/repository/auth_repo.dart';

class LoginProvider extends ChangeNotifier with InputValidationMixin {
  String emailAddress = "";
  String emailAddressErrorMessage = "";
  bool isErrorStatus = false;
  bool isLoading = false;
  bool isLoginButtonEnable = false;
  bool isPasswordReset = false;
  bool isShowStatus = false;
  bool isSuccess = false;
  String password = "";
  String passwordErrorMessage = "";
  final storage = const FlutterSecureStorage();
  late Store store;

  changeErrorStatus() {
    isShowStatus = false;
    isErrorStatus = false;
  }

  isErr() {
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
    } else if (!regex.hasMatch(value)) {
      passwordErrorMessage = "Enter valid password";
    } else {
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

  login(BuildContext context) async {
    Map params = {"email": emailAddress, "password": password};
    isLoading = true;
    notifyListeners();
    var response = await AuthRepository().login(params);
    isLoading = false;
    notifyListeners();
    if (response.statusCode == 200) {
      context.read<BottomNavigationBarProvider>().selectedBottomIndex = 0;
      isShowStatus = true;
      isErrorStatus = false;

      var data = jsonDecode(response.body.toString());
      UserModel user = UserModel.fromMap(data);
      if (user.records.isImage == true) {
        //    if (fileImage != null && fileImage != "") {
        // await getApplicationDocumentsDirectory().then((Directory dir) {
        //   store = Store(getObjectBoxModel(), directory: '${dir.path}/musiq');
        //   final ProfileImage profileImage = ProfileImage(
        //       isImage: true,
        //       registerId: id,
        //       profileImageString: uint8ListTob64(memoryImage!));
        //   // final SongListModel queueSongModel = SongListModel(
        //   //     songId: playerSongListModel.id,
        //   //     albumName: playerSongListModel.albumName,
        //   //     title: playerSongListModel.title,
        //   //     musicDirectorName: playerSongListModel.musicDirectorName,
        //   //     imageUrl: playerSongListModel.imageUrl,
        //   //     songUrl:
        //   //         "https://api-musiq.applogiq.org/api/v1/audio?song_id=${playerSongListModel.id.toString()}");
        //   final box = store.box<ProfileImage>();

        //   var res = box.getAll();
        //   print("res.length");
        //   print(res.length);
        //   if (res.isEmpty) {
        //     box.put(profileImage);
        //     var res = box.getAll();
        //     for (var element in res) {
        //       log(element.profileImageString);
        //       log(element.registerId);
        //       log(element.id.toString());
        //     }
        //   } else {
        //     final myObject = box.getAll();
        //     for (var element in res) {
        //       if (element.registerId == id) {
        //         element.profileImageString = uint8ListTob64(memoryImage!);
        //         box.put(element);
        //       }
        //     }
        //   }
        //   // queueIdList.clear();
        //   // for (var e in res) {
        //   //   queueIdList.add(e.songId);
        //   // }
        //   // if (queueIdList.contains(playerSongListModel.id)) {
        //   //   normalToastMessage("Song already in queue ");
        //   // } else {
        //   //   box.put(queueSongModel);
        //   //   normalToastMessage("Song added to queue ");
        //   // }

        //   store.close();
        // });

      }
      await storeResponseData(user);

      await Future.delayed(const Duration(seconds: 2));
      isLoginButtonEnable = false;
      isShowStatus = false;
      emailAddress = "";
      password = "";
      emailAddressErrorMessage = "";
      passwordErrorMessage = "";
      navigateToNextPage(user, context);
    } else if (response.statusCode == 404) {
      isShowStatus = true;
      isErrorStatus = true;
      isSuccess = false;
    }
    notifyListeners();
  }

  passwordTap() {
    // emailAddressChanged(emailAddress);
    if (emailAddress.isEmpty) {
      emailAddressErrorMessage = "Field is required";
    } else if (!isEmailValid(emailAddress)) {
      emailAddressErrorMessage = ConstantText.invalidEmail;
    } else {
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
  }

  navigateToNextPage(UserModel userModel, context) {
    Future.delayed(const Duration(milliseconds: 600), () {
      if (userModel.records.isPreference == false) {
        // Navigator.of(context).pushReplacement(MaterialPageRoute(
        //     builder: (context) => ArtistPreferenceMain(
        //           artist_list: userModel.records.preference.artist,
        //         )));
      } else {
        // Navigation.navigateReplaceToScreen(context, RouteName.mainScreen);

        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const MainScreen()),
            (route) => false);
      }
    });
  }

  resetPasswordTimer() async {
    await Future.delayed(const Duration(seconds: 2), () {
      isPasswordReset = false;
    });
    notifyListeners();
  }

  closeResetPasswordTimer() async {
    isPasswordReset = false;
    notifyListeners();
  }
}
