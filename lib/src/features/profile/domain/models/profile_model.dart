class ProfileModel {
  String title;
  bool isArrow;
  bool isHighLight;
  String navigateScreen;
  ProfileModel({
    required this.title,
    this.isArrow = false,
    this.isHighLight = false,
    this.navigateScreen = "",
  });
}
