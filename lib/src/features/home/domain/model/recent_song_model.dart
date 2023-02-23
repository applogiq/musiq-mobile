class RecentlyPlayed {
  RecentlyPlayed({
    required this.success,
    required this.message,
    required this.records,
    required this.totalrecords,
  });

  factory RecentlyPlayed.fromMap(Map<String, dynamic> json) => RecentlyPlayed(
        success: json["success"],
        message: json["message"],
        records: List<List<Record>>.from(json["records"]
            .map((x) => List<Record>.from(x.map((x) => Record.fromMap(x))))),
        totalrecords: json["totalrecords"],
      );

  String message;
  List<List<Record>> records;
  bool success;
  int totalrecords;

  Map<String, dynamic> toMap() => {
        "success": success,
        "message": message,
        "records": List<dynamic>.from(
            records.map((x) => List<dynamic>.from(x.map((x) => x.toMap())))),
        "totalrecords": totalrecords,
      };
}

class Record {
  Record({
    required this.id,
    required this.songName,
    required this.albumId,
    required this.albumName,
    required this.duration,
    required this.premiumStatus,
    required this.musicDirectorName,
  });

  factory Record.fromMap(Map<String, dynamic> json) => Record(
        id: json["id"],
        songName: json["song_name"],
        albumId: json["album_id"],
        albumName: json["album_name"],
        premiumStatus: json["premium_status"],
        musicDirectorName:
            List<String>.from(json["music_director_name"].map((x) => x)),
        duration: json["duration"],
      );

  String albumId;
  String albumName;
  int id;
  String duration;
  List<String> musicDirectorName;
  String premiumStatus;
  String songName;

  Map<String, dynamic> toMap() => {
        "id": id,
        "song_name": songName,
        "album_id": albumId,
        "duration": duration,
        "album_name": albumName,
        "music_director_name":
            List<dynamic>.from(musicDirectorName.map((x) => x)),
      };
}
