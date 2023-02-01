class ProfileModel {
  ProfileModel({
    required this.title,
    this.isArrow = false,
    this.isHighLight = false,
    this.navigateScreen = "",
  });

  bool isArrow;
  bool isHighLight;
  String navigateScreen;
  String title;
}
