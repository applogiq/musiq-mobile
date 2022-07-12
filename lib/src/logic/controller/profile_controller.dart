import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:musiq/src/helpers/constants/string.dart';

import '../../model/profile_model.dart';
import '../services/api_route.dart';

class ProfileController extends GetxController {
  APIRoute apiRoute = APIRoute();

  var storage = FlutterSecureStorage();
  var isLoaded = false.obs;
  var isImage = false.obs;
  var initialUserName = "".obs;
  var initialName = "".obs;
  var nameValue = "".obs;
  var userNameValue = "".obs;
  var userNameError = "".obs;
  var nameError = "".obs;
  var isUserNameError = false.obs;
  var isNameError = false.obs;
  var registerId = "".obs;

  loadProfile() async {
    var isImageAvailable = await storage.read(key: "is_image");
    print(isImageAvailable);
    if (isImageAvailable != null && isImageAvailable == "true") {
      isImage.value = true;
      var id = await storage.read(key: "register_id");
      registerId.value = id!;
    } else {
      isImage.value = false;

      print("IMAGE NOT AVAILABLE");
    }
  }

  loadData() async {
    var name = await storage.read(key: "fullname");
    var userName = await storage.read(key: "username");
    nameValue.value = name!;
    userNameValue.value = userName!;
    initialUserName.value = userName;
    initialName.value = name;
  }

  List<ProfileModel> profileContent = [
    ProfileModel(
        title: "My Profile", isArrow: true, navigateScreen: "myProfile"),
    ProfileModel(
        title: "Preferences", isArrow: true, navigateScreen: "preferences"),
    ProfileModel(
        title: "Contact us", isArrow: true, navigateScreen: "myProfile"),
  ];

  var isImagePicked = false;

  var imagePath;

  var isAboutOpen = false.obs;
  String base64StringImage = "";

  convertToBase64Image() async {
    Uint8List imagebytes = await imagePath.readAsBytes();
    String base64string = base64.encode(imagebytes);

    base64StringImage = base64string;
  }

  openGallery() async {
    ImagePicker picker = ImagePicker();
    XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      isImagePicked = true;
      imagePath = File(image.path);
      update();

      return true;
    }
    update();
    return false;
  }

  openCamera() async {
    ImagePicker picker = ImagePicker();
    XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      isImagePicked = true;
      imagePath = File(image.path);
      update();

      return true;
    }
    update();
    return false;
  }

  deleteImage() async {
    isImagePicked = false;
    update();
  }

  void checkName(String value) {
    if (value.isEmpty) {
      isNameError.value = true;
      nameError.value = ConstantText.fieldRequired;
    } else {
      isNameError.value = false;
      nameError.value = "";
    }
    nameValue.value = value;
    // update();
  }

  void checkUserName(String value) {
    if (value.isEmpty) {
      isUserNameError.value = true;
      userNameError.value = ConstantText.fieldRequired;
    } else if (value.contains(" ")) {
      isUserNameError.value = true;
      userNameError.value = ConstantText.invalidUserName;
    } else {
      isUserNameError.value = false;
      userNameError.value = "";
    }
    userNameValue.value = value;
  }

  void saveUpdate() async {
    isLoaded.value = true;
    if (isNameError.value && isUserNameError.value) {
      print("Fix Error");
    } else {
      if (isImagePicked) {
        convertToBase64Image();
      } else {
        base64StringImage = "";
      }
      if (userNameValue.value == initialUserName.value) {
        print("USERNAME MAKE EMPTY");
        userNameValue.value = "";
      }
      if (nameValue.value == initialName.value) {
        print("NAME MAKE EMPTY");
        nameValue.value = "";
      }

      if (userNameValue.value == "" &&
          nameValue.value == "" &&
          base64StringImage == "") {
        print("NO CHANGES");
      } else {
        Map params = {
          "username": userNameValue.toString(),
          "fullname": nameValue.toString(),
          "image": base64StringImage
        };
        print(params);
        await apiRoute.profileUpdate(params);
      }
    }
    isLoaded.value = false;
  }
}
