import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:musiq/src/helpers/constants/string.dart';

import '../../model/profile_model.dart';

class ProfileController extends GetxController{
  var storage=FlutterSecureStorage();
  var nameValue="".obs;
  var userNameValue="".obs;
    var userNameError="".obs;
  var nameError="".obs;
  var isUserNameError=false.obs;
  var isNameError=false.obs;
  loadData()async{
    var name=await storage.read(key: "fullname");
    var userName=await storage.read(key: "username");
    nameValue.value=name!;
    userNameValue.value=userName!;
    print(name);
    print(userName);
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


var isAboutOpen=false.obs;
String base64StringImage="";

 convertToBase64Image() async {
    Uint8List imagebytes = await imagePath.readAsBytes(); 
    String base64string =
        base64.encode(imagebytes); 
    print(base64string);
    log(base64string);
    base64StringImage=base64string;
  }

   openGallery()async {
    ImagePicker picker = ImagePicker();
       XFile? image =
                          await picker.pickImage(source: ImageSource.gallery);
                      if (image != null) {
                       
                          isImagePicked = true;
                          imagePath = File(image.path);
                       update();

                          return true;
                       }
                       update();
                          return false;

  }
 openCamera()async {
    ImagePicker picker = ImagePicker();
       XFile? image =
                          await picker.pickImage(source: ImageSource.camera);
                      if (image != null) {
                       
                          isImagePicked = true;
                          imagePath = File(image.path);
                       update();

                          return true;
                       }
                       update();
                       return false;
  }
deleteImage()async{
  isImagePicked=false;
  update();
}

  void checkName(String value) {
    if(value.isEmpty){
      isNameError.value=true;
      nameError.value=ConstantText.fieldRequired;

    }
    else{
      isNameError.value=false;
      nameError.value="";

    }
    print(value);
    // update();
  }
  
  void checkUserName(String value) {
      if(value.isEmpty){
      isUserNameError.value=true;
      userNameError.value=ConstantText.fieldRequired;

    }
    else if(value.contains(" ")){
      isUserNameError.value=true;
      userNameError.value=ConstantText.invalidUserName;

    }
    else{
      isUserNameError.value=false;
      userNameError.value="";

    }
  }

  void saveUpdate() {
    if(isNameError.value && isUserNameError.value){
print("Fix Error");


    }
    else {
      
      if(isImagePicked){
        convertToBase64Image();
      }
      else{
        base64StringImage="";
      }
      
      Map params={
            "username": userNameValue.toString(),
            "fullname": nameValue.toString(),
            "image":base64StringImage
      };
      print(params);
    }
  }
}
