// To parse this JSON data, do
//
//     final searchSongModel = searchSongModelFromMap(jsonString);

class SearchSongModel {
  SearchSongModel({
    required this.success,
    required this.message,
    required this.records,
    required this.totalrecords,
  });

  factory SearchSongModel.fromMap(Map<String, dynamic> json) => SearchSongModel(
        success: json["success"],
        message: json["message"],
        records:
            List<Record>.from(json["records"].map((x) => Record.fromMap(x))),
        totalrecords: json["totalrecords"],
      );

  final String message;
  final List<Record> records;
  final bool success;
  final int totalrecords;

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

  factory Record.fromMap(Map<String, dynamic> json) => Record(
        id: json["id"],
        songName: json["song_name"],
        songId: json["song_id"],
        albumName: json["album_name"],
        albumId: json["album_id"],
        musicDirectorName:
            List<String>.from(json["music_director_name"].map((x) => x)),
      );

  final String albumId;
  final String albumName;
  final int id;
  final List<String> musicDirectorName;
  final String songId;
  final String songName;

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
