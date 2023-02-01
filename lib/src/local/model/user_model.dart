import 'package:objectbox/objectbox.dart';

@Entity()
class User {
  User(
      {this.id = 0,
      required this.fullName,
      required this.email,
      required this.registerId,
      required this.userName});

  String email;
  String fullName;
  @Id()
  int id;

  String registerId;
  String userName;
}

@Entity()
class ProfileImage {
  ProfileImage(
      {this.id = 0,
      required this.isImage,
      required this.registerId,
      required this.profileImageString});

  @Id()
  int id;

  bool isImage;
  String profileImageString;
  String registerId;
}
