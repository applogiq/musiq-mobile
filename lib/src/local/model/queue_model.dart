import 'package:objectbox/objectbox.dart';

@Entity()
class QueueSongModel {
  @Id(assignable: true)
  int id;
  int currentIndex;
  double lastposition;
  SongListModel songList;

  QueueSongModel({
    this.id = 0,
    required this.currentIndex,
    required this.lastposition,
    required this.songList,
  });
}

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
