// To parse this JSON data, do
//
//     final playListModel = playListModelFromMap(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

PlayListModel playListModelFromMap(String str) =>
    PlayListModel.fromMap(json.decode(str));

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
    required this.createdAt,
    required this.createdBy,
    required this.updatedBy,
    required this.isDelete,
    required this.userId,
    required this.updatedAt,
    required this.createdUserBy,
    required this.updatedUserBy,
    required this.isActive,
  });

  PlaylistSongs? playlistSongs;
  String playlistName;
  int id;
  int noOfSongs;
  String? songId;
  String? songName;
  String? albumId;
  String? albumName;
  List<String?>? musicDirectorName;
  bool? isImage;
  DateTime? createdAt;
  dynamic createdBy;
  dynamic updatedBy;
  bool? isDelete;
  int? userId;
  dynamic updatedAt;
  int? createdUserBy;
  dynamic updatedUserBy;
  bool? isActive;

  factory Record.fromMap(Map<String, dynamic> json) => Record(
        playlistSongs: json["playlist_songs"] == null
            ? null
            : PlaylistSongs.fromMap(json["playlist_songs"]),
        playlistName: json["playlist_name"],
        id: json["id"],
        noOfSongs: json["no_of_songs"],
        songId: json["song_id"] == null ? null : json["song_id"],
        songName: json["song_name"] == null ? null : json["song_name"],
        albumId: json["album_id"] == null ? null : json["album_id"],
        albumName: json["album_name"] == null ? null : json["album_name"],
        musicDirectorName: json["music_director_name"] == null
            ? null
            : List<String>.from(json["music_director_name"].map((x) => x)),
        isImage: json["is_image"] == null ? null : json["is_image"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        createdBy: json["created_by"],
        updatedBy: json["updated_by"],
        isDelete: json["is_delete"] == null ? null : json["is_delete"],
        userId: json["user_id"] == null ? null : json["user_id"],
        updatedAt: json["updated_at"],
        createdUserBy:
            json["created_user_by"] == null ? null : json["created_user_by"],
        updatedUserBy: json["updated_user_by"],
        isActive: json["is_active"] == null ? null : json["is_active"],
      );

  Map<String, dynamic> toMap() => {
        "playlist_songs": playlistSongs == null ? null : playlistSongs!.toMap(),
        "playlist_name": playlistName,
        "id": id,
        "no_of_songs": noOfSongs,
        "song_id": songId == null ? null : songId,
        "song_name": songName == null ? null : songName,
        "album_id": albumId == null ? null : albumId,
        "album_name": albumName == null ? null : albumName,
        "music_director_name": musicDirectorName == null
            ? null
            : List<dynamic>.from(musicDirectorName!.map((x) => x)),
        "is_image": isImage == null ? null : isImage,
        "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
        "created_by": createdBy,
        "updated_by": updatedBy,
        "is_delete": isDelete == null ? null : isDelete,
        "user_id": userId == null ? null : userId,
        "updated_at": updatedAt,
        "created_user_by": createdUserBy == null ? null : createdUserBy,
        "updated_user_by": updatedUserBy,
        "is_active": isActive == null ? null : isActive,
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
    required this.id,
    required this.createdAt,
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
  int id;
  DateTime createdAt;
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
        id: json["id"],
        createdAt: DateTime.parse(json["created_at"]),
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
        "id": id,
        "created_at": createdAt.toIso8601String(),
        "created_user_by": createdUserBy,
        "updated_user_by": updatedUserBy,
        "is_active": isActive,
      };
}

// To parse this JSON data, do
//
//     final playListModel = playListModelFromMap(jsonString);


// import 'package:meta/meta.dart';
// import 'dart:convert';

// PlayListModel playListModelFromMap(String str) =>
//     PlayListModel.fromMap(json.decode(str));

// String playListModelToMap(PlayListModel data) => json.encode(data.toMap());

// class PlayListModel {
//   PlayListModel({
//     required this.success,
//     required this.message,
//     required this.records,
//     required this.totalRecords,
//   });

//   bool success;
//   String message;
//   List<Record> records;
//   int totalRecords;

//   factory PlayListModel.fromMap(Map<String, dynamic> json) => PlayListModel(
//         success: json["success"],
//         message: json["message"],
//         records:
//             List<Record>.from(json["records"].map((x) => Record.fromMap(x))),
//         totalRecords: json["total_records"],
//       );

//   Map<String, dynamic> toMap() => {
//         "success": success,
//         "message": message,
//         "records": List<dynamic>.from(records.map((x) => x.toMap())),
//         "total_records": totalRecords,
//       };
// }

// class Record {
//   Record({
//     required this.playlistName,
//     required this.userId,
//     required this.createdAt,
//     required this.createdBy,
//     required this.createdUserBy,
//     required this.updatedUserBy,
//     required this.isActive,
//     required this.noOfSongs,
//     required this.id,
//     required this.updatedAt,
//     required this.updatedBy,
//     required this.isDelete,
//     required this.playlistSongs,
//     required this.songId,
//     required this.songName,
//     required this.albumId,
//     required this.albumName,
//     required this.musicDirectorName,
//     required this.isImage,
//   });

