// To parse this JSON data, do
//
//     final auraSongListModel = auraSongListModelFromMap(jsonString);

import 'dart:convert';

AuraSongListModel auraSongListModelFromMap(String str) =>
    AuraSongListModel.fromMap(json.decode(str));

String auraSongListModelToMap(AuraSongListModel data) =>
    json.encode(data.toMap());

class AuraSongListModel {
  AuraSongListModel({
    required this.success,
    required this.message,
    required this.records,
    required this.totalRecords,
  });

  final bool success;
  final String message;
  final List<Record> records;
  final int totalRecords;

  factory AuraSongListModel.fromMap(Map<String, dynamic> json) =>
      AuraSongListModel(
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
    required this.auraSongs,
    required this.songId,
    required this.songName,
    required this.albumId,
    required this.albumName,
    required this.musicDirectorName,
    required this.isImage,
  });

  final AuraSongs auraSongs;
  final String songId;
  final String songName;
  final String albumId;
  final String albumName;
  final List<String> musicDirectorName;
  final bool isImage;

  factory Record.fromMap(Map<String, dynamic> json) => Record(
        auraSongs: AuraSongs.fromMap(json["aura_songs"]),
        songId: json["song_id"],
        songName: json["song_name"],
        albumId: json["album_id"],
        albumName: json["album_name"],
        musicDirectorName:
            List<String>.from(json["music_director_name"].map((x) => x)),
        isImage: json["is_image"],
      );

  Map<String, dynamic> toMap() => {
        "aura_songs": auraSongs.toMap(),
        "song_id": songId,
        "song_name": songName,
        "album_id": albumId,
        "album_name": albumName,
        "music_director_name":
            List<dynamic>.from(musicDirectorName.map((x) => x)),
        "is_image": isImage,
      };
}

class AuraSongs {
  AuraSongs({
    required this.createdAt,
    required this.id,
    required this.isDelete,
    required this.createdBy,
    required this.auraId,
    required this.songId,
    required this.isActive,
  });

  final DateTime createdAt;
  final int id;
  final bool isDelete;
  final int createdBy;
  final int auraId;
  final int songId;
  final bool isActive;

  factory AuraSongs.fromMap(Map<String, dynamic> json) => AuraSongs(
        createdAt: DateTime.parse(json["created_at"]),
        id: json["id"],
        isDelete: json["is_delete"],
        createdBy: json["created_by"],
        auraId: json["aura_id"],
        songId: json["song_id"],
        isActive: json["is_active"],
      );

  Map<String, dynamic> toMap() => {
        "created_at": createdAt.toIso8601String(),
        "id": id,
        "is_delete": isDelete,
        "created_by": createdBy,
        "aura_id": auraId,
        "song_id": songId,
        "is_active": isActive,
      };
}
