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
    required this.premiumStatus,
    required this.musicDirectorName,
    required this.isImage,
    required this.duration,
  });

  factory Record.fromMap(Map<String, dynamic> json) => Record(
        id: json["id"],
        songName: json["song_name"],
        songId: json["song_id"],
        albumName: json["album_name"],
        duration: json["duration"],
        albumId: json["album_id"],
        isImage: json["is_image"],
        premiumStatus: json["premium_status"],
        musicDirectorName:
            List<String>.from(json["music_director_name"].map((x) => x)),
      );

  final String albumId;
  final String albumName;
  final int id;
  final List<String> musicDirectorName;
  final String songId;
  final String songName;
  final String premiumStatus;
  final String duration;
  bool isImage;
  Map<String, dynamic> toMap() => {
        "id": id,
        "song_name": songName,
        "song_id": songId,
        "duration": duration,
        "album_name": albumName,
        "album_id": albumId,
        "music_director_name":
            List<dynamic>.from(musicDirectorName.map((x) => x)),
      };
}