//   String playlistName;
//   int? userId;
//   DateTime? createdAt;
//   int? createdBy;
//   dynamic createdUserBy;
//   dynamic updatedUserBy;
//   bool? isActive;
//   int? noOfSongs;
//   int id;
//   dynamic updatedAt;
//   dynamic updatedBy;
//   bool? isDelete;
//   PlaylistSongs? playlistSongs;
//   String? songId;
//   String? songName;
//   String? albumId;
//   String? albumName;
//   List<String>? musicDirectorName;
//   bool? isImage;

//   factory Record.fromMap(Map<String, dynamic> json) => Record(
//         playlistName: json["playlist_name"],
//         userId: json["user_id"] == null ? null : json["user_id"],
//         createdAt: json["created_at"] == null
//             ? null
//             : DateTime.parse(json["created_at"]),
//         createdBy: json["created_by"] == null ? null : json["created_by"],
//         createdUserBy: json["created_user_by"],
//         updatedUserBy: json["updated_user_by"],
//         isActive: json["is_active"] == null ? null : json["is_active"],
//         noOfSongs: json["no_of_songs"] == null ? null : json["no_of_songs"],
//         id: json["id"] == null ? null : json["id"],
//         updatedAt: json["updated_at"],
//         updatedBy: json["updated_by"],
//         isDelete: json["is_delete"] == null ? null : json["is_delete"],
//         playlistSongs: json["playlist_songs"] == null
//             ? null
//             : PlaylistSongs.fromMap(json["playlist_songs"]),
//         songId: json["song_id"] == null ? null : json["song_id"],
//         songName: json["song_name"] == null ? null : json["song_name"],
//         albumId: json["album_id"] == null ? null : json["album_id"],
//         albumName: json["album_name"] == null ? null : json["album_name"],
//         musicDirectorName: json["music_director_name"] == null
//             ? null
//             : List<String>.from(json["music_director_name"].map((x) => x)),
//         isImage: json["is_image"] == null ? null : json["is_image"],
//       );

//   Map<String, dynamic> toMap() => {
//         "playlist_name": playlistName,
//         "user_id": userId == null ? null : userId,
//         "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
//         "created_by": createdBy == null ? null : createdBy,
//         "created_user_by": createdUserBy,
//         "updated_user_by": updatedUserBy,
//         "is_active": isActive == null ? null : isActive,
//         "no_of_songs": noOfSongs == null ? null : noOfSongs,
//         "id": id == null ? null : id,
//         "updated_at": updatedAt,
//         "updated_by": updatedBy,
//         "is_delete": isDelete == null ? null : isDelete,
//         "playlist_songs": playlistSongs == null ? null : playlistSongs!.toMap(),
//         "song_id": songId == null ? null : songId,
//         "song_name": songName == null ? null : songName,
//         "album_id": albumId == null ? null : albumId,
//         "album_name": albumName == null ? null : albumName,
//         "music_director_name": musicDirectorName == null
//             ? null
//             : List<dynamic>.from(musicDirectorName!.map((x) => x)),
//         "is_image": isImage == null ? null : isImage,
//       };
// }

// class PlaylistSongs {
//   PlaylistSongs({
//     required this.songId,
//     required this.updatedAt,
//     required this.createdUserBy,
//     required this.updatedUserBy,
//     required this.isActive,
//     required this.createdAt,
//     required this.id,
//     required this.playlistId,
//     required this.createdBy,
//     required this.updatedBy,
//     required this.isDelete,
//   });

//   int songId;
//   dynamic updatedAt;
//   dynamic createdUserBy;
//   dynamic updatedUserBy;
//   bool isActive;
//   DateTime createdAt;
//   int id;
//   int playlistId;
//   int createdBy;
//   dynamic updatedBy;
//   bool isDelete;

//   factory PlaylistSongs.fromMap(Map<String, dynamic> json) => PlaylistSongs(
//         songId: json["song_id"],
//         updatedAt: json["updated_at"],
//         createdUserBy: json["created_user_by"],
//         updatedUserBy: json["updated_user_by"],
//         isActive: json["is_active"],
//         createdAt: DateTime.parse(json["created_at"]),
//         id: json["id"],
//         playlistId: json["playlist_id"],
//         createdBy: json["created_by"],
//         updatedBy: json["updated_by"],
//         isDelete: json["is_delete"],
//       );

//   Map<String, dynamic> toMap() => {
//         "song_id": songId,
//         "updated_at": updatedAt,
//         "created_user_by": createdUserBy,
//         "updated_user_by": updatedUserBy,
//         "is_active": isActive,
//         "created_at": createdAt.toIso8601String(),
//         "id": id,
//         "playlist_id": playlistId,
//         "created_by": createdBy,
//         "updated_by": updatedBy,
//         "is_delete": isDelete,
//       };
// }
