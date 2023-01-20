// To parse this JSON data, do
//
//     final songInfoModel = songInfoModelFromMap(jsonString);

import 'dart:convert';

SongInfoModel songInfoModelFromMap(String str) =>
    SongInfoModel.fromMap(json.decode(str));

String songInfoModelToMap(SongInfoModel data) => json.encode(data.toMap());

class SongInfoModel {
  SongInfoModel({
    required this.success,
    required this.message,
    required this.records,
    required this.totalrecords,
  });

  final bool success;
  final String message;
  final Records records;
  final int totalrecords;

  factory SongInfoModel.fromMap(Map<String, dynamic> json) => SongInfoModel(
        success: json["success"],
        message: json["message"],
        records: Records.fromMap(json["records"]),
        totalrecords: json["totalrecords"],
      );

  Map<String, dynamic> toMap() => {
        "success": success,
        "message": message,
        "records": records.toMap(),
        "totalrecords": totalrecords,
      };
}

class Records {
  Records({
    required this.id,
    required this.artistId,
    required this.songSize,
    required this.albumId,
    required this.isMusic,
    required this.genreId,
    required this.createdAt,
    required this.duration,
    required this.updatedAt,
    required this.lyrics,
    required this.createdBy,
    required this.listeners,
    required this.updatedBy,
    required this.songId,
    required this.label,
    required this.isDelete,
    required this.songName,
    required this.releasedDate,
    required this.isActive,
    required this.albumDetails,
    required this.artistDetails,
  });

  final int id;
  final List<int> artistId;
  final String songSize;
  final int albumId;
  final bool isMusic;
  final GenreId genreId;
  final DateTime createdAt;
  final String duration;
  final dynamic updatedAt;
  final String lyrics;
  final int createdBy;
  final int? listeners;
  final dynamic updatedBy;
  final String songId;
  final String label;
  final bool isDelete;
  final String songName;
  final DateTime releasedDate;
  final bool isActive;
  final AlbumDetails albumDetails;
  final List<ArtistDetail> artistDetails;

