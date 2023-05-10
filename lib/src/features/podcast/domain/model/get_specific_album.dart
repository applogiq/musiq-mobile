class GetSpecificPodcasts {
  GetSpecificPodcasts({
    required this.success,
    required this.message,
    required this.records,
    required this.totalRecords,
  });

  final bool? success;
  static const String successKey = "success";

  final String? message;
  static const String messageKey = "message";

  final List<Record> records;
  static const String recordsKey = "records";

  final num? totalRecords;
  static const String totalRecordsKey = "total_records";

  GetSpecificPodcasts copyWith({
    bool? success,
    String? message,
    List<Record>? records,
    num? totalRecords,
  }) {
    return GetSpecificPodcasts(
      success: success ?? this.success,
      message: message ?? this.message,
      records: records ?? this.records,
      totalRecords: totalRecords ?? this.totalRecords,
    );
  }

  factory GetSpecificPodcasts.fromJson(Map<String, dynamic> json) {
    return GetSpecificPodcasts(
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

  @override
  String toString() {
    return "$success, $message, $records, $totalRecords, ";
  }
}

class Record {
  Record({
    required this.podcastId,
    required this.episodeNumber,
    required this.description,
    required this.duration,
    required this.createdAt,
    required this.createdBy,
    required this.isDelete,
    required this.episodeTitle,
    required this.id,
    required this.subtitles,
    required this.isAudio,
    required this.updatedAt,
    required this.updatedBy,
    required this.isActive,
  });

  final int? podcastId;
  static const String podcastIdKey = "podcast_id";

  final num? episodeNumber;
  static const String episodeNumberKey = "episode_number";

  final String? description;
  static const String descriptionKey = "description";

  final String? duration;
  static const String durationKey = "duration";

  final DateTime? createdAt;
  static const String createdAtKey = "created_at";

  final num? createdBy;
  static const String createdByKey = "created_by";

  final bool? isDelete;
  static const String isDeleteKey = "is_delete";

  final String? episodeTitle;
  static const String episodeTitleKey = "episode_title";

  final int? id;
  static const String idKey = "id";

  final String? subtitles;
  static const String subtitlesKey = "subtitles";

  final bool? isAudio;
  static const String isAudioKey = "is_audio";

  final dynamic updatedAt;
  static const String updatedAtKey = "updated_at";

  final dynamic updatedBy;
  static const String updatedByKey = "updated_by";

  final bool? isActive;
  static const String isActiveKey = "is_active";

  Record copyWith({
    int? podcastId,
    num? episodeNumber,
    String? description,
    String? duration,
    DateTime? createdAt,
    num? createdBy,
    bool? isDelete,
    String? episodeTitle,
    int? id,
    String? subtitles,
    bool? isAudio,
    dynamic? updatedAt,
    dynamic? updatedBy,
    bool? isActive,
  }) {
    return Record(
      podcastId: podcastId ?? this.podcastId,
      episodeNumber: episodeNumber ?? this.episodeNumber,
      description: description ?? this.description,
      duration: duration ?? this.duration,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      isDelete: isDelete ?? this.isDelete,
      episodeTitle: episodeTitle ?? this.episodeTitle,
      id: id ?? this.id,
      subtitles: subtitles ?? this.subtitles,
      isAudio: isAudio ?? this.isAudio,
      updatedAt: updatedAt ?? this.updatedAt,
      updatedBy: updatedBy ?? this.updatedBy,
      isActive: isActive ?? this.isActive,
    );
  }

  factory Record.fromJson(Map<String, dynamic> json) {
    return Record(
      podcastId: json["podcast_id"],
      episodeNumber: json["episode_number"],
      description: json["description"],
      duration: json["duration"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      createdBy: json["created_by"],
      isDelete: json["is_delete"],
      episodeTitle: json["episode_title"],
      id: json["id"],
      subtitles: json["subtitles"],
      isAudio: json["is_audio"],
      updatedAt: json["updated_at"],
      updatedBy: json["updated_by"],
      isActive: json["is_active"],
    );
  }

  Map<String, dynamic> toJson() => {
        "podcast_id": podcastId,
        "episode_number": episodeNumber,
        "description": description,
        "duration": duration,
        "created_at": createdAt?.toIso8601String(),
        "created_by": createdBy,
        "is_delete": isDelete,
        "episode_title": episodeTitle,
        "id": id,
        "subtitles": subtitles,
        "is_audio": isAudio,
        "updated_at": updatedAt,
        "updated_by": updatedBy,
        "is_active": isActive,
      };

  @override
  String toString() {
    return "$podcastId, $episodeNumber, $description, $duration, $createdAt, $createdBy, $isDelete, $episodeTitle, $id, $subtitles, $isAudio, $updatedAt, $updatedBy, $isActive, ";
  }
}
