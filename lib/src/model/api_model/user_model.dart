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
        required this.createdBy,
        required this.id,
        required this.updatedAt,
        required this.isDelete,
        required this.isImage,
        required this.password,
        required this.otp,
        required this.updatedBy,
        required this.registerId,
        required this.username,
        required this.email,
        required this.preference,
        required this.updatedUserBy,
        required this.fullname,
        required this.isActive,
        required this.createdAt,
        required this.otpTime,
        required this.createdUserBy,
    });

    String accessToken;
    String refreshToken;
    dynamic createdBy;
    int id;
    dynamic updatedAt;
    bool isDelete;
    dynamic isImage;
    String password;
    dynamic otp;
    dynamic updatedBy;
    int registerId;
    String username;
    String email;
    Preference preference;
    dynamic updatedUserBy;
    String fullname;
    bool isActive;
    DateTime createdAt;
    dynamic otpTime;
    int createdUserBy;

    factory Records.fromMap(Map<String, dynamic> json) => Records(
        accessToken: json["access_token"],
        refreshToken: json["refresh_token"],
        createdBy: json["created_by"],
        id: json["id"],
        updatedAt: json["updated_at"],
        isDelete: json["is_delete"],
        isImage: json["is_image"],
        password: json["password"],
        otp: json["otp"],
        updatedBy: json["updated_by"],
        registerId: json["register_id"],
        username: json["username"],
        email: json["email"],
        preference: Preference.fromMap(json["preference"]),
        updatedUserBy: json["updated_user_by"],
        fullname: json["fullname"],
        isActive: json["is_active"],
        createdAt: DateTime.parse(json["created_at"]),
        otpTime: json["otp_time"],
        createdUserBy: json["created_user_by"],
    );

    Map<String, dynamic> toMap() => {
        "access_token": accessToken,
        "refresh_token": refreshToken,
        "created_by": createdBy,
        "id": id,
        "updated_at": updatedAt,
        "is_delete": isDelete,
        "is_image": isImage,
        "password": password,
        "otp": otp,
        "updated_by": updatedBy,
        "register_id": registerId,
        "username": username,
        "email": email,
        "preference": preference.toMap(),
        "updated_user_by": updatedUserBy,
        "fullname": fullname,
        "is_active": isActive,
        "created_at": createdAt.toIso8601String(),
        "otp_time": otpTime,
        "created_user_by": createdUserBy,
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
