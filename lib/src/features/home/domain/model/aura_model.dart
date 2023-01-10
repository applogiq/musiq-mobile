import 'dart:convert';

AuraModel auraModelFromMap(String str) => AuraModel.fromMap(json.decode(str));

String auraModelToMap(AuraModel data) => json.encode(data.toMap());

class AuraModel {
  AuraModel({
    required this.success,
    required this.message,
    required this.records,
    required this.totalRecords,
  });

  bool success;
  String message;
  List<Record> records;
  int totalRecords;

  factory AuraModel.fromMap(Map<String, dynamic> json) => AuraModel(
        success: json["success"],
        message: json["message"],
        records:
            List<Record>.from(json["records"].map((x) => Record.fromMap(x))),
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
    required this.auraId,
    required this.auraName,
    required this.isImage,
    required this.updatedAt,
    required this.updatedBy,
    required this.isDelete,
    required this.id,
    required this.noOfSongs,
    required this.createdAt,
    required this.createdBy,
    required this.isActive,
  });

  String auraId;
  String auraName;
  bool isImage;
  dynamic updatedAt;
  dynamic updatedBy;
  bool isDelete;
  int id;
  int noOfSongs;
  DateTime createdAt;
  int createdBy;
  bool isActive;

  factory Record.fromMap(Map<String, dynamic> json) => Record(
        auraId: json["aura_id"],
        auraName: json["aura_name"],
        isImage: json["is_image"],
        updatedAt: json["updated_at"],
        updatedBy: json["updated_by"],
        isDelete: json["is_delete"],
        id: json["id"],
        noOfSongs: json["no_of_songs"],
        createdAt: DateTime.parse(json["created_at"]),
        createdBy: json["created_by"],
        isActive: json["is_active"],
      );

  Map<String, dynamic> toMap() => {
        "aura_id": auraId,
        "aura_name": auraName,
        "is_image": isImage,
        "updated_at": updatedAt,
        "updated_by": updatedBy,
        "is_delete": isDelete,
        "id": id,
        "no_of_songs": noOfSongs,
        "created_at": createdAt.toIso8601String(),
        "created_by": createdBy,
        "is_active": isActive,
      };
}
