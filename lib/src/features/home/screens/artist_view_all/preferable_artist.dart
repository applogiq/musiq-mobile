class Preferableartistmodel {
  Preferableartistmodel({
    required this.success,
    required this.message,
    required this.records,
    required this.totalRecords,
  });

  final bool? success;
  final String? message;
  final List<Record> records;
  final int? totalRecords;

  factory Preferableartistmodel.fromJson(Map<String, dynamic> json) {
    return Preferableartistmodel(
      success: json["success"],
      message: json["message"],
      records: json["records"] == null
          ? []
          : List<Record>.from(json["records"]!.map((x) => Record.fromJson(x))),
      totalRecords: json["total_records"],
    );
  }

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "records": records.map((x) => x.toJson()).toList(),
        "total_records": totalRecords,
      };
}

class Record {
  Record({
    required this.id,
    required this.followers,
    required this.createdAt,
    required this.createdBy,
    required this.isDelete,
    required this.isImage,
    required this.artistId,
    required this.artistName,
    required this.updatedAt,
    required this.updatedBy,
    required this.isActive,
  });

  final int? id;
  final int? followers;
  final DateTime? createdAt;
  final int? createdBy;
  final bool? isDelete;
  final bool isImage;
  final String? artistId;
  final String artistName;
  final DateTime? updatedAt;
  final int? updatedBy;
  final bool? isActive;

  factory Record.fromJson(Map<String, dynamic> json) {
    return Record(
      id: json["id"],
      followers: json["followers"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      createdBy: json["created_by"],
      isDelete: json["is_delete"],
      isImage: json["is_image"],
      artistId: json["artist_id"],
      artistName: json["artist_name"],
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
      updatedBy: json["updated_by"],
      isActive: json["is_active"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "followers": followers,
        "created_at": createdAt?.toIso8601String(),
        "created_by": createdBy,
        "is_delete": isDelete,
        "is_image": isImage,
        "artist_id": artistId,
        "artist_name": artistName,
        "updated_at": updatedAt?.toIso8601String(),
        "updated_by": updatedBy,
        "is_active": isActive,
      };
}
