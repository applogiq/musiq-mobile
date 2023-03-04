// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart ' as http;
import 'package:image_picker/image_picker.dart';
import 'package:musiq/src/core/constants/local_storage_constants.dart';
import 'package:musiq/src/core/utils/image_utils.dart';
import 'package:musiq/src/features/profile/screens/image_crop_screen.dart';

import '../../../../objectbox.g.dart';
import '../../../common_widgets/model/profile_model.dart';
import '../../../core/constants/string.dart';
import '../../../core/utils/toast_message.dart';
import '../domain/api_models/profile_update_api_model.dart';
import '../domain/repository/profile_repo.dart';

class ProfileProvider extends ChangeNotifier {
  ProfileProvider() {
    getuserApi();
    notifyListeners();
  }

  String base64Value = "";

  File? fileImage;

  String getImageValue = "";
  var isAboutOpen = false;
  bool isCropSave = true;
  bool isCropSaveLoading = false;
  bool isLoading = false;
  bool isProfileSave = true;
  bool isProfileSaveLoading = false;
  Uint8List? memoryImage;
  bool myProfileLoading = true;
  String? imageUrl;
  String name = "";

  String nameError = "";

  String nameErrorMessage = "";
  File? compressedFile;

  File? pickedImage;

  ProfileAPIModel? profileAPI;
  ProfileAPIModel profileAPIModel =
      ProfileAPIModel(status: false, message: "No data", records: null);

  List<ProfileModel> profileContent = [
    ProfileModel(
        title: "My Profile", isArrow: true, navigateScreen: "myProfile"),
    ProfileModel(
        title: "Preferences", isArrow: true, navigateScreen: "preferences"),
    ProfileModel(
        title: "Subscription", isArrow: true, navigateScreen: "subscription"),
  ];

  var profileImage = "";
  var profileName = "";
  var profileUserName = "";
  var registerid = "";
  FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  late Store store;
  String updatedImage = "";
  String userName = "";
  // String userName = "";
  String userNameError = "";

  String userNameErrorMessage = "";
  Uint8List? viewImage;

// Remove the my profile screen state
  removeMyProfileState() {
    fileImage = null;
    memoryImage = null;
    profileAPIModel =
        ProfileAPIModel(status: false, message: "No data", records: null);
    userName = "";
    name = "";
    userNameErrorMessage = "";
    nameErrorMessage = "";
  }

// Get profile screen details
  getProfileDetails() async {
    myProfileLoading = true;
    notifyListeners();

    try {
      var res = await ProfileRepository().getProfile();
      debugPrint(res.body);
      if (res.statusCode == 200) {
        var jsonData = jsonDecode(res.body);

        profileAPIModel = ProfileAPIModel.fromJson(jsonData);
        if (profileAPIModel.records!.isImage == true) {
          imageUrl =
              await secureStorage.read(key: LocalStorageConstant.profileUrl);
          notifyListeners();
        } else {
          imageUrl = null;
        }
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

// Name text field value change trigger profileNameChanged function
  void profileNameChanged(String value) {
    name = value;
    if (value.isEmpty) {
      isProfileSave = false;
      nameErrorMessage = ConstantText.fieldRequired;
    } else {
      isProfileSave = true;
      nameErrorMessage = "";
    }
    notifyListeners();
  }
// User Name text field value change trigger profileUserNameChanged function

  void profileUserNameChanged(String value) {
    userName = value;
    if (value.isEmpty) {
      userNameErrorMessage = ConstantText.fieldRequired;
      isProfileSave = false;
    } else if (value.contains(" ")) {
      userNameErrorMessage = ConstantText.invalidUserName;
      isProfileSave = false;
    } else {
      isProfileSave = true;
      userNameErrorMessage = "";
    }

    notifyListeners();
  }

// Profile update API integration
  profileUpdate(BuildContext context) async {
    isProfileSaveLoading = true;
    notifyListeners();
    Map params = {
      "image": fileImage != null ? uint8ListTob64(memoryImage!) : "",
      "username": userName == profileAPIModel.records!.username ? "" : userName,
      "fullname": name.isEmpty ? profileAPIModel.records!.fullname : name,
    };

    var id = await secureStorage.read(
      key: "id",
    );

    var res = await ProfileRepository().updateProfile(id!, params);

    if (res.statusCode == 200) {
      userNameErrorMessage = "";
      ProfileAPIModel profileAPIModel =
          ProfileAPIModel.fromJson(jsonDecode(res.body.toString()));
      if (profileAPIModel.records!.isImage == true) {
        await loadImage(profileAPIModel.records!.registerId.toString());
        imageUrl =
            await secureStorage.read(key: LocalStorageConstant.profileUrl);
        notifyListeners();
      } else {
        imageUrl = null;
        notifyListeners();
      }

      successToastMessage(
        "Profile update successfully",
      );
      Navigator.pop(context);
    } else if (res.statusCode == 400) {
      var jsonData = json.decode(res.body);
      if (jsonData["detail"] == "Username already exist") {
        userNameErrorMessage = "Username already exist";
      }
    } else {}

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
    notifyListeners();
    var result = await FlutterImageCompress.compressWithFile(
      fileImage!.absolute.path,
      quality: 20,
      rotate: 0,
    );
    compressedFile = await fileImage!.writeAsBytes(result!);

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const ImageCrop()));
  }

  String uint8ListTob64(Uint8List uint8list) {
    String base64String = base64Encode(uint8list);

    return base64String;
  }

// Cropped Image store
  void saveImage(Uint8List image, BuildContext context) {
    memoryImage = image;
    if (memoryImage != null) {
      base64Value = uint8ListTob64(memoryImage!);

      // compress();
    }
    Navigator.pop(context);
    Navigator.pop(context);
    notifyListeners();
  }

// Delete image function
  Future deleteImage(BuildContext context, BuildContext mainContext) async {
    Navigator.of(context).pop();
    fileImage = null;
    memoryImage = null;

    if (profileAPIModel.records != null) {
      if (profileAPIModel.records!.isImage == true) {
        var id = await secureStorage.read(
          key: "id",
        );
        var res = await ProfileRepository().deleteUserImage(id!);
        if (res.statusCode == 200) {
          await getProfileDetails();
        }
        return res;
      }
    } else {
      return http.Response("", 200);
    }

    notifyListeners();
  }

  void showAPIgetvalue() {
    getValue("id");
  }

  Future<String> getValue(String key) async {
    return await secureStorage.read(key: key) ?? "";
  }

  saveDetails() async {
    _save("id", name);
    _save("id", userName);
  }

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
    final image = await ImagePicker().pickImage(
      source: source,
    );
    if (image == null) return;
    var imagetemp = File(image.path);
    // imagetemp = await imagetemp.copy();
    pickedImage = imagetemp;

    Uint8List baseImage = await imagetemp.readAsBytes();
    getImageValue = base64.encode(baseImage);
    //  viewImage = getImageValue;
    Navigator.pop(context);
    notifyListeners();
  }

  profileDeleteImage(BuildContext context) {}

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
    await secureStorage.read(
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
      debugPrint(e.toString());
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
    debugPrint(response.body.toString());
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
    String url =
        "https://api-musiq.applogiq.org/public/users/${resgisterId.toString()}.png";
    return url;
  }

// showImage(){
//   var data =
// }

  Future<void> _save(String key, String value) async {
    await secureStorage.write(key: key, value: value);
  }
}
