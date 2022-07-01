// To parse this JSON data, do
//
//     final playListSongModel = playListSongModelFromMap(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

PlayListSongModel playListSongModelFromMap(String str) => PlayListSongModel.fromMap(json.decode(str));

String playListSongModelToMap(PlayListSongModel data) => json.encode(data.toMap());

class PlayListSongModel {
    PlayListSongModel({
        required this.records,
        required this.totalRecords,
        required this.success,
        required this.message,
    });

    List<Record> records;
    int totalRecords;
    bool success;
    String message;

    factory PlayListSongModel.fromMap(Map<String, dynamic> json) => PlayListSongModel(
        records: List<Record>.from(json["records"].map((x) => Record.fromMap(x))),
        totalRecords: json["total_records"],
        success: json["success"],
        message: json["message"],
    );

    Map<String, dynamic> toMap() => {
        "records": List<dynamic>.from(records.map((x) => x.toMap())),
        "total_records": totalRecords,
        "success": success,
        "message": message,
    };
}

class Record {
    Record({
        required this.playlistSongs,
        required this.playlistName,
        required this.id,
        required this.noOfSongs,
        required this.songId,
        required this.songName,
        required this.albumId,
        required this.albumName,
        required this.musicDirectorName,
        required this.isImage,
    });

    PlaylistSongs playlistSongs;
    String playlistName;
    int id;
    int noOfSongs;
    String songId;
    String songName;
    String albumId;
    String albumName;
    List<String> musicDirectorName;
    bool isImage;

    factory Record.fromMap(Map<String, dynamic> json) => Record(
        playlistSongs: PlaylistSongs.fromMap(json["playlist_songs"]),
        playlistName: json["playlist_name"],
        id: json["id"],
        noOfSongs: json["no_of_songs"],
        songId: json["song_id"],
        songName: json["song_name"],
        albumId: json["album_id"],
        albumName: json["album_name"],
        musicDirectorName: List<String>.from(json["music_director_name"].map((x) => x)),
        isImage: json["is_image"],
    );

    Map<String, dynamic> toMap() => {
        "playlist_songs": playlistSongs.toMap(),
        "playlist_name": playlistName,
        "id": id,
        "no_of_songs": noOfSongs,
        "song_id": songId,
        "song_name": songName,
        "album_id": albumId,
        "album_name": albumName,
        "music_director_name": List<dynamic>.from(musicDirectorName.map((x) => x)),
        "is_image": isImage,
    };
}

class PlaylistSongs {
    PlaylistSongs({
        required this.playlistId,
        required this.songId,
        required this.updatedAt,
        required this.createdBy,
        required this.updatedBy,
        required this.isDelete,
        required this.createdAt,
        required this.id,
        required this.createdUserBy,
        required this.updatedUserBy,
        required this.isActive,
    });

    int playlistId;
    int songId;
    dynamic updatedAt;
    int createdBy;
    dynamic updatedBy;
    bool isDelete;
    DateTime createdAt;
    int id;
    dynamic createdUserBy;
    dynamic updatedUserBy;
    bool isActive;

    factory PlaylistSongs.fromMap(Map<String, dynamic> json) => PlaylistSongs(
        playlistId: json["playlist_id"],
        songId: json["song_id"],
        updatedAt: json["updated_at"],
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
        "playlist_id": playlistId,
        "song_id": songId,
        "updated_at": updatedAt,
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
