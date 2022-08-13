import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
// import 'package:image_crop/image_crop.dart';
import 'package:image_picker/image_picker.dart';
import 'package:musiq/src/logic/controller/basic_controller.dart';

import '../../constants/string.dart';
import '../../helpers/utils/app_helper.dart';
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
  late File _file;
  late File _sample;
  late File _lastCropped;
  late Uint8List imagebytes;

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
    // base64StringImage = "";
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
      imagebytes = await imagePath.readAsBytes();

      update();

      return true;
    }
    update();
    return false;
  }

  // Future<void> cropImage(cropKey) async {
  //   final scale = cropKey.currentState.scale;
  //   final area = cropKey.currentState.area;
  //   if (area == null) {
  //     // cannot crop, widget is not setup
  //     return;
  //   }

  //   // scale up to use maximum possible number of pixels
  //   // this will sample image in higher resolution to make cropped image larger
  //   final sample = await ImageCrop.sampleImage(
  //     file: _file,
  //     preferredSize: (2000 / scale).round(),
  //   );

  //   final file = await ImageCrop.cropImage(
  //     file: sample,
  //     area: area,
  //   );

  //   sample.delete();

  //   _lastCropped?.delete();
  //   _lastCropped = file;

  //   print('$file');
  // }

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

  deleteImage(context) async {
    isImagePicked = false;
    var res = await apiRoute.deleteProfileImage();
    if (res.statusCode == 200) {
      BasicController basicController = BasicController();
      basicController.checkLogged(context);
    }
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

  getImageFrom({required ImageSource source}) async {
    ImagePicker picker = ImagePicker();

    final _pickedImage = await picker.pickImage(
        source: source, maxHeight: 600, maxWidth: 800, imageQuality: 100);

    if (_pickedImage != null) {
      var image = File(_pickedImage.path.toString());
      final _sizeInKbBefore = image.lengthSync() / 1024;
      print('Before Compress $_sizeInKbBefore kb');
      var _compressedImage = await AppHelper.compress(image: image);
      final _sizeInKbAfter = _compressedImage.lengthSync() / 1024;
      print('After Compress $_sizeInKbAfter kb');
      var _croppedImage = await AppHelper.cropImage(_compressedImage);
      if (_croppedImage == null) {
        print("NU:L");
        return;
      }
      isImagePicked = true;

      imagePath = File(_croppedImage.path);
      // imagePath = _croppedImage.path;

      print("FILE");
      print(imagePath);
      update();

      // imagePath = File(_croppedImage.path);
      // imagePath = _croppedImage;
      // update();
      // setState(() {
      //   fileImage = _croppedImage;
      // });
    }
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

  void saveUpdate(context) async {
    isLoaded.value = true;
    if (isNameError.value && isUserNameError.value) {
      print("Fix Error");
    } else {
      if (isImagePicked) {
        print("IMAGE");
        convertToBase64Image();
      } else {
        print("IMAGE EMPTY");

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
        var res = await apiRoute.profileUpdate(params);
        if (res.statusCode == 200) {
          BasicController basicController = BasicController();
          basicController.checkLogged(context);
        } else {
          print("No Updates");
        }
      }
    }
    isLoaded.value = false;
  }
}
