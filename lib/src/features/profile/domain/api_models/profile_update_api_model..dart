class ProfileAPIModel {
  ProfileAPIModel({
    required this.status,
    required this.message,
    required this.records,
  });

  final bool? status;
  final String? message;
  final Records? records;

  factory ProfileAPIModel.fromJson(Map<String, dynamic> json) {
    return ProfileAPIModel(
      status: json["status"],
      message: json["message"],
      records:
          json["records"] == null ? null : Records.fromJson(json["records"]),
    );
  }
}

class Records {
  Records({
    required this.registerId,
    required this.otp,
    required this.updatedUserBy,
    required this.id,
    required this.otpTime,
    required this.isDelete,
    required this.fullname,
    required this.isImage,
    required this.isActive,
    required this.username,
    required this.createdAt,
    required this.email,
    required this.updatedAt,
    required this.password,
    required this.createdBy,
    required this.preference,
    required this.createdUserBy,
    required this.isPreference,
    required this.updatedBy,
  });

  final int? registerId;
  final String? otp;
  final int? updatedUserBy;
  final int? id;
  final double? otpTime;
  final bool? isDelete;
  final String? fullname;
  final bool? isImage;
  final bool? isActive;
  final String? username;
  final DateTime? createdAt;
  final String? email;
  final DateTime? updatedAt;
  final String? password;
  final dynamic createdBy;
  final Preference? preference;
  final int? createdUserBy;
  final bool? isPreference;
  final dynamic updatedBy;

  factory Records.fromJson(Map<String, dynamic> json) {
    return Records(
      registerId: json["register_id"],
      otp: json["otp"],
      updatedUserBy: json["updated_user_by"],
      id: json["id"],
      otpTime: json["otp_time"],
      isDelete: json["is_delete"],
      fullname: json["fullname"],
      isImage: json["is_image"],
      isActive: json["is_active"],
      username: json["username"],
      createdAt: json["created_at"] == null
          ? null
          : DateTime.parse(json["created_at"]),
      email: json["email"],
      updatedAt: json["updated_at"] == null
          ? null
          : DateTime.parse(json["updated_at"]),
      password: json["password"],
      createdBy: json["created_by"],
      preference: json["preference"] == null
          ? null
          : Preference.fromJson(json["preference"]),
      createdUserBy: json["created_user_by"],
      isPreference: json["is_preference"],
      updatedBy: json["updated_by"],
    );
  }
}

class Preference {
  Preference({
    required this.artist,
  });

  final List<String> artist;

  factory Preference.fromJson(Map<String, dynamic> json) {
    return Preference(
      artist: json["artist"] == null
          ? []
          : List<String>.from(json["artist"]!.map((x) => x)),
    );
  }
}
