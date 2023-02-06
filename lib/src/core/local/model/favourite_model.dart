import 'package:objectbox/objectbox.dart';

@Entity()
class FavouriteSong {
  FavouriteSong({
    required this.songUniqueId,
  });

  @Id(assignable: true)
  int songUniqueId;
}
