// To parse this JSON data, do
//
//     final playListModel = playListModelFromMap(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

PlayListModel playListModelFromMap(String str) => PlayListModel.fromMap(json.decode(str));

String playListModelToMap(PlayListModel data) => json.encode(data.toMap());

class PlayListModel {
    PlayListModel({
        required this.success,
        required this.message,
        required this.records,
        required this.totalRecords,
    });

    bool success;
    String message;
    List<Record> records;
    int totalRecords;

    factory PlayListModel.fromMap(Map<String, dynamic> json) => PlayListModel(
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
        required this.noOfSongs,
        required this.id,
        required this.createdAt,
        required this.createdBy,
        required this.updatedBy,
        required this.isDelete,
        required this.userId,
        required this.playlistName,
        required this.updatedAt,
        required this.createdUserBy,
        required this.updatedUserBy,
        required this.isActive,
        required this.playlistSongs,
        required this.songId,
        required this.songName,
        required this.albumId,
        required this.albumName,
        required this.musicDirectorName,
        required this.isImage,
    });

    int? noOfSongs;
    int? id;
    DateTime? createdAt;
    dynamic? createdBy;
    dynamic updatedBy;
    bool? isDelete;
    int? userId;
    String? playlistName;
    dynamic updatedAt;
    int? createdUserBy;
    dynamic updatedUserBy;
    bool? isActive;
    PlaylistSongs? playlistSongs;
    String? songId;
    String? songName;
    String? albumId;
    String? albumName;
    List<String?>? musicDirectorName;
    bool? isImage;

    factory Record.fromMap(Map<String, dynamic> json) => Record(
        noOfSongs: json["no_of_songs"] == null ? null : json["no_of_songs"],
        id: json["id"] == null ? null : json["id"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        createdBy: json["created_by"],
        updatedBy: json["updated_by"],
        isDelete: json["is_delete"] == null ? null : json["is_delete"],
        userId: json["user_id"] == null ? null : json["user_id"],
        playlistName: json["playlist_name"] == null ? null : json["playlist_name"],
        updatedAt: json["updated_at"],
        createdUserBy: json["created_user_by"] == null ? null : json["created_user_by"],
        updatedUserBy: json["updated_user_by"],
        isActive: json["is_active"] == null ? null : json["is_active"],
        playlistSongs:json["no_of_songs"]==0?null :  PlaylistSongs.fromMap(json["playlist_songs"]),
        songId: json["song_id"] == null ? null : json["song_id"],
        songName: json["song_name"] == null ? null : json["song_name"],
        albumId: json["album_id"] == null ? null : json["album_id"],
        albumName: json["album_name"] == null ? null : json["album_name"],
        musicDirectorName:json["music_director_name"] == null ? null : List<String>.from(json["music_director_name"].map((x) => x)),
        isImage: json["is_image"] == null ? null : json["is_image"],
    );

    Map<String, dynamic> toMap() => {
        "no_of_songs": noOfSongs == null ? null : noOfSongs,
        "id": id == null ? null : id,
        "created_at": createdAt?.toIso8601String(),
        "created_by": createdBy,
        "updated_by": updatedBy,
        "is_delete": isDelete == null ? null : isDelete,
        "user_id": userId == null ? null : userId,
        "playlist_name": playlistName == null ? null : playlistName,
        "updated_at": updatedAt,
        "created_user_by": createdUserBy == null ? null : createdUserBy,
        "updated_user_by": updatedUserBy,
        "is_active": isActive == null ? null : isActive,
        "playlist_songs": playlistSongs!.toMap(),
        "song_id": songId == null ? null : songId,
        "song_name": songName == null ? null : songName,
        "album_id": albumId == null ? null : albumId,
        "album_name": albumName == null ? null : albumName,
        "music_director_name":List<dynamic>.from(musicDirectorName!.map((x) => x)),
        "is_image": isImage == null ? null : isImage,
    };
}

class PlaylistSongs {
    PlaylistSongs({
        required this.updatedAt,
        required this.playlistId,
        required this.songId,
        required this.createdBy,
        required this.updatedBy,
        required this.isDelete,
        required this.createdAt,
        required this.id,
        required this.createdUserBy,
        required this.updatedUserBy,
        required this.isActive,
    });

    dynamic updatedAt;
    int playlistId;
    int songId;
    int createdBy;
    dynamic updatedBy;
    bool isDelete;
    DateTime createdAt;
    int id;
    dynamic createdUserBy;
    dynamic updatedUserBy;
    bool isActive;

    factory PlaylistSongs.fromMap(Map<String, dynamic> json) => PlaylistSongs(
        updatedAt: json["updated_at"],
        playlistId: json["playlist_id"],
        songId: json["song_id"],
        createdBy: json["created_by"],
        updatedBy: json["updated_by"],
        isDelete: json["is_delete"],
        createdAt: DateTime.parse(json["created_at"]),
        id: json["id"],
        createdUserBy: json["created_user_by"],
        updatedUserBy: json["updated_user_by"],
        isActive: json["is_active"],
    );

    Map<String, dynamic> toMap() => {
        "updated_at": updatedAt,
        "playlist_id": playlistId,
        "song_id": songId,
        "created_by": createdBy,
        "updated_by": updatedBy,
        "is_delete": isDelete,
        "created_at": createdAt.toIso8601String(),
        "id": id,
        "created_user_by": createdUserBy,
        "updated_user_by": updatedUserBy,
        "is_active": isActive,
    };
}
