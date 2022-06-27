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
        required this.accessToken,
        required this.refreshToken,
        required this.createdAt,
        required this.isActive,
        required this.fullname,
        required this.updatedAt,
        required this.username,
        required this.email,
        required this.createdBy,
        required this.createdUserBy,
        required this.password,
        required this.preference,
        required this.updatedBy,
        required this.registerId,
        required this.otp,
        required this.updatedUserBy,
        required this.isDelete,
        required this.otpTime,
        required this.id,
        required this.isImage,
    });

    String accessToken;
    String refreshToken;
    DateTime createdAt;
    bool isActive;
    String fullname;
    dynamic updatedAt;
    String username;
    String email;
    dynamic createdBy;
    int createdUserBy;
    String password;
    Preference preference;
    dynamic updatedBy;
    int registerId;
    dynamic otp;
    dynamic updatedUserBy;
    bool isDelete;
    dynamic otpTime;
    int id;
    dynamic isImage;

    factory Records.fromMap(Map<String, dynamic> json) => Records(
        accessToken: json["access_token"],
        refreshToken: json["refresh_token"],
        createdAt: DateTime.parse(json["created_at"]),
        isActive: json["is_active"],
        fullname: json["fullname"],
        updatedAt: json["updated_at"],
        username: json["username"],
        email: json["email"],
        createdBy: json["created_by"],
        createdUserBy: json["created_user_by"],
        password: json["password"],
        preference: Preference.fromMap(json["preference"]),
        updatedBy: json["updated_by"],
        registerId: json["register_id"],
        otp: json["otp"],
        updatedUserBy: json["updated_user_by"],
        isDelete: json["is_delete"],
        otpTime: json["otp_time"],
        id: json["id"],
        isImage: json["is_image"],
    );

    Map<String, dynamic> toMap() => {
        "access_token": accessToken,
        "refresh_token": refreshToken,
        "created_at": createdAt.toIso8601String(),
        "is_active": isActive,
        "fullname": fullname,
        "updated_at": updatedAt,
        "username": username,
        "email": email,
        "created_by": createdBy,
        "created_user_by": createdUserBy,
        "password": password,
        "preference": preference.toMap(),
        "updated_by": updatedBy,
        "register_id": registerId,
        "otp": otp,
        "updated_user_by": updatedUserBy,
        "is_delete": isDelete,
        "otp_time": otpTime,
        "id": id,
        "is_image": isImage,
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
