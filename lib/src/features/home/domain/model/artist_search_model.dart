import 'dart:convert';

ArtistSearchModel artistSearchModelFromMap(String str) =>
    ArtistSearchModel.fromMap(json.decode(str));

String artistSearchModelToMap(ArtistSearchModel data) =>
    json.encode(data.toMap());

class ArtistSearchModel {
  ArtistSearchModel({
    required this.success,
    required this.message,
    required this.records,
    required this.totalrecords,
  });

  final bool success;
  final String message;
  final List<Record> records;
  final int totalrecords;

  factory ArtistSearchModel.fromMap(Map<String, dynamic> json) =>
      ArtistSearchModel(
        success: json["success"],
        message: json["message"],
        records:
            List<Record>.from(json["records"].map((x) => Record.fromMap(x))),
        totalrecords: json["totalrecords"],
      );

  Map<String, dynamic> toMap() => {
        "success": success,
        "message": message,
        "records": List<dynamic>.from(records.map((x) => x.toMap())),
        "totalrecords": totalrecords,
      };
}

class Record {
  Record({
    required this.followers,
    required this.id,
    required this.createdAt,
    required this.createdBy,
    required this.isDelete,
    required this.artistId,
    required this.artistName,
    required this.isImage,
    required this.updatedAt,
    required this.updatedBy,
    required this.isActive,
  });

  final int followers;
  final int id;
  final DateTime createdAt;
  final int createdBy;
  final bool isDelete;
  final String artistId;
  final String artistName;
  final bool isImage;
  final dynamic updatedAt;
  final dynamic updatedBy;
  final bool isActive;

  factory Record.fromMap(Map<String, dynamic> json) => Record(
        followers: json["followers"],
        id: json["id"],
        createdAt: DateTime.parse(json["created_at"]),
        createdBy: json["created_by"],
        isDelete: json["is_delete"],
        artistId: json["artist_id"],
        artistName: json["artist_name"],
        isImage: json["is_image"],
        updatedAt: json["updated_at"],
        updatedBy: json["updated_by"],
        isActive: json["is_active"],
      );

  Map<String, dynamic> toMap() => {
        "followers": followers,
        "id": id,
        "created_at": createdAt.toIso8601String(),
        "created_by": createdBy,
        "is_delete": isDelete,
        "artist_id": artistId,
        "artist_name": artistName,
        "is_image": isImage,
        "updated_at": updatedAt,
        "updated_by": updatedBy,
        "is_active": isActive,
      };
}
