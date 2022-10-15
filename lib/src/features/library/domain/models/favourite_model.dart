import 'dart:convert';

Favourite favouriteFromMap(String str) => Favourite.fromMap(json.decode(str));

String favouriteToMap(Favourite data) => json.encode(data.toMap());

class Favourite {
  Favourite({
    required this.success,
    required this.message,
    required this.records,
    required this.totalRecords,
  });

  bool success;
  String message;
  List<Record> records;
  int totalRecords;

  factory Favourite.fromMap(Map<String, dynamic> json) => Favourite(
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
    required this.id,
    required this.songName,
    required this.albumId,
    required this.albumName,
    required this.musicDirectorName,
  });

  int id;
  String songName;
  String albumId;
  String albumName;
  List<String> musicDirectorName;

  factory Record.fromMap(Map<String, dynamic> json) => Record(
        id: json["id"],
        songName: json["song_name"],
        albumId: json["album_id"],
        albumName: json["album_name"],
        musicDirectorName:
            List<String>.from(json["music_director_name"].map((x) => x)),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "song_name": songName,
        "album_id": albumId,
        "album_name": albumName,
        "music_director_name":
            List<dynamic>.from(musicDirectorName.map((x) => x)),
      };
}
