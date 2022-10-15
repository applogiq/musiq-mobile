import 'dart:convert';

UserModel userModelFromMap(String str) => UserModel.fromMap(json.decode(str));

String userModelToMap(UserModel data) => json.encode(data.toMap());

class UserModel {
  UserModel({
    required this.records,
  });

  Records records;

  factory UserModel.fromMap(Map<String, dynamic> json) => UserModel(
        records: Records.fromMap(json["records"]),
      );

  Map<String, dynamic> toMap() => {
        "records": records.toMap(),
      };
}

class Records {
  Records({
    required this.registerId,
    required this.id,
    required this.isDelete,
    required this.fullname,
    required this.isImage,
    required this.isActive,
    required this.username,
    required this.email,
    required this.password,
    required this.preference,
    required this.isPreference,
    required this.accessToken,
    required this.refreshToken,
  });

  int registerId;

  int id;
  bool isDelete;
  String fullname;
  bool? isImage;
  bool isActive;
  String username;
  String email;
  String password;
  Preference preference;
  bool isPreference;
  String accessToken;
  String refreshToken;

  factory Records.fromMap(Map<String, dynamic> json) => Records(
        registerId: json["register_id"],
        id: json["id"],
        isDelete: json["is_delete"],
        fullname: json["fullname"],
        isImage: json["is_image"] == null ? false : true,
        isActive: json["is_active"],
        username: json["username"],
        email: json["email"],
        password: json["password"],
        preference: Preference.fromMap(json["preference"]),
        isPreference: json["is_preference"],
        accessToken: json["access_token"],
        refreshToken: json["refresh_token"],
      );

  Map<String, dynamic> toMap() => {
        "register_id": registerId,
        "id": id,
        "is_delete": isDelete,
        "fullname": fullname,
        "is_image": isImage,
        "is_active": isActive,
        "username": username,
        "email": email,
        "password": password,
        "preference": preference.toMap(),
        "is_preference": isPreference,
        "access_token": accessToken,
        "refresh_token": refreshToken,
      };
}

class Preference {
  Preference({
    required this.artist,
  });

  List<String> artist;

  factory Preference.fromMap(Map<String, dynamic> json) => Preference(
        artist: List<String>.from(json["artist"].map((x) => x)),
      );

  Map<String, dynamic> toMap() => {
        "artist": List<dynamic>.from(artist.map((x) => x)),
      };
}
