
import 'dart:convert';

ArtistModel artistModelFromMap(String str) => ArtistModel.fromMap(json.decode(str));

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
        records: List<Record>.from(json["records"].map((x) => Record.fromMap(x))),
        totalRecords: json["total_records"],
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
        required this.artistId,
        required this.followers,
        required this.createdAt,
        required this.updatedAt,
        required this.updatedBy,
        required this.isActive,
        required this.isImage,
        required this.id,
        required this.name,
        required this.createdBy,
        required this.isDelete,
    });

    String artistId;
    int followers;
    DateTime createdAt;
    dynamic updatedAt;
    dynamic updatedBy;
    bool isActive;
    bool isImage;
    int id;
    String name;
    int createdBy;
    bool isDelete;

    factory Record.fromMap(Map<String, dynamic> json) => Record(
        artistId: json["artist_id"],
        followers: json["followers"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"],
        updatedBy: json["updated_by"],
        isActive: json["is_active"],
        isImage: json["is_image"],
        id: json["id"],
        name: json["name"],
        createdBy: json["created_by"],
        isDelete: json["is_delete"],
    );

    Map<String, dynamic> toMap() => {
        "artist_id": artistId,
        "followers": followers,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt,
        "updated_by": updatedBy,
        "is_active": isActive,
        "is_image": isImage,
        "id": id,
        "name": name,
        "created_by": createdBy,
        "is_delete": isDelete,
    };
}
