import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart ' as http;
import 'package:image_picker/image_picker.dart';
import 'package:musiq/src/constants/color.dart';
import 'package:musiq/src/features/common/screen/main_screen.dart';
import 'package:musiq/src/features/profile/domain/repository/profile_repo.dart';
import 'package:musiq/src/routing/route_name.dart';
import 'package:musiq/src/utils/navigation.dart';
import 'package:musiq/src/utils/toast_message.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../objectbox.g.dart';
import '../../../common_widgets/model/profile_model.dart';
import '../../../constants/images.dart';
import '../../../constants/string.dart';
import '../../../local/model/user_model.dart';
import '../domain/api_models/profile_update_api_model..dart';

class ProfileProvider extends ChangeNotifier {
//! Start
  File? fileImage;
  late Store store;

  String name = "";
  String nameErrorMessage = "";

  String userName = "";
  String userNameErrorMessage = "";

  bool isProfileSaveLoading = false;
  bool isProfileSave = true;

  bool isCropSaveLoading = false;
  bool isCropSave = true;

  bool myProfileLoading = true;
  String base64Value = "";

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
    userNameErrorMessage = "";
    nameErrorMessage = "";
  }

  getProfileDetails() async {
    myProfileLoading = true;
    notifyListeners();
    var id = await secureStorage.read(
      key: "id",
    );
    try {
      var res = await ProfileRepository().getProfile(id!);
      debugPrint(res.body);
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
    // try {
    var res = await ProfileRepository().updateProfile(id!, params);
    debugPrint(res.body);
    debugPrint(res.statusCode.toString());
    if (res.statusCode == 200) {
      if (fileImage != null && fileImage != "") {
        await getApplicationDocumentsDirectory().then((Directory dir) {
          store = Store(getObjectBoxModel(), directory: '${dir.path}/musiq');
          final ProfileImage profileImage = ProfileImage(
              isImage: true,
              registerId: id,
              profileImageString: uint8ListTob64(memoryImage!));
          // final SongListModel queueSongModel = SongListModel(
          //     songId: playerSongListModel.id,
          //     albumName: playerSongListModel.albumName,
          //     title: playerSongListModel.title,
          //     musicDirectorName: playerSongListModel.musicDirectorName,
          //     imageUrl: playerSongListModel.imageUrl,
          //     songUrl:
          //         "https://api-musiq.applogiq.org/api/v1/audio?song_id=${playerSongListModel.id.toString()}");
          final box = store.box<ProfileImage>();

          var res = box.getAll();
          print("res.length");
          print(res.length);
          if (res.isEmpty) {
            box.put(profileImage);
            var res = box.getAll();
            for (var element in res) {
              log(element.profileImageString);
              log(element.registerId);
              log(element.id.toString());
            }
          } else {
            final myObject = box.getAll();
            for (var element in res) {
              if (element.registerId == id) {
                element.profileImageString = uint8ListTob64(memoryImage!);
                box.put(element);
              }
            }
          }
          // queueIdList.clear();
          // for (var e in res) {
          //   queueIdList.add(e.songId);
          // }
          // if (queueIdList.contains(playerSongListModel.id)) {
          //   normalToastMessage("Song already in queue ");
          // } else {
          //   box.put(queueSongModel);
          //   normalToastMessage("Song added to queue ");
          // }

          store.close();
        });
      }
      userNameErrorMessage = "";
      ProfileAPIModel profileAPIModel =
          ProfileAPIModel.fromJson(jsonDecode(res.body.toString()));

      User(
          fullName: profileAPIModel.records!.fullname.toString(),
          email: profileAPIModel.records!.email.toString(),
          registerId: profileAPIModel.records!.registerId.toString(),
          userName: profileAPIModel.records!.username.toString());
      // objectBox.insertUser(user);
      successToastMessage(
        "Profile update successfully",
      );
      Navigation.removeAllScreenFromStack(context, const MainScreen());
    } else if (res.statusCode == 400) {
      var jsonData = json.decode(res.body);
      if (jsonData["detail"] == "Username already exist") {
        userNameErrorMessage = "Username already exist";
      }
    } else {}

    // if (res.statusCode == 200) {
    //   debugPrint("IF");

    //   var jsonData = jsonDecode(res.body);
    //   log(jsonData.toString());
    //   // profileAPIModel = ProfileAPIModel.fromJson(jsonData);
    // } else {
    //   debugPrint("Else");

    //   // profileAPIModel =
    //   //     ProfileAPIModel(status: false, message: "No data", records: null);
    // }
    // } catch (e) {
    //   debugPrint(e.toString());
    //   debugPrint("ERRR");
    //   // profileAPIModel =
    //   //     ProfileAPIModel(status: false, message: "No data", records: null);
    // }

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
    //   debugPrint('Before Compress $_sizeInKbBefore kb');
    //   var _compressedImage = await AppHelper.compress(image: image);
    //   final _sizeInKbAfter = _compressedImage.lengthSync() / 1024;
    //   debugPrint('After Compress $_sizeInKbAfter kb');
    //   var _croppedImage = await AppHelper.cropImage(_compressedImage);
    //   if (_croppedImage == null) {
    //     debugPrint("NU:L");
    //     return;
    //   }
    //   isImagePicked = true;

    //   imagePath = File(_croppedImage.path);
    //   // imagePath = _croppedImage.path;

    //   debugPrint("FILE");
    //   debugPrint(imagePath);
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
    debugPrint("Trigger");
    memoryImage = image;
    if (memoryImage != null) {
      base64Value = uint8ListTob64(memoryImage!);

      // compress();
    }
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
            backgroundColor: CustomColor.bg,
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

  Future deleteImage(BuildContext context, BuildContext mainContext) async {
    Navigator.of(context).pop();
    fileImage = null;
    memoryImage = null;

    if (profileAPIModel.records != null) {
      debugPrint("@");
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
    // if (memoryImage != null) {
    //   memoryImage!.clear();
    // }

    notifyListeners();
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

  Future<String> getValue(String key) async {
    return await secureStorage.read(key: key) ?? "";
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

}