  factory Records.fromMap(Map<String, dynamic> json) => Records(
        id: json["id"],
        artistId: List<int>.from(json["artist_id"].map((x) => x)),
        songSize: json["song_size"],
        albumId: json["album_id"],
        isMusic: json["is_music"],
        genreId: GenreId.fromMap(json["genre_id"]),
        createdAt: DateTime.parse(json["created_at"]),
        duration: json["duration"],
        updatedAt: json["updated_at"],
        lyrics: json["lyrics"],
        createdBy: json["created_by"],
        listeners: json["listeners"],
        updatedBy: json["updated_by"],
        songId: json["song_id"],
        label: json["label"],
        isDelete: json["is_delete"],
        songName: json["song_name"],
        releasedDate: DateTime.parse(json["released_date"]),
        isActive: json["is_active"],
        albumDetails: AlbumDetails.fromMap(json["album_details"]),
        artistDetails: List<ArtistDetail>.from(
            json["artist_details"].map((x) => ArtistDetail.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "artist_id": List<dynamic>.from(artistId.map((x) => x)),
        "song_size": songSize,
        "album_id": albumId,
        "is_music": isMusic,
        "genre_id": genreId.toMap(),
        "created_at": createdAt.toIso8601String(),
        "duration": duration,
        "updated_at": updatedAt,
        "lyrics": lyrics,
        "created_by": createdBy,
        "listeners": listeners,
        "updated_by": updatedBy,
        "song_id": songId,
        "label": label,
        "is_delete": isDelete,
        "song_name": songName,
        "released_date":
            "${releasedDate.year.toString().padLeft(4, '0')}-${releasedDate.month.toString().padLeft(2, '0')}-${releasedDate.day.toString().padLeft(2, '0')}",
        "is_active": isActive,
        "album_details": albumDetails.toMap(),
        "artist_details":
            List<dynamic>.from(artistDetails.map((x) => x.toMap())),
      };
}

class AlbumDetails {
  AlbumDetails({
    required this.id,
    required this.releasedYear,
    required this.musicDirector,
    required this.isImage,
    required this.updatedAt,
    required this.updatedBy,
    required this.isActive,
    required this.albumId,
    required this.albumName,
    required this.noOfSongs,
    required this.musicDirectorName,
    required this.createdAt,
    required this.createdBy,
    required this.isDelete,
  });

  final int id;
  final int releasedYear;
  final List<int> musicDirector;
  final bool isImage;
  final dynamic updatedAt;
  final dynamic updatedBy;
  final bool isActive;
  final String albumId;
  final String albumName;
  final int noOfSongs;
  final List<String> musicDirectorName;
  final DateTime createdAt;
  final int createdBy;
  final bool isDelete;

  factory AlbumDetails.fromMap(Map<String, dynamic> json) => AlbumDetails(
        id: json["id"],
        releasedYear: json["released_year"],
        musicDirector: List<int>.from(json["music_director"].map((x) => x)),
        isImage: json["is_image"],
        updatedAt: json["updated_at"],
        updatedBy: json["updated_by"],
        isActive: json["is_active"],
        albumId: json["album_id"],
        albumName: json["album_name"],
        noOfSongs: json["no_of_songs"],
        musicDirectorName:
            List<String>.from(json["music_director_name"].map((x) => x)),
        createdAt: DateTime.parse(json["created_at"]),
        createdBy: json["created_by"],
        isDelete: json["is_delete"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "released_year": releasedYear,
        "music_director": List<dynamic>.from(musicDirector.map((x) => x)),
        "is_image": isImage,
        "updated_at": updatedAt,
        "updated_by": updatedBy,
        "is_active": isActive,
        "album_id": albumId,
        "album_name": albumName,
        "no_of_songs": noOfSongs,
        "music_director_name":
            List<dynamic>.from(musicDirectorName.map((x) => x)),
        "created_at": createdAt.toIso8601String(),
        "created_by": createdBy,
        "is_delete": isDelete,
      };
}

class ArtistDetail {
  ArtistDetail({
    required this.followers,
    required this.id,
    required this.createdAt,
    required this.createdBy,
    required this.isDelete,
    required this.artistId,
    required this.artistName,
    required this.isImage,
    required this.updatedAt,
    required this.updatedBy,
    required this.isActive,
  });

  final int followers;
  final int id;
  final DateTime createdAt;
  final int createdBy;
  final bool isDelete;
  final String artistId;
  final String artistName;
  final bool isImage;
  final dynamic updatedAt;
  final dynamic updatedBy;
  final bool isActive;

  factory ArtistDetail.fromMap(Map<String, dynamic> json) => ArtistDetail(
        followers: json["followers"],
        id: json["id"],
        createdAt: DateTime.parse(json["created_at"]),
        createdBy: json["created_by"],
        isDelete: json["is_delete"],
        artistId: json["artist_id"],
        artistName: json["artist_name"],
        isImage: json["is_image"],
        updatedAt: json["updated_at"],
        updatedBy: json["updated_by"],
        isActive: json["is_active"],
      );

  Map<String, dynamic> toMap() => {
        "followers": followers,
        "id": id,
        "created_at": createdAt.toIso8601String(),
        "created_by": createdBy,
        "is_delete": isDelete,
        "artist_id": artistId,
        "artist_name": artistName,
        "is_image": isImage,
        "updated_at": updatedAt,
        "updated_by": updatedBy,
        "is_active": isActive,
      };
}

class GenreId {
  GenreId({
    required this.genres,
  });

  final List<String> genres;

  factory GenreId.fromMap(Map<String, dynamic> json) => GenreId(
        genres: List<String>.from(json["genres"].map((x) => x)),
      );

  Map<String, dynamic> toMap() => {
        "genres": List<dynamic>.from(genres.map((x) => x)),
      };
}
