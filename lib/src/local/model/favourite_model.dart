import 'package:objectbox/objectbox.dart';

@Entity()
class FavouriteSong {
  @Id(assignable: true)
  int songUniqueId;

  FavouriteSong({
    required this.songUniqueId,
  });
}
