import 'dart:convert';

ArtistModel artistModelFromMap(String str) =>
    ArtistModel.fromMap(json.decode(str));

String artistModelToMap(ArtistModel data) => json.encode(data.toMap());

class ArtistModel {
  ArtistModel({
    required this.success,
    required this.message,
    required this.records,
    required this.totalRecords,
  });

  bool success;
  String message;
  List<Record> records;
  int totalRecords;

  factory ArtistModel.fromMap(Map<String, dynamic> json) => ArtistModel(
        success: json["success"],
        message: json["message"],
        records:
            List<Record>.from(json["records"].map((x) => Record.fromMap(x))),
        totalRecords: json["total_records"] ?? json["totalrecords"],
      );

  Map<String, dynamic> toMap() => {
        "success": success,
        "message": message,
        "records": List<dynamic>.from(records.map((x) => x.toMap())),
        "total_records": totalRecords,
      };
}

class Record {
  Record({
    required this.id,
    required this.artistName,
    required this.isImage,
    required this.updatedAt,
    required this.updatedBy,
    required this.isActive,
    required this.followers,
    required this.artistId,
    required this.createdAt,
    required this.createdBy,
    required this.isDelete,
  });

  int id;
  String artistName;
  bool isImage;
  dynamic updatedAt;
  dynamic updatedBy;
  bool isActive;
  dynamic followers;
  String artistId;
  DateTime createdAt;
  int createdBy;
  bool isDelete;

  factory Record.fromMap(Map<String, dynamic> json) => Record(
        id: json["id"],
        artistName: json["artist_name"],
        isImage: json["is_image"],
        updatedAt: json["updated_at"],
        updatedBy: json["updated_by"],
        isActive: json["is_active"],
        followers: json["followers"],
        artistId: json["artist_id"],
        createdAt: DateTime.parse(json["created_at"]),
        createdBy: json["created_by"],
        isDelete: json["is_delete"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "artist_name": artistName,
        "is_image": isImage,
        "updated_at": updatedAt,
        "updated_by": updatedBy,
        "is_active": isActive,
        "followers": followers,
        "artist_id": artistId,
        "created_at": createdAt.toIso8601String(),
        "created_by": createdBy,
        "is_delete": isDelete,
      };
}
