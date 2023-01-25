// To parse this JSON data, do
//
//     final albumSongListModel = albumSongListModelFromMap(jsonString);

import 'dart:convert';

AlbumSongListModel albumSongListModelFromMap(String str) =>
    AlbumSongListModel.fromMap(json.decode(str));

String albumSongListModelToMap(AlbumSongListModel data) =>
    json.encode(data.toMap());

class AlbumSongListModel {
  AlbumSongListModel({
    required this.success,
    required this.message,
    required this.records,
    required this.totalrecords,
  });

  final bool success;
  final String message;
  final List<Record> records;
  final int totalrecords;

  factory AlbumSongListModel.fromMap(Map<String, dynamic> json) =>
      AlbumSongListModel(
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
    required this.lyrics,
    required this.isMusic,
    required this.artistId,
    required this.albumId,
    required this.albumName,
    required this.musicDirectorName,
    required this.isImage,
  });

  final int id;
  final String songName;
  final String lyrics;
  final bool isMusic;
  final List<int> artistId;
  final String albumId;
  final String albumName;
  final List<String> musicDirectorName;
  final bool isImage;

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
