// To parse this JSON data, do
//

class NewReleaseModel {
  NewReleaseModel({
    required this.success,
    required this.message,
    required this.records,
    required this.totalrecords,
  });

  factory NewReleaseModel.fromMap(Map<String, dynamic> json) => NewReleaseModel(
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
    required this.isMusic,
    required this.artistId,
    required this.albumId,
    required this.albumName,
    required this.musicDirectorName,
    required this.isImage,
    required this.duration,
    required this.premiumStatus,
  });

  factory Record.fromMap(Map<String, dynamic> json) => Record(
        id: json["id"],
        songName: json["song_name"],
        isMusic: json["is_music"],
        artistId: List<int>.from(json["artist_id"].map((x) => x)),
        albumId: json["album_id"],
        albumName: json["album_name"],
        duration: json["duration"],
        premiumStatus: json["premium_status"],
        musicDirectorName:
            List<String>.from(json["music_director_name"].map((x) => x)),
        isImage: json["is_image"],
      );

  String albumId;
  String albumName;
  List<int> artistId;
  int id;
  String premiumStatus;

  bool isImage;
  bool isMusic;
  List<String> musicDirectorName;
  String songName;
  String duration;

  Map<String, dynamic> toMap() => {
        "id": id,
        "song_name": songName,
        "is_music": isMusic,
        "artist_id": List<dynamic>.from(artistId.map((x) => x)),
        "album_id": albumId,
        "duration": duration,
        "album_name": albumName,
        "music_director_name": musicDirectorName,
        "is_image": isImage,
      };
}
