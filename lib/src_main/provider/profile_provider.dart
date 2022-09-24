import 'package:flutter/foundation.dart';

import '../widgets/model/profile_model.dart';

class ProfileProvider extends ChangeNotifier {
  List<ProfileModel> profileContent = [
    ProfileModel(
        title: "My Profile", isArrow: true, navigateScreen: "myProfile"),
    ProfileModel(
        title: "Preferences", isArrow: true, navigateScreen: "preferences"),
    ProfileModel(
        title: "Contact us", isArrow: true, navigateScreen: "myProfile"),
  ];

  var isAboutOpen = false;

  void aboutToggle() {
    isAboutOpen = !isAboutOpen;
    notifyListeners();
  }
}
