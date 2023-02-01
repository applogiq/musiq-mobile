class CollectionModel {
  CollectionModel(
      {required this.id,
      required this.albumId,
      required this.songName,
      required this.albumName,
      required this.musicDirectorName});

  String albumId;
  String albumName;
  int id;
  String musicDirectorName;
  String songName;

  // factory SongListModel.fromMap(Map<String, dynamic> json) => SongListModel(
  //       id: json["id"],
  //       songName: json["song_name"],
  //       albumId: json["album_id"],
  //       albumName: json["album_name"],
  //       musicDirectorName:
  //           List<String>.from(json["music_director_name"].map((x) => x)),
  //     );
}
