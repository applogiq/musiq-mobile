import 'package:get/get.dart';

import '../../model/profile_model.dart';

class ProfileController extends GetxController{
List<ProfileModel> profileContent = [
    ProfileModel(
        title: "My Profile", isArrow: true, navigateScreen: "myProfile"),
    ProfileModel(
        title: "Preferences", isArrow: true, navigateScreen: "preferences"),
    ProfileModel(
        title: "Contact us", isArrow: true, navigateScreen: "myProfile"),
    ProfileModel(title: "About", isArrow: false, navigateScreen: "myProfile"),
  ];



var isAboutOpen=false.obs;



}