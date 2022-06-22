// To parse this JSON data, do
//
//     final songList = songListFromMap(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

SongList songListFromMap(String str) => SongList.fromMap(json.decode(str));

String songListToMap(SongList data) => json.encode(data.toMap());

class SongList {
    SongList({
        required this.success,
        required this.message,
        required this.records,
        required this.totalrecords,
    });

    bool success;
    String message;
    List<Record> records;
    int totalrecords;

    factory SongList.fromMap(Map<String, dynamic> json) => SongList(
        success: json["success"],
        message: json["message"],
        records: List<Record>.from(json["records"].map((x) => Record.fromMap(x))),
        totalrecords: json["totalrecords"],
    );

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
        required this.name,
        required this.artistId,
        required this.albumId,
        required this.genreId,
        required this.duration,
        required this.lyrics,
        required this.releasedDate,
        required this.songSize,
        required this.label,
        required this.music,
        required this.songId,
        required this.albumDetails,
    });

    int id;
    String name;
    List<int> artistId;
    String albumId;
    GenreId genreId;
    String duration;
    String lyrics;
    DateTime releasedDate;
    String songSize;
    String label;
    dynamic music;
    String songId;
    AlbumDetails albumDetails;

    factory Record.fromMap(Map<String, dynamic> json) => Record(
        id: json["id"],
        name: json["name"],
        artistId: List<int>.from(json["artist_id"].map((x) => x)),
        albumId: json["album_id"],
        genreId: GenreId.fromMap(json["genre_id"]),
        duration: json["duration"],
        lyrics: json["lyrics"],
        releasedDate: DateTime.parse(json["released_date"]),
        songSize: json["song_size"],
        label: json["label"],
        music: json["music"],
        songId: json["song_id"],
        albumDetails: AlbumDetails.fromMap(json["album_details"]),
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "artist_id": List<dynamic>.from(artistId.map((x) => x)),
        "album_id": albumId,
        "genre_id": genreId.toMap(),
        "duration": duration,
        "lyrics": lyrics,
        "released_date": "${releasedDate.year.toString().padLeft(4, '0')}-${releasedDate.month.toString().padLeft(2, '0')}-${releasedDate.day.toString().padLeft(2, '0')}",
        "song_size": songSize,
        "label": label,
        "music": music,
        "song_id": songId,
        "album_details": albumDetails.toMap(),
    };
}

class AlbumDetails {
    AlbumDetails({
        required this.id,
        required this.albumId,
        required this.noOfSongs,
        required this.name,
        required this.releasedYear,
        required this.musicDirector,
        required this.musicDirectorName,
        required this.isImage,
    });

    int id;
    String albumId;
    int noOfSongs;
    String name;
    int releasedYear;
    List<int> musicDirector;
    List<String> musicDirectorName;
    int isImage;

    factory AlbumDetails.fromMap(Map<String, dynamic> json) => AlbumDetails(
        id: json["id"],
        albumId: json["album_id"],
        noOfSongs: json["no_of_songs"],
        name: json["name"],
        releasedYear: json["released_year"],
        musicDirector: List<int>.from(json["music_director"].map((x) => x)),
        musicDirectorName: List<String>.from(json["music_director_name"].map((x) => x)),
        isImage: json["is_image"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "album_id": albumId,
        "no_of_songs": noOfSongs,
        "name": name,
        "released_year": releasedYear,
        "music_director": List<dynamic>.from(musicDirector.map((x) => x)),
        "music_director_name": List<dynamic>.from(musicDirectorName.map((x) => x)),
        "is_image": isImage,
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
