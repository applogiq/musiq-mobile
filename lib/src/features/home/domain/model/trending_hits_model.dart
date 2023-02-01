// To parse this JSON data, do
//
//     final trendingHitsModel = trendingHitsModelFromMap(jsonString);

import 'dart:convert';

TrendingHitsModel trendingHitsModelFromMap(String str) =>
    TrendingHitsModel.fromMap(json.decode(str));

String trendingHitsModelToMap(TrendingHitsModel data) =>
    json.encode(data.toMap());

class TrendingHitsModel {
  TrendingHitsModel({
    required this.success,
    required this.message,
    required this.records,
    required this.totalrecords,
  });

  factory TrendingHitsModel.fromMap(Map<String, dynamic> json) =>
      TrendingHitsModel(
        success: json["success"],
        message: json["message"],
        records:
            List<Record>.from(json["records"].map((x) => Record.fromMap(x))),
        totalrecords: json["totalrecords"],
      );

  String message;
  List<Record> records;
  bool success;
  int totalrecords;

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
    required this.lyrics,
    required this.isMusic,
    required this.artistId,
    required this.albumId,
    required this.albumName,
    required this.musicDirectorName,
    required this.isImage,
  });

  factory Record.fromMap(Map<String, dynamic> json) => Record(
        id: json["id"],
        songName: json["song_name"],
        lyrics: json["lyrics"],
        isMusic: json["is_music"],
        artistId: List<int>.from(json["artist_id"].map((x) => x)),
        albumId: json["album_id"],
        albumName: json["album_name"],
        musicDirectorName:
            List<String>.from(json["music_director_name"].map((x) => x)),
        isImage: json["is_image"],
      );

  String albumId;
  String albumName;
  List<int> artistId;
  int id;
  bool isImage;
  bool isMusic;
  String lyrics;
  List<String> musicDirectorName;
  String songName;

  Map<String, dynamic> toMap() => {
        "id": id,
        "song_name": songName,
        "lyrics": lyrics,
        "is_music": isMusic,
        "artist_id": List<dynamic>.from(artistId.map((x) => x)),
        "album_id": albumId,
        "album_name": albumName,
        "music_director_name":
            List<dynamic>.from(musicDirectorName.map((x) => x)),
        "is_image": isImage,
      };
}
