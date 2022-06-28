// To parse this JSON data, do
//
//     final auraSongModel = auraSongModelFromMap(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

AuraSongModel auraSongModelFromMap(String str) => AuraSongModel.fromMap(json.decode(str));

String auraSongModelToMap(AuraSongModel data) => json.encode(data.toMap());

class AuraSongModel {
    AuraSongModel({
        required this.success,
        required this.message,
        required this.records,
        required this.totalRecords,
    });

    bool success;
    String message;
    List<Record> records;
    int totalRecords;

    factory AuraSongModel.fromMap(Map<String, dynamic> json) => AuraSongModel(
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
        required this.auraSongs,
        required this.songId,
        required this.songName,
        required this.albumId,
        required this.albumName,
        required this.musicDirectorName,
        required this.isImage,
    });

    AuraSongs auraSongs;
    String songId;
    String songName;
    String albumId;
    String albumName;
    List<String> musicDirectorName;
    bool isImage;

    factory Record.fromMap(Map<String, dynamic> json) => Record(
        auraSongs: AuraSongs.fromMap(json["aura_songs"]),
        songId: json["song_id"],
        songName: json["song_name"],
        albumId: json["album_id"],
        albumName: json["album_name"],
        musicDirectorName: List<String>.from(json["music_director_name"].map((x) => x)),
        isImage: json["is_image"],
    );

    Map<String, dynamic> toMap() => {
        "aura_songs": auraSongs.toMap(),
        "song_id": songId,
        "song_name": songName,
        "album_id": albumId,
        "album_name": albumName,
        "music_director_name": List<dynamic>.from(musicDirectorName.map((x) => x)),
        "is_image": isImage,
    };
}

class AuraSongs {
    AuraSongs({
        required this.createdBy,
        required this.auraId,
        required this.songId,
        required this.isActive,
        required this.createdAt,
        required this.id,
        required this.isDelete,
    });

    int createdBy;
    int auraId;
    int songId;
    bool isActive;
    DateTime createdAt;
    int id;
    bool isDelete;

    factory AuraSongs.fromMap(Map<String, dynamic> json) => AuraSongs(
        createdBy: json["created_by"],
        auraId: json["aura_id"],
        songId: json["song_id"],
        isActive: json["is_active"],
        createdAt: DateTime.parse(json["created_at"]),
        id: json["id"],
        isDelete: json["is_delete"],
    );

    Map<String, dynamic> toMap() => {
        "created_by": createdBy,
        "aura_id": auraId,
        "song_id": songId,
        "is_active": isActive,
        "created_at": createdAt.toIso8601String(),
        "id": id,
        "is_delete": isDelete,
    };
}
