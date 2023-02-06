class PlayerSongListModel {
  PlayerSongListModel(
      {required this.id,
      required this.duration,
      required this.albumName,
      required this.title,
      required this.imageUrl,
      required this.musicDirectorName});

  final String albumName;
  final int id;
  final String imageUrl;
  final String musicDirectorName;
  final String title;
  final String duration;
}
