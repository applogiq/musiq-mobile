import 'dart:convert';

FavouriteModel favouriteFromMap(String str) =>
    FavouriteModel.fromMap(json.decode(str));

String favouriteToMap(FavouriteModel data) => json.encode(data.toMap());

class FavouriteModel {
  FavouriteModel({
    required this.success,
    required this.message,
    required this.records,
    required this.totalRecords,
  });

  factory FavouriteModel.fromMap(Map<String, dynamic> json) => FavouriteModel(
        success: json["success"],
        message: json["message"],
        records:
            List<Record>.from(json["records"].map((x) => Record.fromMap(x))),
        totalRecords: json["total_records"],
      );

  String message;
  List<Record> records;
  bool success;
  int totalRecords;

  Map<String, dynamic> toMap() => {
        "success": success,
        "message": message,
        "records": List<dynamic>.from(records.map((x) => x.toMap())),
        "total_records": totalRecords,
      };
}

class Record {
  Record({
    required this.id,
    required this.songName,
    required this.albumId,
    required this.albumName,
    required this.musicDirectorName,
  });

  factory Record.fromMap(Map<String, dynamic> json) => Record(
        id: json["id"],
        songName: json["song_name"],
        albumId: json["album_id"],
        albumName: json["album_name"],
        musicDirectorName:
            List<String>.from(json["music_director_name"].map((x) => x)),
      );

  String albumId;
  String albumName;
  int id;
  List<String> musicDirectorName;
  String songName;

  Map<String, dynamic> toMap() => {
        "id": id,
        "song_name": songName,
        "album_id": albumId,
        "album_name": albumName,
        "music_director_name":
            List<dynamic>.from(musicDirectorName.map((x) => x)),
      };
}
