class CollectionModel {
  int id;
  String songName;
  String albumName;
  String albumId;
  String musicDirectorName;

  CollectionModel(
      {required this.id,
      required this.albumId,
      required this.songName,
      required this.albumName,
      required this.musicDirectorName});
  // factory SongListModel.fromMap(Map<String, dynamic> json) => SongListModel(
  //       id: json["id"],
  //       songName: json["song_name"],
  //       albumId: json["album_id"],
  //       albumName: json["album_name"],
  //       musicDirectorName:
  //           List<String>.from(json["music_director_name"].map((x) => x)),
  //     );
}
