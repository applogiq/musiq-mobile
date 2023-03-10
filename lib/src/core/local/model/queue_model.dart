import 'package:objectbox/objectbox.dart';

@Entity()
class SongListModel {
  SongListModel(
      {this.id = 0,
      required this.songId,
      required this.albumName,
      required this.title,
      required this.musicDirectorName,
      required this.imageUrl,
      required this.songUrl,
      required this.duration,
      required this.isImage});

  String albumName;
  @Id(assignable: true)
  int id;

  String imageUrl;
  String musicDirectorName;
  int songId;
  String songUrl;
  String title;
  String duration;
  bool isImage;
}
