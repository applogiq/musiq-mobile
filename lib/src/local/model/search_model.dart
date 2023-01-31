import 'package:objectbox/objectbox.dart';

@Entity()
class SearchArtistLocalModel {
  @Id(assignable: true)
  int id;
  String searchName;

  SearchArtistLocalModel({
    this.id = 0,
    required this.searchName,
  });
}

@Entity()
class SearchSongLocalModel {
  @Id(assignable: true)
  int id;
  String searchName;

  SearchSongLocalModel({
    this.id = 0,
    required this.searchName,
  });
}
