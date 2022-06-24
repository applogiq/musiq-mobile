// To parse this JSON data, do
//
//     final recentPlayed = recentPlayedFromMap(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

RecentPlayed recentPlayedFromMap(String str) => RecentPlayed.fromMap(json.decode(str));

String recentPlayedToMap(RecentPlayed data) => json.encode(data.toMap());

class RecentPlayed {
    RecentPlayed({
        required this.records,
        required this.totalrecords,
        required this.success,
    });

    List<Record> records;
    int totalrecords;
    bool success;

    factory RecentPlayed.fromMap(Map<String, dynamic> json) => RecentPlayed(
        records: List<Record>.from(json["records"].map((x) => Record.fromMap(x))),
        totalrecords: json["totalrecords"],
        success: json["success"],
    );

    Map<String, dynamic> toMap() => {
        "records": List<dynamic>.from(records.map((x) => x.toMap())),
        "totalrecords": totalrecords,
        "success": success,
    };
}

class Record {
    Record({
        required this.songs,
        required this.albumId,
        required this.name,
        required this.musicDirectorName,
    });

    Songs? songs;
    String albumId;
    String name;
    List<String> musicDirectorName;

    factory Record.fromMap(Map<String, dynamic> json) => Record(
        songs: Songs.fromMap(json["songs"]),
        albumId: json["album_id"],
        name: json["name"],
        musicDirectorName: List<String>.from(json["music_director_name"].map((x) => x)),
    );

    Map<String, dynamic> toMap() => {
        "songs": songs!.toMap(),
        "album_id": albumId,
        "name": name,
        "music_director_name": List<dynamic>.from(musicDirectorName.map((x) => x)),
    };
}

class Songs {
    Songs({
        required this.artistId,
         required this.isActive,
        required this.albumId,
        required this.songSize,
        required this.genreId,
        required this.isMusic,
        required this.duration,
        required this.lyrics,
         required this.songId,
        required this.listeners,
         required this.id,
        required this.label,
         required this.name,
        required this.isDelete,
    });

    List<int> artistId;
    // DateTime releasedDate;
    bool isActive;
    int albumId;
    String songSize;
    GenreId genreId;
    bool isMusic;
    String duration;
    // DateTime createdAt;
    String lyrics;
    // DateTime updatedAt;
    String songId;
    dynamic listeners;
    int id;
    String label;
    String name;
    bool isDelete;

    factory Songs.fromMap(Map<String, dynamic> json) => Songs(
        artistId: List<int>.from(json["artist_id"].map((x) => x)),
        // releasedDate: DateTime.parse(json["released_date"]),
        isActive: json["is_active"],
        albumId: json["album_id"],
        songSize: json["song_size"],
        genreId: GenreId.fromMap(json["genre_id"]),
        isMusic: json["is_music"],
        duration: json["duration"],
        // createdAt: DateTime.parse(json["created_at"]),
        lyrics: json["lyrics"],
        // updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        songId: json["song_id"],
        listeners: json["listeners"],
        // createdBy: json["created_by"],
        id: json["id"],
        label: json["label"],
        // updatedBy: json["updated_by"] == null ? null : json["updated_by"],
        name: json["name"],
        isDelete: json["is_delete"],
    );

    Map<String, dynamic> toMap() => {
        "artist_id": List<dynamic>.from(artistId.map((x) => x)),
        // "released_date": "${releasedDate.year.toString().padLeft(4, '0')}-${releasedDate.month.toString().padLeft(2, '0')}-${releasedDate.day.toString().padLeft(2, '0')}",
        "is_active": isActive,
        "album_id": albumId,
        "song_size": songSize,
        "genre_id": genreId.toMap(),
        "is_music": isMusic,
        "duration": duration,
        // "created_at": createdAt.toIso8601String(),
        "lyrics": lyrics,
        // "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
        "song_id": songId,
        "listeners": listeners,
        // "created_by": createdBy,
        "id": id,
        "label": label,
        // "updated_by": updatedBy == null ? null : updatedBy,
        "name": name,
        "is_delete": isDelete,
    };
}

class GenreId {
    GenreId({
        required this.genres,
    });

    List<String> genres;

    factory GenreId.fromMap(Map<String, dynamic> json) => GenreId(
        genres: List<String>.from(json["genres"].map((x) => x)),
    );

    Map<String, dynamic> toMap() => {
        "genres": List<dynamic>.from(genres.map((x) => x)),
    };
}
