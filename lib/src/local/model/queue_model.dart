import 'package:objectbox/objectbox.dart';

@Entity()
class SongListModel {
  @Id(assignable: true)
  int id;
  int songId;
  String albumName;
  String title;
  String musicDirectorName;
  String imageUrl;
  String songUrl;
  SongListModel(
      {this.id = 0,
      required this.songId,
      required this.albumName,
      required this.title,
      required this.musicDirectorName,
      required this.imageUrl,
      required this.songUrl});
}
