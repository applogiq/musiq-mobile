import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../model/profile_model.dart';

class ProfileController extends GetxController{
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

 convertToBase64Image() async {
    Uint8List imagebytes = await imagePath.readAsBytes(); 
    String base64string =
        base64.encode(imagebytes); 
    print(base64string);
  }

  void changeImage()async {
    ImagePicker picker = ImagePicker();
       XFile? image =
                          await picker.pickImage(source: ImageSource.gallery);
                      if (image != null) {
                       
                          isImagePicked = true;
                          imagePath = File(image.path);
                       }
                       update();
  }

}