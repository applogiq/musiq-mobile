import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart ' as http;
import 'package:image_picker/image_picker.dart';
import 'package:musiq/src/features/profile/domain/api_models/profile_update_api_model..dart';
import 'package:musiq/src/features/profile/domain/repository/profile_repo.dart';
import 'package:musiq/src/routing/route_name.dart';
import 'package:musiq/src/utils/navigation.dart';

import '../../../common_widgets/model/profile_model.dart';
import '../../../constants/images.dart';
import '../../../constants/string.dart';

class ProfileProvider extends ChangeNotifier {
//! Start
  File? fileImage;

  String name = "";
  String nameErrorMessage = "";

  String userName = "";
  String userNameErrorMessage = "";

  bool isProfileSaveLoading = false;
  bool isProfileSave = true;

  bool isCropSaveLoading = false;
  bool isCropSave = true;

  bool myProfileLoading = true;

  Uint8List? memoryImage;
  ProfileAPIModel profileAPIModel =
      ProfileAPIModel(status: false, message: "No data", records: null);

  removeMyProfileState() {
    fileImage = null;
    memoryImage = null;
    profileAPIModel =
        ProfileAPIModel(status: false, message: "No data", records: null);
    userName = "";
    name = "";
  }

  getProfileDetails() async {
    myProfileLoading = true;
    notifyListeners();
    var id = await secureStorage.read(
      key: "id",
    );
    try {
      var res = await ProfileRepository().getProfile(id!);
      print(res.body);
      if (res.statusCode == 200) {
        var jsonData = jsonDecode(res.body);
        log(jsonData.toString());
        profileAPIModel = ProfileAPIModel.fromJson(jsonData);
      } else {
        profileAPIModel =
            ProfileAPIModel(status: false, message: "No data", records: null);
      }
    } catch (e) {
      profileAPIModel =
          ProfileAPIModel(status: false, message: "No data", records: null);
    }
    myProfileLoading = false;
    notifyListeners();
  }

  void profileNameChanged(String value) {
    name = value;
    if (value.isEmpty) {
      nameErrorMessage = ConstantText.fieldRequired;
    } else {
      nameErrorMessage = "";
    }
    notifyListeners();
  }

  void profileUserNameChanged(String value) {
    userName = value;
    if (value.isEmpty) {
      userNameErrorMessage = ConstantText.fieldRequired;
    } else if (value.contains(" ")) {
      userNameErrorMessage = ConstantText.invalidUserName;
    } else {
      userNameErrorMessage = "";
    }
    // buttonEnable();
    notifyListeners();
  }

  profileUpdate() async {
    isProfileSaveLoading = true;
    notifyListeners();
    Map params = {
      "image": fileImage != null ? uint8ListTob64(memoryImage!) : "",
      "username":
          userName.isEmpty ? profileAPIModel.records!.username : userName,
      "fullname": name.isEmpty ? profileAPIModel.records!.fullname : name,
    };
    log(params.toString());
    var id = await secureStorage.read(
      key: "id",
    );
    try {
      var res = await ProfileRepository().updateProfile(id!, params);
      print(res.body);
      // if (res.statusCode == 200) {
      //   print("IF");

      //   var jsonData = jsonDecode(res.body);
      //   log(jsonData.toString());
      //   // profileAPIModel = ProfileAPIModel.fromJson(jsonData);
      // } else {
      //   print("Else");

      //   // profileAPIModel =
      //   //     ProfileAPIModel(status: false, message: "No data", records: null);
      // }
    } catch (e) {
      print(e.toString());
      print("ERRR");
      // profileAPIModel =
      //     ProfileAPIModel(status: false, message: "No data", records: null);
    }

    isProfileSaveLoading = false;
    notifyListeners();
  }

  getImageFrom(
      {required ImageSource source, required BuildContext context}) async {
    ImagePicker picker = ImagePicker();

    final pickedImage =
        await picker.pickImage(source: source, imageQuality: 100);
    if (pickedImage == null) return;
    final imageTemp = File(pickedImage.path);
    fileImage = imageTemp;
    isCropSaveLoading = false;
    Navigation.navigateToScreen(context, RouteName.crop);

    // if (_pickedImage != null) {
    //   var image = File(_pickedImage.path.toString());
    //   final _sizeInKbBefore = image.lengthSync() / 1024;
    //   print('Before Compress $_sizeInKbBefore kb');
    //   var _compressedImage = await AppHelper.compress(image: image);
    //   final _sizeInKbAfter = _compressedImage.lengthSync() / 1024;
    //   print('After Compress $_sizeInKbAfter kb');
    //   var _croppedImage = await AppHelper.cropImage(_compressedImage);
    //   if (_croppedImage == null) {
    //     print("NU:L");
    //     return;
    //   }
    //   isImagePicked = true;

    //   imagePath = File(_croppedImage.path);
    //   // imagePath = _croppedImage.path;

    //   print("FILE");
    //   print(imagePath);
    //   update();

    // imagePath = File(_croppedImage.path);
    // imagePath = _croppedImage;
    // update();
    // setState(() {
    //   fileImage = _croppedImage;
    // });
    // }
  }

