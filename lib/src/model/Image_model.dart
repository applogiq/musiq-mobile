class ImageModel {
  String imageURL;
  String title;
  String subTitle;
  ImageModel({
    required this.imageURL,
    required this.title,
    required this.subTitle,
  });
}

class ArtistImageModel {
  String imageURL;
  String title;
  String subTitle;
  bool isFollowing;
  ArtistImageModel({
    required this.imageURL,
    required this.title,
    required this.subTitle,
    required this.isFollowing,
  });
}
