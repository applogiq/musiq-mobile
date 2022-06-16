
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
       required this.email,
       required this.otpTime,
       required this.isActive,
       required this.fullname,
       required this.createdBy,
       required this.updatedBy,
       required this.createdAt,
       required this.preference,
       required this.username,
       required this.isDelete,
       required this.registerId,
       required this.updatedAt,
       required this.id,
       required this.isImage,
       required this.otp,
       required this.password,
    });

    String email;
    dynamic otpTime;
    int isActive;
    String fullname;
    int createdBy;
    int updatedBy;
    DateTime createdAt;
    Preference preference;
    String username;
    int isDelete;
    int registerId;
    dynamic updatedAt;
    int id;
    dynamic isImage;
    dynamic otp;
    String password;

    factory Records.fromMap(Map<String, dynamic> json) => Records(
        email: json["email"],
        otpTime: json["otp_time"],
        isActive: json["is_active"],
        fullname: json["fullname"],
        createdBy: json["created_by"],
        updatedBy: json["updated_by"],
        createdAt: DateTime.parse(json["created_at"]),
        preference: Preference.fromMap(json["preference"]),
        username: json["username"],
        isDelete: json["is_delete"],
        registerId: json["register_id"],
        updatedAt: json["updated_at"],
        id: json["id"],
        isImage: json["is_image"],
        otp: json["otp"],
        password: json["password"],
    );

    Map<String, dynamic> toMap() => {
        "email": email,
        "otp_time": otpTime,
        "is_active": isActive,
        "fullname": fullname,
        "created_by": createdBy,
        "updated_by": updatedBy,
        "created_at": createdAt.toIso8601String(),
        "preference": preference.toMap(),
        "username": username,
        "is_delete": isDelete,
        "register_id": registerId,
        "updated_at": updatedAt,
        "id": id,
        "is_image": isImage,
        "otp": otp,
        "password": password,
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
