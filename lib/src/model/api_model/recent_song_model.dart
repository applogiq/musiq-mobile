// To parse this JSON data, do
//
//     final recentlyPlayed = recentlyPlayedFromMap(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

RecentlyPlayed recentlyPlayedFromMap(String str) => RecentlyPlayed.fromMap(json.decode(str));

String recentlyPlayedToMap(RecentlyPlayed data) => json.encode(data.toMap());

class RecentlyPlayed {
    RecentlyPlayed({
        required this.success,
        required this.message,
        required this.records,
        required this.totalrecords,
    });

    bool success;
    String message;
    List<Record> records;
    int totalrecords;

    factory RecentlyPlayed.fromMap(Map<String, dynamic> json) => RecentlyPlayed(
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
        musicDirectorName: List<String>.from(json["music_director_name"].map((x) => x)),
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "song_name": songName,
        "album_id": albumId,
        "album_name": albumName,
        "music_director_name": List<dynamic>.from(musicDirectorName.map((x) => x)),
    };
}
