class GetAllPodcasts {
  GetAllPodcasts({
    required this.success,
    required this.message,
    required this.records,
    required this.totalrecords,
  });

  final bool? success;
  static const String successKey = "success";

  final String? message;
  static const String messageKey = "message";

  final List<Record> records;
  static const String recordsKey = "records";

  final num? totalrecords;
  static const String totalrecordsKey = "totalrecords";

  GetAllPodcasts copyWith({
    bool? success,
    String? message,
    List<Record>? records,
    num? totalrecords,
  }) {
    return GetAllPodcasts(
      success: success ?? this.success,
      message: message ?? this.message,
      records: records ?? this.records,
      totalrecords: totalrecords ?? this.totalrecords,
    );
  }

  factory GetAllPodcasts.fromJson(Map<String, dynamic> json) {
    return GetAllPodcasts(
      success: json["success"],
      message: json["message"],
      records: json["records"] == null
          ? []
          : List<Record>.from(json["records"]!.map((x) => Record.fromJson(x))),
      totalrecords: json["totalrecords"],
    );
  }

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "records": records.map((x) => x.toJson()).toList(),
        "totalrecords": totalrecords,
      };

  @override
  String toString() {
    return "$success, $message, $records, $totalrecords, ";
  }
}

class Record {
  Record({
    required this.id,
    required this.noOfEpisode,
    required this.authorsName,
    required this.categoryName,
    required this.createdAt,
    required this.createdBy,
    required this.isDelete,
    required this.title,
    required this.description,
    required this.authorsId,
    required this.categoryId,
    required this.isImage,
    required this.updatedAt,
    required this.updatedBy,
    required this.isActive,
  });

  final int? id;
  static const String idKey = "id";

  final num? noOfEpisode;
  static const String noOfEpisodeKey = "no_of_episode";

  final List<String> authorsName;
  static const String authorsNameKey = "authors_name";

  final List<String> categoryName;
  static const String categoryNameKey = "category_name";

  final DateTime? createdAt;
  static const String createdAtKey = "created_at";

  final num? createdBy;
  static const String createdByKey = "created_by";

  final bool? isDelete;
  static const String isDeleteKey = "is_delete";

  final String? title;
  static const String titleKey = "title";

  final String? description;
  static const String descriptionKey = "description";

  final List<num> authorsId;
  static const String authorsIdKey = "authors_id";

  final List<num> categoryId;
  static const String categoryIdKey = "category_id";

  final bool? isImage;
  static const String isImageKey = "is_image";

  final dynamic updatedAt;
  static const String updatedAtKey = "updated_at";

  final dynamic updatedBy;
  static const String updatedByKey = "updated_by";

  final bool? isActive;
  static const String isActiveKey = "is_active";

  Record copyWith({
    int? id,
    num? noOfEpisode,
    List<String>? authorsName,
    List<String>? categoryName,
    DateTime? createdAt,
    num? createdBy,
    bool? isDelete,
    String? title,
    String? description,
    List<num>? authorsId,
    List<num>? categoryId,
    bool? isImage,
    dynamic? updatedAt,
    dynamic? updatedBy,
    bool? isActive,
  }) {
    return Record(
      id: id ?? this.id,
      noOfEpisode: noOfEpisode ?? this.noOfEpisode,
      authorsName: authorsName ?? this.authorsName,
      categoryName: categoryName ?? this.categoryName,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      isDelete: isDelete ?? this.isDelete,
      title: title ?? this.title,
      description: description ?? this.description,
      authorsId: authorsId ?? this.authorsId,
      categoryId: categoryId ?? this.categoryId,
      isImage: isImage ?? this.isImage,
      updatedAt: updatedAt ?? this.updatedAt,
      updatedBy: updatedBy ?? this.updatedBy,
      isActive: isActive ?? this.isActive,
    );
  }

  factory Record.fromJson(Map<String, dynamic> json) {
    return Record(
      id: json["id"],
      noOfEpisode: json["no_of_episode"],
      authorsName: json["authors_name"] == null
          ? []
          : List<String>.from(json["authors_name"]!.map((x) => x)),
      categoryName: json["category_name"] == null
          ? []
          : List<String>.from(json["category_name"]!.map((x) => x)),
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      createdBy: json["created_by"],
      isDelete: json["is_delete"],
      title: json["title"],
      description: json["description"],
      authorsId: json["authors_id"] == null
          ? []
          : List<num>.from(json["authors_id"]!.map((x) => x)),
      categoryId: json["category_id"] == null
          ? []
          : List<num>.from(json["category_id"]!.map((x) => x)),
      isImage: json["is_image"],
      updatedAt: json["updated_at"],
      updatedBy: json["updated_by"],
      isActive: json["is_active"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "no_of_episode": noOfEpisode,
        "authors_name": authorsName.map((x) => x).toList(),
        "category_name": categoryName.map((x) => x).toList(),
        "created_at": createdAt?.toIso8601String(),
        "created_by": createdBy,
        "is_delete": isDelete,
        "title": title,
        "description": description,
        "authors_id": authorsId.map((x) => x).toList(),
        "category_id": categoryId.map((x) => x).toList(),
        "is_image": isImage,
        "updated_at": updatedAt,
        "updated_by": updatedBy,
        "is_active": isActive,
      };

  @override
  String toString() {
    return "$id, $noOfEpisode, $authorsName, $categoryName, $createdAt, $createdBy, $isDelete, $title, $description, $authorsId, $categoryId, $isImage, $updatedAt, $updatedBy, $isActive, ";
  }
}
