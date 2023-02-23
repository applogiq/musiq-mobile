class PlaylistSongListModel {
  PlaylistSongListModel({
    required this.success,
    required this.message,
    required this.records,
    required this.totalRecords,
  });

  factory PlaylistSongListModel.fromMap(Map<String, dynamic> json) =>
      PlaylistSongListModel(
        success: json["success"],
        message: json["message"],
        records:
            List<Record>.from(json["records"].map((x) => Record.fromMap(x))),
        totalRecords: json["total_records"],
      );

  final String message;
  final List<Record> records;
  final bool success;
  final int totalRecords;

  Map<String, dynamic> toMap() => {
        "success": success,
        "message": message,
        "records": List<dynamic>.from(records.map((x) => x.toMap())),
        "total_records": totalRecords,
      };
}

class Record {
  Record({
    required this.playlistSongs,
    required this.id,
    required this.playlistName,
    required this.noOfSongs,
    required this.songId,
    required this.songName,
    required this.albumId,
    required this.albumName,
    required this.musicDirectorName,
    required this.isImage,
    required this.duration,
    required this.premiumStatus,
  });

  factory Record.fromMap(Map<String, dynamic> json) => Record(
        playlistSongs: PlaylistSongs.fromMap(json["playlist_songs"]),
        id: json["id"],
        playlistName: json["playlist_name"],
        noOfSongs: json["no_of_songs"],
        songId: json["song_id"],
        songName: json["song_name"],
        albumId: json["album_id"],
        duration: json["duration"],
        albumName: json["album_name"],
        premiumStatus: json["premium_status"]!,
        musicDirectorName:
            List<String>.from(json["music_director_name"].map((x) => x)),
        isImage: json["is_image"],
      );

  final String albumId;
  final String albumName;
  final int id;
  final bool isImage;
  final List<String> musicDirectorName;
  final int noOfSongs;
  final String playlistName;
  final PlaylistSongs playlistSongs;
  final String premiumStatus;
  final String songId;
  final String songName;
  final String duration;

  Map<String, dynamic> toMap() => {
        "playlist_songs": playlistSongs.toMap(),
        "id": id,
        "playlist_name": playlistName,
        "no_of_songs": noOfSongs,
        "song_id": songId,
        "song_name": songName,
        "album_id": albumId,
        "album_name": albumName,
        "duration": duration,
        "music_director_name":
            List<dynamic>.from(musicDirectorName.map((x) => x)),
        "is_image": isImage,
      };
}

class PlaylistSongs {
  PlaylistSongs({
    required this.createdAt,
    required this.id,
    required this.createdBy,
    required this.updatedBy,
    required this.isDelete,
    required this.updatedAt,
    required this.songId,
    required this.playlistId,
    required this.createdUserBy,
    required this.updatedUserBy,
    required this.isActive,
  });

  factory PlaylistSongs.fromMap(Map<String, dynamic> json) => PlaylistSongs(
        createdAt: DateTime.parse(json["created_at"]),
        id: json["id"],
        createdBy: json["created_by"],
        updatedBy: json["updated_by"],
        isDelete: json["is_delete"],
        updatedAt: json["updated_at"],
        songId: json["song_id"],
        playlistId: json["playlist_id"],
        createdUserBy: json["created_user_by"],
        updatedUserBy: json["updated_user_by"],
        isActive: json["is_active"],
      );

  final DateTime createdAt;
  final int createdBy;
  final dynamic createdUserBy;
  final int id;
  final bool isActive;
  final bool isDelete;
  final int playlistId;
  final int songId;
  final dynamic updatedAt;
  final dynamic updatedBy;
  final dynamic updatedUserBy;

  Map<String, dynamic> toMap() => {
        "created_at": createdAt.toIso8601String(),
        "id": id,
        "created_by": createdBy,
        "updated_by": updatedBy,
        "is_delete": isDelete,
        "updated_at": updatedAt,
        "song_id": songId,
        "playlist_id": playlistId,
        "created_user_by": createdUserBy,
        "updated_user_by": updatedUserBy,
        "is_active": isActive,
      };
}
