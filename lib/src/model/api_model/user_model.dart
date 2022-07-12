// To parse this JSON data, do
//
//     final user = userFromMap(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

User userFromMap(String str) => User.fromMap(json.decode(str));

String userToMap(User data) => json.encode(data.toMap());

class User {
  User({
    required this.status,
    required this.message,
    required this.records,
  });

  bool status;
  String message;
  Records records;

  factory User.fromMap(Map<String, dynamic> json) => User(
        status: json["status"],
        message: json["message"],
        records: Records.fromMap(json["records"]),
      );

  Map<String, dynamic> toMap() => {
        "status": status,
        "message": message,
        "records": records.toMap(),
      };
}

class Records {
  Records({
    required this.isActive,
    required this.username,
    required this.createdAt,
    required this.updatedAt,
    required this.email,
    required this.password,
    required this.createdBy,
    required this.preference,
    required this.createdUserBy,
    required this.isPreference,
    required this.updatedBy,
    required this.registerId,
    required this.otp,
    required this.id,
    required this.updatedUserBy,
    required this.otpTime,
    required this.fullname,
    required this.isDelete,
    required this.isImage,
    required this.accessToken,
    required this.refreshToken,
  });

  bool isActive;
  String username;
  DateTime createdAt;
  dynamic updatedAt;
  String email;
  String password;
  dynamic createdBy;
  Preference preference;
  int createdUserBy;
  bool isPreference;
  dynamic updatedBy;
  int registerId;
  dynamic otp;
  int id;
  dynamic updatedUserBy;
  dynamic otpTime;
  String fullname;
  bool isDelete;
  dynamic isImage;
  String accessToken;
  String refreshToken;

  factory Records.fromMap(Map<String, dynamic> json) => Records(
        isActive: json["is_active"],
        username: json["username"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"],
        email: json["email"],
        password: json["password"],
        createdBy: json["created_by"],
        preference: Preference.fromMap(json["preference"]),
        createdUserBy: json["created_user_by"],
        isPreference: json["is_preference"],
        updatedBy: json["updated_by"],
        registerId: json["register_id"],
        otp: json["otp"],
        id: json["id"],
        updatedUserBy: json["updated_user_by"],
        otpTime: json["otp_time"],
        fullname: json["fullname"],
        isDelete: json["is_delete"],
        isImage: json["is_image"],
        accessToken: json["access_token"],
        refreshToken: json["refresh_token"],
      );

  Map<String, dynamic> toMap() => {
        "is_active": isActive,
        "username": username,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt,
        "email": email,
        "password": password,
        "created_by": createdBy,
        "preference": preference.toMap(),
        "created_user_by": createdUserBy,
        "is_preference": isPreference,
        "updated_by": updatedBy,
        "register_id": registerId,
        "otp": otp,
        "id": id,
        "updated_user_by": updatedUserBy,
        "otp_time": otpTime,
        "fullname": fullname,
        "is_delete": isDelete,
        "is_image": isImage,
        "access_token": accessToken,
        "refresh_token": refreshToken,
      };
}

class Preference {
  Preference({
    required this.artist,
  });

  List<dynamic> artist;

  factory Preference.fromMap(Map<String, dynamic> json) => Preference(
        artist: List<dynamic>.from(json["artist"].map((x) => x)),
      );

  Map<String, dynamic> toMap() => {
        "artist": List<dynamic>.from(artist.map((x) => x)),
      };
}
