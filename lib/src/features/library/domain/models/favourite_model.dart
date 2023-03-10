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
    required this.duration,
    required this.albumName,
    required this.musicDirectorName,
    required this.isImage,
    required this.premiumStatus,
  });

  factory Record.fromMap(Map<String, dynamic> json) => Record(
        id: json["id"],
        songName: json["song_name"],
        albumId: json["album_id"],
        albumName: json["album_name"],
        duration: json["duration"],
        premiumStatus: json["premium_status"],
        isImage: json["is_image"],
        musicDirectorName:
            List<String>.from(json["music_director_name"].map((x) => x)),
      );

  String albumId;
  String albumName;
  int id;
  String duration;
  List<String> musicDirectorName;
  String songName;
  bool isImage;

  String premiumStatus;

  Map<String, dynamic> toMap() => {
        "id": id,
        "song_name": songName,
        "album_id": albumId,
        "album_name": albumName,
        "duration": duration,
        "music_director_name":
            List<dynamic>.from(musicDirectorName.map((x) => x)),
      };
}
