// To parse this JSON data, do
//
//     final searchSongModel = searchSongModelFromMap(jsonString);

import 'dart:convert';

SearchSongModel searchSongModelFromMap(String str) =>
    SearchSongModel.fromMap(json.decode(str));

String searchSongModelToMap(SearchSongModel data) => json.encode(data.toMap());

class SearchSongModel {
  SearchSongModel({
    required this.success,
    required this.message,
    required this.records,
    required this.totalrecords,
  });

  final bool success;
  final String message;
  final List<Record> records;
  final int totalrecords;

  factory SearchSongModel.fromMap(Map<String, dynamic> json) => SearchSongModel(
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
    required this.id,
    required this.songName,
    required this.songId,
    required this.albumName,
    required this.albumId,
    required this.musicDirectorName,
  });

  final int id;
  final String songName;
  final String songId;
  final String albumName;
  final String albumId;
  final List<String> musicDirectorName;

  factory Record.fromMap(Map<String, dynamic> json) => Record(
        id: json["id"],
        songName: json["song_name"],
        songId: json["song_id"],
        albumName: json["album_name"],
        albumId: json["album_id"],
        musicDirectorName:
            List<String>.from(json["music_director_name"].map((x) => x)),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "song_name": songName,
        "song_id": songId,
        "album_name": albumName,
        "album_id": albumId,
        "music_director_name":
            List<dynamic>.from(musicDirectorName.map((x) => x)),
      };
}
