import 'package:objectbox/objectbox.dart';

@Entity()
class SearchArtistLocalModel {
  SearchArtistLocalModel({
    this.id = 0,
    required this.searchName,
  });

  @Id(assignable: true)
  int id;

  String searchName;
}

@Entity()
class SearchSongLocalModel {
  SearchSongLocalModel({
    this.id = 0,
    required this.searchName,
  });

  @Id(assignable: true)
  int id;

  String searchName;
}
