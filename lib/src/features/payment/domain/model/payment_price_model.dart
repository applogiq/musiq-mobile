class PremiumPriceModel {
  PremiumPriceModel({
    required this.success,
    required this.message,
    required this.records,
    required this.totalrecords,
  });

  final bool success;
  final String message;
  final List<Record> records;
  final int totalrecords;

  factory PremiumPriceModel.fromMap(Map<String, dynamic> json) =>
      PremiumPriceModel(
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
    required this.comparePrice,
    required this.id,
    required this.createdAt,
    required this.createdBy,
    required this.isDelete,
    required this.title,
    required this.price,
    required this.validity,
    required this.updatedAt,
    required this.updatedBy,
    required this.isActive,
  });

  final int comparePrice;
  final int id;
  final DateTime createdAt;
  final int createdBy;
  final bool isDelete;
  final String title;
  final int price;
  final int validity;
  final DateTime updatedAt;
  final dynamic updatedBy;
  final bool isActive;

  factory Record.fromMap(Map<String, dynamic> json) => Record(
        comparePrice: json["compare_price"],
        id: json["id"],
        createdAt: DateTime.parse(json["created_at"]),
        createdBy: json["created_by"],
        isDelete: json["is_delete"],
        title: json["title"],
        price: json["price"],
        validity: json["validity"],
        updatedAt: DateTime.parse(json["updated_at"]),
        updatedBy: json["updated_by"],
        isActive: json["is_active"],
      );

  Map<String, dynamic> toMap() => {
        "compare_price": comparePrice,
        "id": id,
        "created_at": createdAt.toIso8601String(),
        "created_by": createdBy,
        "is_delete": isDelete,
        "title": title,
        "price": price,
        "validity": validity,
        "updated_at": updatedAt.toIso8601String(),
        "updated_by": updatedBy,
        "is_active": isActive,
      };
}
