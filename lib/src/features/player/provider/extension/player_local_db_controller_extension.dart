import 'package:musiq/src/features/player/provider/player_provider.dart';

extension PlayerLocalDatabaseController on PlayerProvider {
  removeAllData() async {
    // await getApplicationDocumentsDirectory().then((Directory dir) {
    //   store =
    //       Store(getObjectBoxModel(), directory: '\$\{dir\.path\}/musiq/db/1');
    //   final favouriteBox = store.box<FavouriteSong>();
    //   final queueBox = store.box<SongListModel>();
    //   favouriteBox.removeAll();
    //   queueBox.removeAll();
    //   store.close();
    // });
  }
}
