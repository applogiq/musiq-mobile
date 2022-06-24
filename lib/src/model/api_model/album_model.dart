
import 'dart:convert';

Album albumFromMap(String str) => Album.fromMap(json.decode(str));

String albumToMap(Album data) => json.encode(data.toMap());

class Album {
    Album({
        required this.success,
        required this.message,
        required this.records,
        required this.totalrecords,
    });

    bool success;
    String message;
    List<Record> records;
    int totalrecords;

    factory Album.fromMap(Map<String, dynamic> json) => Album(
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

    factory Record.fromMap(Map<String, dynamic> json) => Record(
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
