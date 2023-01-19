class PlayerSongListModel {
  final int id;
  final String albumName;
  final String title;
  final String imageUrl;
  final String musicDirectorName;

  PlayerSongListModel(
      {required this.id,
      required this.albumName,
      required this.title,
      required this.imageUrl,
      required this.musicDirectorName});
}