  // buttonEnable() {
  //   // bool emailvalidate = email.isNotEmpty && isEmailValid(email);
  //   // bool ppasswordvalidate = password.isNotEmpty &&
  //   //     (password.isNotEmpty == confirmPassword.isNotEmpty) &&
  //   //     validateStructure(password);
  //   // bool userVali = userName.isNotEmpty && userName.contains("");
  //   // bool cpass = confirmPassword.isNotEmpty && (password == confirmPassword);
  //   if (userName.isNotEmpty || name.isNotEmpty) {
  //     isProfileSave = false;
  //   } else {
  //     isProfileSave = true;
  //   }
  //   notifyListeners();
  // }
  String uint8ListTob64(Uint8List uint8list) {
    String base64String = base64Encode(uint8list);

    return base64String;
  }

  void saveImage(Uint8List image, BuildContext context) {
    isCropSaveLoading = true;
    notifyListeners();
    memoryImage = image;

    Navigator.pop(context);
    Navigator.pop(context);
    notifyListeners();
  }

  loaderDialog(context) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return Dialog(
            backgroundColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    Images.loaderImage,
                    height: 70,
                  ),
                ],
              ),
            ),
          );
        });
  }

//! END

  File? pickedImage;
  Uint8List? viewImage;
  String getImageValue = "";
  // String name = "";
  String nameError = "";
  // String userName = "";
  String userNameError = "";
  ProfileAPIModel? profileAPI;
  var profileName = "";
  var profileUserName = "";
  var profileImage = "";
  var registerid = "";
  String updatedImage = "";
  bool isLoading = false;
  FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  ProfileProvider() {
    getuserApi();
    notifyListeners();
  }
  void showAPIgetvalue() {
    getValue("id");
  }

  Future<void> _save(String key, String value) async {
    await secureStorage.write(key: key, value: value);
  }

  Future<String> getValue(String Key) async {
    return await secureStorage.read(key: Key) ?? "";
  }

  saveDetails() async {
    _save("id", name);
    _save("id", userName);
  }

  List<ProfileModel> profileContent = [
    ProfileModel(
        title: "My Profile", isArrow: true, navigateScreen: "myProfile"),
    ProfileModel(
        title: "Preferences", isArrow: true, navigateScreen: "preferences"),
    ProfileModel(
        title: "Contact us", isArrow: true, navigateScreen: "contact_us"),
  ];

  var isAboutOpen = false;

  void aboutToggle() {
    isAboutOpen = !isAboutOpen;
    notifyListeners();
  }

  nameChanged(value) {
    name = value;
    if (value.isEmpty) {
      nameError = "Field is required";
    } else {
      nameError = "";
    }
    notifyListeners();
  }

  userNameChanged(value) {
    userName = value;
    if (value.isEmpty) {
      userNameError = "Field is required";
    } else {
      userNameError = "";
    }
    notifyListeners();
  }

  Future pickImage(ImageSource source, BuildContext context) async {
    final Image = await ImagePicker().pickImage(
      source: source,
    );
    if (Image == null) return;
    var imagetemp = File(Image.path);
    // imagetemp = await imagetemp.copy();
    pickedImage = imagetemp;

    Uint8List baseImage = await imagetemp.readAsBytes();
    getImageValue = base64.encode(baseImage);
    //  viewImage = getImageValue;
    Navigator.pop(context);
    notifyListeners();
  }

  profileDeleteImage(BuildContext context) {
    pickedImage = null;
    notifyListeners();
    Navigator.pop(context);
  }

  clearError() {
    name = "";
    nameError = "";
    userName = "";
    userNameError = "";
    notifyListeners();
  }

  getuserApi() async {
    var accessToken = await secureStorage.read(
      key: "access_token",
    );
    var id = await secureStorage.read(
      key: "id",
    );
    var resid = await secureStorage.read(
      key: "register_id",
    );

    try {
      var response = await http.get(
          Uri.parse("https://api-musiq.applogiq.org/api/v1/users/$id"),
          headers: {
            'Content-type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $accessToken'
          });

      profileAPI =
          ProfileAPIModel.fromJson(jsonDecode(response.body.toString()));
      profileName = profileAPI!.records!.fullname.toString();
      profileUserName = profileAPI!.records!.username.toString();
      profileImage = profileAPI!.records!.isImage.toString();
      registerid = profileAPI!.records!.registerId.toString();
      updatedImage =
          "https://api-musiq.applogiq.org/api/v1/public/users/$registerid.png";
      // var d = jsonDecode(response.body.toString());
      // if()

    } catch (e) {
      print(e.toString());
    }
    notifyListeners();
  }

  updateProfile(BuildContext context) async {
    Map params = {
      "username": userName,
      "fullname": name,
      "image": getImageValue,
    };

    var id = await secureStorage.read(
      key: "id",
    );
    isLoading = true;
    notifyListeners();
    var response =
        await ProfileRepository().updateProfile(id.toString(), params);
    print(response.body.toString());
    isLoading = false;
    notifyListeners();
    if (response.statusCode == 200) {
      Navigator.pop(context);
    }
  }
  // updatedProfileImage() async {
  //   var resgisterId = await secureStorage.read(key: "register_id");
  //   updatedImage =
  //       "https://api-musiq.applogiq.org/api/v1/public/users/$registerid.png";
  //   notifyListeners();
  // }

  generateProfileImageUrl() async {
    var resgisterId = await secureStorage.read(
      key: "register_id",
    );
    String Url =
        "https://api-musiq.applogiq.org/public/users/${resgisterId.toString()}.png";
    return Url;
  }

// showImage(){
//   var data =
// }

}
