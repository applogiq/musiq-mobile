import 'package:objectbox/objectbox.dart';

@Entity()
class User {
  @Id()
  int id;
  String fullName;
  String email;
  String userName;
  String registerId;

  User(
      {this.id = 0,
      required this.fullName,
      required this.email,
      required this.registerId,
      required this.userName});
}
